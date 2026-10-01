#!/usr/bin/env bash
# Deploy speech-intelligence to RunPod.
# Usage: ./packages/speech-intelligence/runpod/deploy.sh [gpu-tier]
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
exec "$root/scripts/deploy-runpod.sh" "speech-intelligence" "${1:-rtx5060ti}"