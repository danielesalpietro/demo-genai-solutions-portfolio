#!/usr/bin/env bash
# Contract tests for private-rag demo (no running services required)
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

PASS=0
FAIL=0

_ok()   { echo "[PASS] $*"; PASS=$((PASS+1)); }
_fail() { echo "[FAIL] $*"; FAIL=$((FAIL+1)); }

# 1. Required files exist
for f in compose.yaml .env.example demo.yaml demo.sh test.sh reset.sh README.md; do
  if [[ -f "${f}" ]]; then
    _ok "File exists: ${f}"
  else
    _fail "Missing file: ${f}"
  fi
done

# 2. Scripts are executable
for s in demo.sh test.sh reset.sh; do
  if [[ -x "${s}" ]]; then
    _ok "Executable: ${s}"
  else
    _fail "Not executable: ${s}"
  fi
done

# 3. demo.yaml is valid YAML
if python3 -c "import yaml, sys; yaml.safe_load(sys.stdin)" < demo.yaml 2>/dev/null; then
  _ok "demo.yaml is valid YAML"
else
  _fail "demo.yaml failed YAML parse"
fi

# 4. compose.yaml passes docker compose config
if docker compose -f compose.yaml config --quiet 2>/dev/null; then
  _ok "compose.yaml passes docker compose config"
else
  _fail "compose.yaml failed docker compose config"
fi

# 5. No 'latest' tag in compose.yaml
if grep -q ':latest' compose.yaml; then
  _fail "compose.yaml contains ':latest' image tag"
else
  _ok "No ':latest' tags in compose.yaml"
fi

# 6. .env.example has no real secrets (values >30 chars not starting with CHANGE_ME_)
secret_found=false
while IFS='=' read -r key value || [[ -n "${key}" ]]; do
  [[ "${key}" =~ ^[[:space:]]*# ]] && continue
  [[ -z "${key// /}" ]] && continue
  value="${value//[[:space:]]/}"
  if [[ ${#value} -gt 30 && "${value}" != CHANGE_ME_* ]]; then
    _fail ".env.example: '${key}' looks like a real secret (length ${#value})"
    secret_found=true
  fi
done < .env.example
if [[ "${secret_found}" == "false" ]]; then
  _ok ".env.example secret check passed"
fi

# 7. Fixture contains "7 years"
if [[ -f "fixtures/document-retention-policy.md" ]]; then
  if grep -qi "7 years" fixtures/document-retention-policy.md; then
    _ok "fixtures/document-retention-policy.md contains '7 years'"
  else
    _fail "fixtures/document-retention-policy.md does not contain '7 years'"
  fi
else
  _fail "fixtures/document-retention-policy.md not found"
fi

# Summary
echo ""
echo "Results: ${PASS} passed, ${FAIL} failed"
if [[ "${FAIL}" -gt 0 ]]; then
  echo "Contract tests FAILED"
  exit 1
fi
echo "All contract tests passed."
