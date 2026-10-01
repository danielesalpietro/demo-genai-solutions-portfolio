#!/usr/bin/env bash
# Cloud startup script for drug-discovery demo.
# Runs on Ubuntu 22.04 GPU instances (RunPod / Vast.ai).
# Installs Docker Compose plugin if missing, starts services.
set -euo pipefail

DEMO="drug-discovery"
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

# Start the demo
docker compose \
  -f "demos/${DEMO}/compose.yaml" \
  -f "packages/${DEMO}/docker-compose.cloud.yaml" \
  up -d

touch /workspace/.demo-ready
echo "Demo '${DEMO}' started."