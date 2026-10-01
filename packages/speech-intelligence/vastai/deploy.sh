#!/usr/bin/env bash
# Deploy speech-intelligence to Vast.ai.
# Usage: ./packages/speech-intelligence/vastai/deploy.sh [gpu-tier]
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
exec "$root/scripts/deploy-vastai.sh" "speech-intelligence" "${1:-rtx5060ti}"