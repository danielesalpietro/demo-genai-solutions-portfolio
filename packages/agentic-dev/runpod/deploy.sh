#!/usr/bin/env bash
# Deploy agentic-dev to RunPod.
# Usage: ./packages/agentic-dev/runpod/deploy.sh [gpu-tier]
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
exec "$root/scripts/deploy-runpod.sh" "agentic-dev" "${1:-rtx5060ti}"