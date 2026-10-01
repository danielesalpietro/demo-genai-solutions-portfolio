#!/usr/bin/env bash
# Deploy drug-discovery to RunPod.
# Usage: ./packages/drug-discovery/runpod/deploy.sh [gpu-tier]
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
exec "$root/scripts/deploy-runpod.sh" "drug-discovery" "${1:-rtx5060ti}"