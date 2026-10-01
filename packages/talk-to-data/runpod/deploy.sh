#!/usr/bin/env bash
# Deploy talk-to-data to RunPod.
# Usage: ./packages/talk-to-data/runpod/deploy.sh [gpu-tier]
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
exec "$root/scripts/deploy-runpod.sh" "talk-to-data" "${1:-rtx5060ti}"