#!/usr/bin/env bash
# Deploy finance-agent to RunPod.
# Usage: ./packages/finance-agent/runpod/deploy.sh [gpu-tier]
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
exec "$root/scripts/deploy-runpod.sh" "finance-agent" "${1:-rtx5060ti}"