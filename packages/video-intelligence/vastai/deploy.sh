#!/usr/bin/env bash
# Deploy video-intelligence to Vast.ai.
# Usage: ./packages/video-intelligence/vastai/deploy.sh [gpu-tier]
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
exec "$root/scripts/deploy-vastai.sh" "video-intelligence" "${1:-rtx3090}"