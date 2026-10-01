#!/usr/bin/env bash
# Deploy agents-4-everything to RunPod.
# Usage: ./packages/agents-4-everything/runpod/deploy.sh [gpu-tier]
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
exec "$root/scripts/deploy-runpod.sh" "agents-4-everything" "${1:-rtx5060ti}"