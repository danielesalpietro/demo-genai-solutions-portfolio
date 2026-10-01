#!/usr/bin/env bash
# Deploy video-intelligence to RunPod.
# Usage: ./packages/video-intelligence/runpod/deploy.sh [gpu-tier]
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
exec "$root/scripts/deploy-runpod.sh" "video-intelligence" "${1:-rtx3090}"