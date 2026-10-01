#!/usr/bin/env bash
# Deploy drug-discovery to Vast.ai.
# Usage: ./packages/drug-discovery/vastai/deploy.sh [gpu-tier]
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
exec "$root/scripts/deploy-vastai.sh" "drug-discovery" "${1:-rtx5060ti}"