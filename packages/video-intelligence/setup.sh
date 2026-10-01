#!/usr/bin/env bash
# Cloud startup script for video-intelligence demo.
# Runs on Ubuntu 22.04 GPU instances (RunPod / Vast.ai). GPU recommended (min 16 GB).
# Installs Docker Compose plugin if missing, pulls Ollama models, starts services.
set -euo pipefail

DEMO="video-intelligence"
REPO_URL="${REPO_URL:-https://github.com/DanieleS/demo-genai-solutions-portfolio}"
WORKSPACE="/workspace/${DEMO}"

# Install Docker Compose plugin if missing
if ! docker compose version >/dev/null 2>&1; then
  apt-get update -qq && apt-get install -y -qq docker-compose-plugin
fi

# Clone repo if not already present
if [[ ! -d "$WORKSPACE" ]]; then
  git clone --depth 1 "$REPO_URL" "$WORKSPACE"
fi

cd "$WORKSPACE"

INFERENCE_BACKEND="${INFERENCE_BACKEND:-ollama}"

case "$INFERENCE_BACKEND" in
  ollama)
    GPU_TIER="${GPU_TIER:-rtx3090}"
    case "$GPU_TIER" in
      rtx3090)   OLLAMA_MODEL="llava:13b-v1.6-vicuna-q4_K_M" ;;
      rtx5060ti) OLLAMA_MODEL="llava:7b-v1.6-mistral-q4_K_M" ;;
      cpu)       OLLAMA_MODEL="llava:7b-v1.6-mistral-q4_K_M" ;;
      *)         OLLAMA_MODEL="llava:13b-v1.6-vicuna-q4_K_M" ;;
    esac

    docker compose \
      -f "demos/${DEMO}/compose.yaml" \
      -f "packages/${DEMO}/docker-compose.cloud.yaml" \
      up -d

    sleep 10
    if docker ps --format '{{.Names}}' | grep -q ollama; then
      docker exec ollama ollama pull "$OLLAMA_MODEL"
    fi

    touch /workspace/.demo-ready
    echo "Demo '${DEMO}' started. GPU_TIER=${GPU_TIER}, INFERENCE_BACKEND=ollama, model=${OLLAMA_MODEL}"
    ;;

  vllm)
    export VLLM_MODEL="llava-hf/llava-v1.6-vicuna-13b-hf"
    export VLLM_CPU_OFFLOAD_GB="10"
    export VLLM_GPU_MEMORY_UTILIZATION="0.75"
    export VLLM_QUANTIZATION="awq"
    export VLLM_MAX_MODEL_LEN="4096"
    export VLLM_DTYPE="bfloat16"

    docker compose \
      -f "demos/${DEMO}/compose.yaml" \
      -f "packages/${DEMO}/docker-compose.cloud.yaml" \
      --profile vllm \
      up -d

    touch /workspace/.demo-ready
    echo "Demo '${DEMO}' started. INFERENCE_BACKEND=vllm, model=${VLLM_MODEL}"
    ;;

  api)
    docker compose \
      -f "demos/${DEMO}/compose.yaml" \
      -f "packages/${DEMO}/docker-compose.cloud.yaml" \
      --profile api \
      up -d

    touch /workspace/.demo-ready
    echo "Demo '${DEMO}' started. INFERENCE_BACKEND=api"
    ;;

  *)
    echo "Unknown INFERENCE_BACKEND='${INFERENCE_BACKEND}'. Use: ollama | vllm | api" >&2
    exit 1
    ;;
esac