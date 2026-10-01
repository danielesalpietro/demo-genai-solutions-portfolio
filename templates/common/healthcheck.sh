#!/usr/bin/env bash
# Reusable healthcheck helper. Source this file; do not execute directly.
# Usage: wait_healthy <service> [timeout_seconds]
set -euo pipefail

wait_healthy() {
  local service="${1:?service name required}"
  local timeout="${2:-60}"
  local elapsed=0
  local status

  while [[ $elapsed -lt $timeout ]]; do
    status=$(docker compose ps --format json "$service" 2>/dev/null \
      | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('Health',''))" 2>/dev/null || echo "")
    if [[ "$status" == "healthy" ]]; then
      return 0
    fi
    sleep 2
    elapsed=$((elapsed + 2))
  done

  echo "ERROR: service '$service' did not reach healthy state within ${timeout}s" >&2
  return 1
}
