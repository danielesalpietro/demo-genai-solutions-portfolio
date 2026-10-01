#!/usr/bin/env bash
# Deploy context-fabric to Vast.ai.
# Usage: ./packages/context-fabric/vastai/deploy.sh [gpu-tier]
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
exec "$root/scripts/deploy-vastai.sh" "context-fabric" "${1:-rtx5060ti}"