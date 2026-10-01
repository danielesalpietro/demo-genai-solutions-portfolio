#!/usr/bin/env bash
# Deploy embodied-ai to RunPod.
# Usage: ./packages/embodied-ai/runpod/deploy.sh [gpu-tier]
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
exec "$root/scripts/deploy-runpod.sh" "embodied-ai" "${1:-rtx3090}"