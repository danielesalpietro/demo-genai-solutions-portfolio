#!/usr/bin/env bash
# Private RAG — idempotent reset
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

docker compose down -v --remove-orphans 2>/dev/null || true
rm -f /tmp/owui-token
