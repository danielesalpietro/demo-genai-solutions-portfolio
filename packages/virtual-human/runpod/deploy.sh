#!/usr/bin/env bash
# Deploy virtual-human to RunPod.
# Usage: ./packages/virtual-human/runpod/deploy.sh [gpu-tier]
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
exec "$root/scripts/deploy-runpod.sh" "virtual-human" "${1:-rtx5060ti}"