#!/usr/bin/env bash
# Deploy virtual-human to Vast.ai.
# Usage: ./packages/virtual-human/vastai/deploy.sh [gpu-tier]
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
exec "$root/scripts/deploy-vastai.sh" "virtual-human" "${1:-rtx5060ti}"