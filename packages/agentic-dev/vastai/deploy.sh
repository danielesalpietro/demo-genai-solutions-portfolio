#!/usr/bin/env bash
# Deploy agentic-dev to Vast.ai.
# Usage: ./packages/agentic-dev/vastai/deploy.sh [gpu-tier]
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
exec "$root/scripts/deploy-vastai.sh" "agentic-dev" "${1:-rtx5060ti}"