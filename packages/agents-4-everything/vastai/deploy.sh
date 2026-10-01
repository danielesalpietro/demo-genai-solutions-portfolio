#!/usr/bin/env bash
# Deploy agents-4-everything to Vast.ai.
# Usage: ./packages/agents-4-everything/vastai/deploy.sh [gpu-tier]
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
exec "$root/scripts/deploy-vastai.sh" "agents-4-everything" "${1:-rtx5060ti}"