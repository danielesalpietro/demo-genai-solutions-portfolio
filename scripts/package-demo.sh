#!/usr/bin/env bash
# Build and push a demo's Docker image to GHCR.
# Usage: ./scripts/package-demo.sh <demo-name> [tag]
# Env vars: GHCR_OWNER (default: github.repository_owner or 'local')
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
demo="${1:?Usage: $0 <demo-name> [tag]}"
tag="${2:-latest}"
owner="${GHCR_OWNER:-local}"
registry="ghcr.io/${owner}/demo-genai-solutions-portfolio"
image="${registry}/${demo}:${tag}"

[[ -d "$root/packages/$demo" ]] || { echo "ERROR: no package directory for demo '$demo'"; exit 1; }

# Validate package.yaml
if command -v check-jsonschema >/dev/null 2>&1; then
  check-jsonschema --schemafile "$root/schemas/package.schema.json" \
    "$root/packages/$demo/package.yaml" || { echo "ERROR: package.yaml validation failed"; exit 1; }
fi

# Build if a Dockerfile exists in the demo or package directory
dockerfile=""
[[ -f "$root/packages/$demo/Dockerfile" ]] && dockerfile="$root/packages/$demo/Dockerfile"
[[ -f "$root/demos/$demo/Dockerfile" ]] && dockerfile="$root/demos/$demo/Dockerfile"

if [[ -n "$dockerfile" ]]; then
  echo "Building $image from $dockerfile"
  docker build -t "$image" -f "$dockerfile" "$root"
  if [[ "$owner" != "local" ]]; then
    docker push "$image"
    echo "Pushed: $image"
  else
    echo "SKIP push: GHCR_OWNER not set (local build only)"
  fi
else
  echo "No Dockerfile found for '$demo'; package uses upstream images only."
  echo "Package manifest: $root/packages/$demo/package.yaml"
fi
