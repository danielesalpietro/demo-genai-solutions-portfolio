#!/usr/bin/env bash
# Reusable TCP readiness helper. Source this file; do not execute directly.
# Usage: wait_for_tcp <host> <port> [timeout_seconds]
set -euo pipefail

wait_for_tcp() {
  local host="${1:?host required}"
  local port="${2:?port required}"
  local timeout="${3:-60}"
  local elapsed=0

  while [[ $elapsed -lt $timeout ]]; do
    if (echo > /dev/tcp/"$host"/"$port") 2>/dev/null; then
      return 0
    fi
    sleep 2
    elapsed=$((elapsed + 2))
  done

  echo "ERROR: $host:$port did not become reachable within ${timeout}s" >&2
  return 1
}

# Usage: wait_for_http <url> [timeout_seconds]
wait_for_http() {
  local url="${1:?url required}"
  local timeout="${2:-60}"
  local elapsed=0

  while [[ $elapsed -lt $timeout ]]; do
    if curl -fsSo /dev/null "$url" 2>/dev/null; then
      return 0
    fi
    sleep 2
    elapsed=$((elapsed + 2))
  done

  echo "ERROR: $url did not return HTTP 2xx within ${timeout}s" >&2
  return 1
}
