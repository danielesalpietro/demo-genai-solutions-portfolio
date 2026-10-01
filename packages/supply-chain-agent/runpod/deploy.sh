#!/usr/bin/env bash
# Deploy supply-chain-agent to RunPod.
# Usage: ./packages/supply-chain-agent/runpod/deploy.sh [gpu-tier]
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
exec "$root/scripts/deploy-runpod.sh" "supply-chain-agent" "${1:-rtx5060ti}"