#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
port="${DEMO_PORT:-18080}"
case "${1:-}" in
  check) docker version >/dev/null; docker compose version >/dev/null; docker compose config --quiet ;;
  start) docker compose up -d --wait ;;
  run) curl --fail --silent "http://127.0.0.1:${port}/" ;;
  status) docker compose ps ;;
  stop) docker compose down --remove-orphans ;;
  reset) docker compose down --volumes --remove-orphans ;;
  *) echo "usage: $0 {check|start|run|status|stop|reset}"; exit 2 ;;
esac
