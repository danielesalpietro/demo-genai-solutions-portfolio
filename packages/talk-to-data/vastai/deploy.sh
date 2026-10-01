#!/usr/bin/env bash
# Deploy talk-to-data to Vast.ai.
# Usage: ./packages/talk-to-data/vastai/deploy.sh [gpu-tier]
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
exec "$root/scripts/deploy-vastai.sh" "talk-to-data" "${1:-rtx5060ti}"