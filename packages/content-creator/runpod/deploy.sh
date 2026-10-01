#!/usr/bin/env bash
# Deploy content-creator to RunPod.
# Usage: ./packages/content-creator/runpod/deploy.sh [gpu-tier]
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
exec "$root/scripts/deploy-runpod.sh" "content-creator" "${1:-rtx5060ti}"