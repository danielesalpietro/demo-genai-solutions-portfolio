#!/usr/bin/env bash
# Deploy content-creator to Vast.ai.
# Usage: ./packages/content-creator/vastai/deploy.sh [gpu-tier]
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
exec "$root/scripts/deploy-vastai.sh" "content-creator" "${1:-rtx5060ti}"