#!/usr/bin/env bash
# Deploy hello-compose to RunPod.
# Usage: ./packages/hello-compose/runpod/deploy.sh [gpu-tier]
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
exec "$root/scripts/deploy-runpod.sh" "hello-compose" "${1:-cpu}"