#!/usr/bin/env bash
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
failed=0
required=(README.md compose.yaml demo.yaml demo.sh test.sh reset.sh .env.example)
for demo in "$root"/demos/*; do
  [[ -d "$demo" ]] || continue
  for item in "${required[@]}"; do
    [[ -f "$demo/$item" ]] || { echo "ERROR: missing $demo/$item"; failed=1; }
  done
  for script in demo.sh test.sh reset.sh; do
    [[ -x "$demo/$script" ]] || { echo "ERROR: not executable $demo/$script"; failed=1; }
  done
  docker compose -f "$demo/compose.yaml" config --quiet || failed=1
  grep -Eq 'image: .+:[^[:space:]]+' "$demo/compose.yaml" || { echo "ERROR: image tags required in $demo"; failed=1; }
  if grep -Eq 'image: .+:latest([[:space:]]|$)' "$demo/compose.yaml"; then
    echo "ERROR: latest tag prohibited in $demo"; failed=1
  fi
  if grep -Eq 'privileged:[[:space:]]*true|network_mode:[[:space:]]*host|/var/run/docker.sock' "$demo/compose.yaml"; then
    echo "ERROR: prohibited Compose setting in $demo"; failed=1
  fi
done
command -v shellcheck >/dev/null && find "$root" -name '*.sh' -print0 | xargs -0 shellcheck
exit "$failed"
