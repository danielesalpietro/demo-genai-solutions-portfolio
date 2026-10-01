#!/usr/bin/env bash
# Deploy a demo package to Vast.ai.
# Usage: ./scripts/deploy-vastai.sh <demo-name> [gpu-tier]
# gpu-tier: rtx3090 (default) | rtx5060ti | cpu
# Requires: VAST_AI_API_KEY environment variable; vast CLI installed
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
demo="${1:?Usage: $0 <demo-name> [gpu-tier]}"
gpu_tier="${2:-rtx3090}"
config="$root/packages/$demo/vastai/config.json"

[[ -f "$config" ]] || { echo "ERROR: Vast.ai config not found: $config"; exit 1; }
[[ -n "${VAST_AI_API_KEY:-}" ]] || { echo "ERROR: VAST_AI_API_KEY is not set"; exit 1; }
command -v vast >/dev/null 2>&1 || pip install --quiet vastai

vast set api-key "${VAST_AI_API_KEY}" >/dev/null

# Resolve GPU model from tier
case "$gpu_tier" in
  rtx3090)   gpu_model="RTX_3090" ;;
  rtx5060ti) gpu_model="RTX_5060_Ti" ;;
  cpu)       gpu_model="" ;;
  *)         echo "ERROR: unknown gpu-tier: $gpu_tier (use rtx3090|rtx5060ti|cpu)"; exit 1 ;;
esac

# Extract config fields
image=$(python3 -c "import json; c=json.load(open('$config')); print(c['image'])")
disk=$(python3 -c "import json; c=json.load(open('$config')); print(c.get('diskGB', 50))")
env_vars=$(python3 -c "import json; c=json.load(open('$config')); print(' '.join('-e '+e for e in c.get('env', [])))")
onstart=$(python3 -c "import json; c=json.load(open('$config')); print(c.get('onstart', ''))")

# Search for an offer
echo "Searching Vast.ai for GPU: ${gpu_model:-any}..."
search_query="num_gpus=1 disk_space>=${disk}"
[[ -n "$gpu_model" ]] && search_query="gpu_name=${gpu_model} ${search_query}"

offer_id=$(vast search offers "$search_query" --raw | \
  python3 -c "import json,sys; offers=json.load(sys.stdin); print(offers[0]['id'] if offers else '')" 2>/dev/null || echo "")

[[ -n "$offer_id" ]] || { echo "ERROR: no matching Vast.ai offer found for $gpu_tier"; exit 1; }

echo "Creating instance on offer $offer_id..."
# shellcheck disable=SC2086
vast create instance "$offer_id" \
  --image "$image" \
  --disk "$disk" \
  ${env_vars:+--env "$env_vars"} \
  ${onstart:+--onstart "$onstart"}

echo "Instance created for demo '$demo' on Vast.ai."
