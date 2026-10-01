#!/usr/bin/env bash
# Deploy hello-compose to Vast.ai.
# Usage: ./packages/hello-compose/vastai/deploy.sh [gpu-tier]
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
exec "$root/scripts/deploy-vastai.sh" "hello-compose" "${1:-cpu}"