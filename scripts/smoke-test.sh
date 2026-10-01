#!/usr/bin/env bash
set -euo pipefail
demo="${1:?demo name required}"
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
path="$root/demos/$demo"
[[ -d "$path" ]] || { echo "Unknown demo: $demo"; exit 2; }
trap '"$path/reset.sh"' EXIT
"$path/demo.sh" check
"$path/demo.sh" start
"$path/test.sh"
"$path/demo.sh" run
