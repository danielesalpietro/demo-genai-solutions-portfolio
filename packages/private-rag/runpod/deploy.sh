#!/usr/bin/env bash
# Deploy private-rag to RunPod.
# Usage: ./packages/private-rag/runpod/deploy.sh [gpu-tier]
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
exec "$root/scripts/deploy-runpod.sh" "private-rag" "${1:-rtx5060ti}"