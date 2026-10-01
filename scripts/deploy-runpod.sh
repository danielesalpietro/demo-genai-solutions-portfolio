#!/usr/bin/env bash
# Deploy a demo package to RunPod.
# Usage: ./scripts/deploy-runpod.sh <demo-name> [gpu-tier]
# gpu-tier: rtx3090 (default) | rtx5060ti | cpu
# Requires: RUNPOD_API_KEY environment variable
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
demo="${1:?Usage: $0 <demo-name> [gpu-tier]}"
gpu_tier="${2:-rtx3090}"
template="$root/packages/$demo/runpod/template.json"

[[ -f "$template" ]] || { echo "ERROR: RunPod template not found: $template"; exit 1; }
[[ -n "${RUNPOD_API_KEY:-}" ]] || { echo "ERROR: RUNPOD_API_KEY is not set"; exit 1; }

# Resolve GPU type from tier
case "$gpu_tier" in
  rtx3090)   gpu_type="NVIDIA RTX 3090" ;;
  rtx5060ti) gpu_type="NVIDIA RTX 5060 Ti" ;;
  cpu)       gpu_type="" ;;
  *)         echo "ERROR: unknown gpu-tier: $gpu_tier (use rtx3090|rtx5060ti|cpu)"; exit 1 ;;
esac

# Merge GPU type into template and deploy via RunPod API
payload=$(python3 -c "
import json, sys
t = json.load(open('$template'))
if '$gpu_type':
    t['gpuTypeId'] = '$gpu_type'
print(json.dumps(t))
")

echo "Deploying '$demo' to RunPod (GPU: ${gpu_type:-none})..."
response=$(curl -fsSL \
  -X POST "https://api.runpod.io/graphql?api_key=${RUNPOD_API_KEY}" \
  -H "Content-Type: application/json" \
  -d "{\"query\": \"mutation { podFindAndDeployOnDemand(input: ${payload}) { id status } }\"}")

echo "Response: $response"
pod_id=$(echo "$response" | python3 -c "import json,sys; print(json.load(sys.stdin)['data']['podFindAndDeployOnDemand']['id'])" 2>/dev/null || echo "")
[[ -n "$pod_id" ]] && echo "Pod deployed: $pod_id"
