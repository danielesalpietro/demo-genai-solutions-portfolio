#!/usr/bin/env bash
# Deploy visual-inspection to Vast.ai.
# Usage: ./packages/visual-inspection/vastai/deploy.sh [gpu-tier]
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
exec "$root/scripts/deploy-vastai.sh" "visual-inspection" "${1:-rtx5060ti}"