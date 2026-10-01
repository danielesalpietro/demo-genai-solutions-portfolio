#!/usr/bin/env bash
# Deploy supply-chain-agent to Vast.ai.
# Usage: ./packages/supply-chain-agent/vastai/deploy.sh [gpu-tier]
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
exec "$root/scripts/deploy-vastai.sh" "supply-chain-agent" "${1:-rtx5060ti}"