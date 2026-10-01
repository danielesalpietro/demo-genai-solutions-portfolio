#!/usr/bin/env bash
# Deploy visual-inspection to RunPod.
# Usage: ./packages/visual-inspection/runpod/deploy.sh [gpu-tier]
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
exec "$root/scripts/deploy-runpod.sh" "visual-inspection" "${1:-rtx5060ti}"