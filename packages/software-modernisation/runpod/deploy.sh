#!/usr/bin/env bash
# Deploy software-modernisation to RunPod.
# Usage: ./packages/software-modernisation/runpod/deploy.sh [gpu-tier]
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
exec "$root/scripts/deploy-runpod.sh" "software-modernisation" "${1:-rtx5060ti}"