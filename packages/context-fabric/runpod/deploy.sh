#!/usr/bin/env bash
# Deploy context-fabric to RunPod.
# Usage: ./packages/context-fabric/runpod/deploy.sh [gpu-tier]
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
exec "$root/scripts/deploy-runpod.sh" "context-fabric" "${1:-rtx5060ti}"