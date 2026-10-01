#!/usr/bin/env bash
# Check Markdown links in the repository for broken references.
# Usage: ./scripts/check-links.sh
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
failed=0

echo "Checking Markdown links..."

find "$root" -name '*.md' \
  ! -path '*/.git/*' \
  ! -path '*/node_modules/*' \
  -print0 | while IFS= read -r -d '' file; do

  # Extract relative file links: [text](path) — skip http(s):// and anchors
  grep -oE '\[([^\]]+)\]\(([^)]+)\)' "$file" | while IFS= read -r match; do
    link=$(echo "$match" | sed 's/\[.*\](\(.*\))/\1/')
    # Skip external links and anchors
    [[ "$link" == http* ]] && continue
    [[ "$link" == "#"* ]] && continue
    # Resolve relative to file's directory
    dir=$(dirname "$file")
    target="$dir/$link"
    # Strip anchor fragment
    target="${target%%#*}"
    if [[ ! -e "$target" ]]; then
      echo "BROKEN: $file -> $link"
      failed=1
    fi
  done
done

if [[ $failed -eq 0 ]]; then
  echo "OK: all relative Markdown links are valid"
fi
exit "$failed"
