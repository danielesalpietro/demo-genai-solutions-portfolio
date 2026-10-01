#!/usr/bin/env bash
# Run a demo's test suite on a cloud GPU instance; retrieve logs and artifacts.
# Usage: ./scripts/test-cloud.sh <demo> <platform> [gpu-tier]
#   demo      : demo name (must have packages/<demo>/ and demos/<demo>/test.sh)
#   platform  : runpod | vastai
#   gpu-tier  : rtx3090 | rtx5060ti | cpu  (default: rtx5060ti)
#
# Env vars required (per platform):
#   RunPod  : RUNPOD_API_KEY
#   Vast.ai : VAST_AI_API_KEY
#
# Outputs:
#   test-results/<demo>/         — test artifacts retrieved from the instance
#   test-results/<demo>/run.log  — combined stdout/stderr of test.sh
#   Exit code mirrors the remote test.sh exit code.
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
demo="${1:?Usage: $0 <demo> <platform> [gpu-tier]}"
platform="${2:?Usage: $0 <demo> <platform> [gpu-tier]}"
gpu_tier="${3:-rtx5060ti}"

[[ -f "$root/demos/$demo/test.sh" ]] || { echo "ERROR: demos/$demo/test.sh not found"; exit 1; }

results_dir="$root/test-results/$demo"
mkdir -p "$results_dir"

# --- SSH key pair (ephemeral, destroyed in cleanup) -------------------------
ssh_key="$root/test-results/$demo/.test_id_ed25519"
ssh_pub="${ssh_key}.pub"
ssh-keygen -t ed25519 -f "$ssh_key" -N "" -q
trap 'cleanup' EXIT

instance_id=""
ssh_host=""
ssh_port=22
test_exit=0

# --- Cleanup: destroy instance + ephemeral key --------------------------------
cleanup() {
  local code=$?
  echo "--- cleanup ---"
  [[ -n "$instance_id" ]] && destroy_instance || true
  rm -f "$ssh_key" "$ssh_pub"
  exit $code
}

# --- Platform helpers ---------------------------------------------------------
deploy_instance() {
  local pub_key
  pub_key="$(cat "$ssh_pub")"
  case "$platform" in
    runpod)
      [[ -n "${RUNPOD_API_KEY:-}" ]] || { echo "ERROR: RUNPOD_API_KEY not set"; exit 1; }
      local template
      template="$root/packages/$demo/runpod/template.json"
      [[ -f "$template" ]] || { echo "ERROR: $template not found"; exit 1; }

      # Resolve GPU type
      local gpu_type=""
      case "$gpu_tier" in
        rtx3090)   gpu_type="NVIDIA RTX 3090" ;;
        rtx5060ti) gpu_type="NVIDIA RTX 5060 Ti" ;;
        cpu)       gpu_type="" ;;
      esac

      local payload
      payload=$(python3 - "$template" "$gpu_type" "$pub_key" <<'PYEOF'
import json, sys
path, gpu_type, pub_key = sys.argv[1], sys.argv[2], sys.argv[3]
t = json.load(open(path))
if gpu_type:
    t["gpuTypeId"] = gpu_type
t["publicKey"] = pub_key
t["startSsh"] = True
print(json.dumps(t))
PYEOF
)
      local resp
      resp=$(curl -fsSL \
        -X POST "https://api.runpod.io/graphql?api_key=${RUNPOD_API_KEY}" \
        -H "Content-Type: application/json" \
        -d "{\"query\": \"mutation { podFindAndDeployOnDemand(input: ${payload}) { id runtime { ports { ip isIpPublic privatePort publicPort type } } } }\"}")
      instance_id=$(echo "$resp" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d['data']['podFindAndDeployOnDemand']['id'])")
      # RunPod SSH is on port 22 of the public IP; it may take a moment to appear
      ssh_host=$(echo "$resp" | python3 -c "
import json, sys
d = json.load(sys.stdin)
ports = d['data']['podFindAndDeployOnDemand'].get('runtime', {}).get('ports', [])
for p in ports:
    if p.get('privatePort') == 22 and p.get('isIpPublic'):
        print(p['ip'])
        break
" 2>/dev/null || echo "")
      [[ -n "$ssh_host" ]] || { echo "WARN: SSH host not in deploy response; will poll..."; }
      ;;

    vastai)
      [[ -n "${VAST_AI_API_KEY:-}" ]] || { echo "ERROR: VAST_AI_API_KEY not set"; exit 1; }
      command -v vast >/dev/null 2>&1 || pip install --quiet vastai
      vast set api-key "${VAST_AI_API_KEY}" >/dev/null

      local config="$root/packages/$demo/vastai/config.json"
      [[ -f "$config" ]] || { echo "ERROR: $config not found"; exit 1; }

      local gpu_model disk image
      gpu_model=$(python3 -c "import json; c=json.load(open('$config')); print(c.get('gpuModel', ''))")
      disk=$(python3 -c "import json; c=json.load(open('$config')); print(c.get('diskGB', 50))")
      image=$(python3 -c "import json; c=json.load(open('$config')); print(c['image'])")

      local query="num_gpus=1 disk_space>=${disk} inet_up>=100"
      [[ -n "$gpu_model" && "$gpu_model" != "" ]] && query="gpu_name=${gpu_model} ${query}"

      local offer_id
      offer_id=$(vast search offers "$query" --raw | \
        python3 -c "import json,sys; o=json.load(sys.stdin); print(o[0]['id'] if o else '')" 2>/dev/null || echo "")
      [[ -n "$offer_id" ]] || { echo "ERROR: no Vast.ai offer for $gpu_tier"; exit 1; }

      instance_id=$(vast create instance "$offer_id" \
        --image "$image" --disk "$disk" \
        --env "GPU_TIER=${gpu_tier}" \
        --ssh --key "$ssh_pub" --raw | \
        python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('new_contract',''))")
      ;;
  esac
  echo "Instance created: $instance_id (platform=$platform)"
}

get_ssh_host() {
  case "$platform" in
    runpod)
      local resp
      resp=$(curl -fsSL \
        -X POST "https://api.runpod.io/graphql?api_key=${RUNPOD_API_KEY}" \
        -H "Content-Type: application/json" \
        -d "{\"query\": \"query { pod(input: { podId: \\\"${instance_id}\\\" }) { runtime { ports { ip isIpPublic privatePort publicPort type } } } }\"}")
      python3 -c "
import json, sys
d = json.load(sys.stdin)
ports = d['data']['pod']['runtime']['ports']
for p in ports:
    if p.get('privatePort') == 22 and p.get('isIpPublic'):
        print(p['ip'])
        break
" <<< "$resp" 2>/dev/null || echo ""
      ;;
    vastai)
      vast show instances --raw | \
        python3 -c "
import json, sys
instances = json.load(sys.stdin)
for i in instances:
    if str(i.get('id', '')) == '${instance_id}':
        print(i.get('ssh_host', ''))
        break
" 2>/dev/null || echo ""
      ;;
  esac
}

destroy_instance() {
  echo "Destroying instance $instance_id..."
  case "$platform" in
    runpod)
      curl -fsSL \
        -X POST "https://api.runpod.io/graphql?api_key=${RUNPOD_API_KEY}" \
        -H "Content-Type: application/json" \
        -d "{\"query\": \"mutation { podTerminate(input: { podId: \\\"${instance_id}\\\" }) }\"}" >/dev/null 2>&1 || true
      ;;
    vastai)
      vast destroy instance "$instance_id" >/dev/null 2>&1 || true
      ;;
  esac
}

wait_for_ssh() {
  local timeout=300
  local elapsed=0
  echo "Waiting for SSH on $ssh_host:$ssh_port (timeout ${timeout}s)..."
  while (( elapsed < timeout )); do
    if ssh -i "$ssh_key" -o StrictHostKeyChecking=no -o ConnectTimeout=5 \
        -o BatchMode=yes -p "$ssh_port" "root@$ssh_host" "true" 2>/dev/null; then
      echo "SSH available after ${elapsed}s."
      return 0
    fi
    # Refresh host if not yet resolved
    [[ -z "$ssh_host" ]] && ssh_host=$(get_ssh_host)
    sleep 10; (( elapsed += 10 ))
  done
  echo "ERROR: SSH did not become available within ${timeout}s."
  return 1
}

wait_for_demo_ready() {
  local timeout=600
  local elapsed=0
  echo "Waiting for demo setup to complete (sentinel /workspace/.demo-ready)..."
  while (( elapsed < timeout )); do
    if ssh -i "$ssh_key" -o StrictHostKeyChecking=no -o BatchMode=yes \
        -p "$ssh_port" "root@$ssh_host" \
        "test -f /workspace/.demo-ready" 2>/dev/null; then
      echo "Demo ready after ${elapsed}s."
      return 0
    fi
    sleep 15; (( elapsed += 15 ))
  done
  echo "ERROR: demo did not become ready within ${timeout}s."
  return 1
}

run_remote_tests() {
  local remote_results="/workspace/$demo/test-results"
  echo "Running test.sh on $ssh_host..."
  ssh -i "$ssh_key" -o StrictHostKeyChecking=no -o BatchMode=yes \
      -p "$ssh_port" "root@$ssh_host" \
      "cd /workspace/$demo && mkdir -p test-results && bash demos/$demo/test.sh 2>&1 | tee test-results/run.log; echo \$? > test-results/.exit_code" || true

  # Fetch test exit code
  local remote_exit
  remote_exit=$(ssh -i "$ssh_key" -o StrictHostKeyChecking=no -o BatchMode=yes \
      -p "$ssh_port" "root@$ssh_host" "cat /workspace/$demo/test-results/.exit_code 2>/dev/null || echo 1")
  test_exit="${remote_exit//[^0-9]/}"
  [[ -n "$test_exit" ]] || test_exit=1

  # Retrieve artifacts
  echo "Fetching test artifacts from $ssh_host:$remote_results ..."
  scp -i "$ssh_key" -o StrictHostKeyChecking=no -P "$ssh_port" -r \
      "root@$ssh_host:$remote_results/" "$results_dir/" 2>/dev/null || \
    echo "WARN: no test-results directory on remote (tests may not have produced artifacts)"
}

# --- Main flow ----------------------------------------------------------------
echo "=== Cloud test: demo=$demo platform=$platform gpu=$gpu_tier ==="

deploy_instance

# Resolve SSH host if not yet known
if [[ -z "$ssh_host" ]]; then
  sleep 20
  for _ in 1 2 3 4 5; do
    ssh_host=$(get_ssh_host)
    [[ -n "$ssh_host" ]] && break
    sleep 15
  done
fi
[[ -n "$ssh_host" ]] || { echo "ERROR: could not resolve instance SSH host"; exit 1; }

# Vast.ai SSH port is often non-22; check instance info
if [[ "$platform" == "vastai" ]]; then
  ssh_port=$(vast show instances --raw | \
    python3 -c "
import json, sys
instances = json.load(sys.stdin)
for i in instances:
    if str(i.get('id','')) == '${instance_id}':
        print(i.get('ssh_port', 22))
        break
" 2>/dev/null || echo "22")
fi

wait_for_ssh
wait_for_demo_ready
run_remote_tests

echo "=== Test complete — exit code: $test_exit ==="
echo "Artifacts: $results_dir"

# Export summary for CI
cat > "$results_dir/summary.json" <<JSON
{
  "demo": "$demo",
  "platform": "$platform",
  "gpu_tier": "$gpu_tier",
  "instance_id": "$instance_id",
  "ssh_host": "$ssh_host",
  "exit_code": $test_exit,
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
JSON

exit "$test_exit"
