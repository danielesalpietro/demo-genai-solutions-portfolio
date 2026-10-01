#!/usr/bin/env bash
# Deploy private-rag to Vast.ai.
# Usage: ./packages/private-rag/vastai/deploy.sh [gpu-tier]
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
exec "$root/scripts/deploy-vastai.sh" "private-rag" "${1:-rtx5060ti}"