#!/usr/bin/env bash
# Deploy software-modernisation to Vast.ai.
# Usage: ./packages/software-modernisation/vastai/deploy.sh [gpu-tier]
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
exec "$root/scripts/deploy-vastai.sh" "software-modernisation" "${1:-rtx5060ti}"