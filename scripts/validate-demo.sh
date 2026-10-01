#!/usr/bin/env bash
# Validate a single demo directory against the demo contract.
# Usage: ./scripts/validate-demo.sh <demo-name>
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
demo_name="${1:?Usage: $0 <demo-name>}"
demo="$root/demos/$demo_name"

[[ -d "$demo" ]] || { echo "ERROR: demo directory not found: $demo"; exit 1; }

failed=0
required_files=(README.md compose.yaml demo.yaml demo.sh test.sh reset.sh .env.example)
required_executables=(demo.sh test.sh reset.sh)

echo "Validating demo: $demo_name"

for item in "${required_files[@]}"; do
  if [[ ! -f "$demo/$item" ]]; then
    echo "ERROR: missing required file: $demo/$item"
    failed=1
  fi
done

for script in "${required_executables[@]}"; do
  if [[ -f "$demo/$script" ]] && [[ ! -x "$demo/$script" ]]; then
    echo "ERROR: not executable: $demo/$script"
    failed=1
  fi
done

if [[ -f "$demo/compose.yaml" ]]; then
  docker compose -f "$demo/compose.yaml" config --quiet || { echo "ERROR: compose config failed for $demo_name"; failed=1; }

  if ! grep -Eq 'image: .+:[^[:space:]]+' "$demo/compose.yaml"; then
    echo "ERROR: all images must have explicit version tags in $demo_name"
    failed=1
  fi

  if grep -Eq 'image: .+:latest([[:space:]]|$)' "$demo/compose.yaml"; then
    echo "ERROR: 'latest' tag prohibited in $demo_name"
    failed=1
  fi

  if grep -Eq 'privileged:[[:space:]]*true|network_mode:[[:space:]]*host|/var/run/docker\.sock' "$demo/compose.yaml"; then
    echo "ERROR: prohibited Compose setting in $demo_name"
    failed=1
  fi
fi

if command -v check-jsonschema >/dev/null 2>&1 && [[ -f "$demo/demo.yaml" ]]; then
  check-jsonschema --schemafile "$root/schemas/demo.schema.json" "$demo/demo.yaml" || failed=1
fi

if command -v shellcheck >/dev/null 2>&1; then
  find "$demo" -name '*.sh' -print0 | xargs -0 shellcheck || failed=1
fi

if [[ $failed -eq 0 ]]; then
  echo "OK: $demo_name passed all contract checks"
fi
exit "$failed"
