#!/usr/bin/env bash
# Deploy embodied-ai to Vast.ai.
# Usage: ./packages/embodied-ai/vastai/deploy.sh [gpu-tier]
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
exec "$root/scripts/deploy-vastai.sh" "embodied-ai" "${1:-rtx3090}"