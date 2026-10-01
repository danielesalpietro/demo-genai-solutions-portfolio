#!/usr/bin/env bash
# Deploy finance-agent to Vast.ai.
# Usage: ./packages/finance-agent/vastai/deploy.sh [gpu-tier]
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
exec "$root/scripts/deploy-vastai.sh" "finance-agent" "${1:-rtx5060ti}"