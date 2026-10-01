#!/usr/bin/env bash
# Validate all compose.yaml files in the repository.
# Usage: ./scripts/validate-compose.sh
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
failed=0

echo "Validating Compose files..."

find "$root/demos" -name 'compose.yaml' -print0 | while IFS= read -r -d '' file; do
  demo=$(basename "$(dirname "$file")")
  echo "  Checking $demo/compose.yaml"

  docker compose -f "$file" config --quiet || { echo "ERROR: compose config failed: $file"; failed=1; }

  if ! grep -Eq 'image: .+:[^[:space:]]+' "$file"; then
    echo "ERROR: image tags required in $file"
    failed=1
  fi

  if grep -Eq 'image: .+:latest([[:space:]]|$)' "$file"; then
    echo "ERROR: 'latest' tag prohibited in $file"
    failed=1
  fi

  if grep -Eq 'privileged:[[:space:]]*true' "$file"; then
    echo "ERROR: privileged containers prohibited in $file"
    failed=1
  fi

  if grep -Eq 'network_mode:[[:space:]]*host' "$file"; then
    echo "ERROR: host network mode prohibited in $file"
    failed=1
  fi

  if grep -Eq '/var/run/docker\.sock' "$file"; then
    echo "ERROR: Docker socket mount requires approved security exception in $file"
    failed=1
  fi
done

exit "$failed"
