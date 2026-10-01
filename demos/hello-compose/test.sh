#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
port="${DEMO_PORT:-18080}"
for _ in $(seq 1 30); do
  curl --fail --silent "http://127.0.0.1:${port}/health" | grep -qx ok && exit 0
  sleep 1
done
echo "Health check failed" >&2
exit 1
