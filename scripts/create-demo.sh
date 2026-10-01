#!/usr/bin/env bash
set -euo pipefail
name="${1:?usage: create-demo.sh demo-name}"
[[ "$name" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]] || { echo "Use lowercase kebab-case"; exit 2; }
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
target="$root/demos/$name"
[[ ! -e "$target" ]] || { echo "Already exists: $target"; exit 3; }
cp -a "$root/templates/demo" "$target"
sed -i "s/__DEMO_NAME__/$name/g" "$target"/* "$target"/.[!.]* 2>/dev/null || true
chmod +x "$target"/*.sh
echo "Created $target"
