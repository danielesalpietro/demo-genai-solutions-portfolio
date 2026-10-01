#!/usr/bin/env bash
# Private RAG — Enterprise Knowledge Assistant
# Lifecycle: check | start | run | status | stop | reset

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=../../templates/common/logging.sh
source "${SCRIPT_DIR}/../../templates/common/logging.sh"
# shellcheck source=../../templates/common/wait-for-service.sh
source "${SCRIPT_DIR}/../../templates/common/wait-for-service.sh"

# Load .env if present (set -a exports vars to child processes, e.g. docker compose)
if [[ -f "${SCRIPT_DIR}/.env" ]]; then
  # shellcheck disable=SC1091
  set -a; source "${SCRIPT_DIR}/.env"; set +a
fi

# Ports and runtime defaults (overridden by .env)
DEMO_PORT="${DEMO_PORT:-3000}"
OLLAMA_PORT="${OLLAMA_PORT:-11434}"
QDRANT_PORT="${QDRANT_PORT:-6333}"
QDRANT_GRPC_PORT="${QDRANT_GRPC_PORT:-6334}"
GPU_TIER="${GPU_TIER:-cpu}"
WEBUI_ADMIN_EMAIL="${WEBUI_ADMIN_EMAIL:-admin@demo.local}"
WEBUI_ADMIN_PASSWORD="${WEBUI_ADMIN_PASSWORD:-DemoAdmin123!}"
WEBUI_BASE="http://localhost:${DEMO_PORT}"
OLLAMA_BASE="http://localhost:${OLLAMA_PORT}"
QDRANT_BASE="http://localhost:${QDRANT_PORT}"
TOKEN_FILE="/tmp/owui-token"
FIXTURES_DIR="${SCRIPT_DIR}/fixtures"

# Return the LLM model name for the configured GPU_TIER
_llm_model() {
  case "${GPU_TIER}" in
    rtx3090)   echo "mistral-small3.1:24b-instruct-2503-q4_K_M" ;;
    rtx5060ti) echo "mistral-nemo:12b-instruct-2407-q4_K_M" ;;
    *)         echo "mistral:7b-instruct-q4_K_M" ;;
  esac
}

# Obtain or refresh the Open WebUI bearer token
_owui_ensure_token() {
  [[ -f "${TOKEN_FILE}" ]] && return 0

  local tmp http_code body token
  tmp=$(mktemp)

  log_info "Authenticating with Open WebUI..."
  http_code=$(curl -s -o "${tmp}" -w "%{http_code}" \
    -X POST "${WEBUI_BASE}/api/v1/auths/signup" \
    -H "Content-Type: application/json" \
    -d "{\"name\":\"Admin\",\"email\":\"${WEBUI_ADMIN_EMAIL}\",\"password\":\"${WEBUI_ADMIN_PASSWORD}\"}")

  if [[ "${http_code}" != "200" && "${http_code}" != "201" ]]; then
    log_warn "Signup returned HTTP ${http_code} — trying signin"
    http_code=$(curl -s -o "${tmp}" -w "%{http_code}" \
      -X POST "${WEBUI_BASE}/api/v1/auths/signin" \
      -H "Content-Type: application/json" \
      -d "{\"email\":\"${WEBUI_ADMIN_EMAIL}\",\"password\":\"${WEBUI_ADMIN_PASSWORD}\"}")
  fi

  if [[ "${http_code}" != "200" && "${http_code}" != "201" ]]; then
    log_error "Authentication failed (HTTP ${http_code})"
    cat "${tmp}" >&2
    rm -f "${tmp}"
    return 1
  fi

  body=$(cat "${tmp}")
  rm -f "${tmp}"
  token=$(printf '%s' "${body}" | python3 -c \
    "import sys,json; d=json.load(sys.stdin); print(d.get('token',d.get('access_token','')))" \
    2>/dev/null) || token=""

  if [[ -z "${token}" ]]; then
    log_error "Could not extract auth token from API response"
    return 1
  fi

  printf '%s' "${token}" > "${TOKEN_FILE}"
  log_ok "Auth token saved to ${TOKEN_FILE}"
}

# Upload a file to Open WebUI files API then add it to a knowledge base
_upload_fixture() {
  local token="$1" kb_id="$2" filepath="$3"
  local filename tmp http_code file_id
  filename=$(basename "${filepath}")
  tmp=$(mktemp)

  log_info "Uploading ${filename}..."
  http_code=$(curl -s -o "${tmp}" -w "%{http_code}" \
    -X POST "${WEBUI_BASE}/api/v1/files/" \
    -H "Authorization: Bearer ${token}" \
    -F "file=@${filepath};filename=${filename}")

  if [[ "${http_code}" != "200" && "${http_code}" != "201" ]]; then
    log_warn "File upload for ${filename} returned HTTP ${http_code} — skipping"
    rm -f "${tmp}"
    return 0
  fi

  file_id=$(python3 -c \
    "import json,sys; print(json.load(open(sys.argv[1]))[\"id\"])" \
    "${tmp}" 2>/dev/null) || file_id=""
  rm -f "${tmp}"

  if [[ -z "${file_id}" ]]; then
    log_warn "Could not extract file_id for ${filename} — skipping"
    return 0
  fi

  http_code=$(curl -s -o /dev/null -w "%{http_code}" \
    -X POST "${WEBUI_BASE}/api/v1/knowledge/${kb_id}/file/add" \
    -H "Authorization: Bearer ${token}" \
    -H "Content-Type: application/json" \
    -d "{\"file_id\":\"${file_id}\"}")

  if [[ "${http_code}" == "200" || "${http_code}" == "201" ]]; then
    log_ok "${filename} added to knowledge base"
  else
    log_warn "Add-to-knowledge returned HTTP ${http_code} for ${filename}"
  fi
}

# ── check ─────────────────────────────────────────────────────────────────────
cmd_check() {
  log_section "Checking prerequisites"

  if ! command -v docker &>/dev/null; then
    log_error "docker not found in PATH"; exit 1
  fi
  if ! docker info &>/dev/null; then
    log_error "Docker daemon is not running"; exit 1
  fi
  log_ok "Docker daemon running"

  if ! docker compose version &>/dev/null; then
    log_error "Docker Compose plugin not found"; exit 1
  fi
  log_ok "Docker Compose plugin available"

  if [[ ! -f "${SCRIPT_DIR}/.env" ]]; then
    log_warn ".env not found — copy .env.example to .env to customise"
  else
    log_ok ".env present"
  fi

  for p in "${DEMO_PORT}" "${OLLAMA_PORT}" "${QDRANT_PORT}" "${QDRANT_GRPC_PORT}"; do
    if (echo > /dev/tcp/localhost/"${p}") 2>/dev/null; then
      log_error "Port ${p} is already in use"; exit 1
    fi
    log_ok "Port ${p} is free"
  done

  log_ok "Prerequisites OK"
}

# ── start ─────────────────────────────────────────────────────────────────────
cmd_start() {
  log_section "Starting private-rag"
  cd "${SCRIPT_DIR}"

  docker compose up -d
  log_ok "Containers started"

  log_step 1 "Qdrant readiness"
  wait_for_http "${QDRANT_BASE}/readiness" 120
  log_ok "Qdrant ready"

  log_step 2 "Ollama readiness"
  wait_for_http "${OLLAMA_BASE}/api/tags" 120
  log_ok "Ollama ready"

  log_step 3 "Open WebUI readiness"
  wait_for_http "${WEBUI_BASE}/health" 180
  log_ok "Open WebUI ready"

  log_step 4 "Pulling embedding model: nomic-embed-text"
  docker exec ollama ollama pull nomic-embed-text
  log_ok "nomic-embed-text pulled"

  local llm_model
  llm_model=$(_llm_model)
  log_step 5 "Pulling LLM (GPU_TIER=${GPU_TIER}): ${llm_model}"
  docker exec ollama ollama pull "${llm_model}"
  log_ok "${llm_model} pulled"

  log_step 6 "Open WebUI admin setup"
  _owui_ensure_token

  log_section "Services ready"
  log_info "  Open WebUI : ${WEBUI_BASE}"
  log_info "  Ollama     : ${OLLAMA_BASE}"
  log_info "  Qdrant     : ${QDRANT_BASE}"
}

# ── run ───────────────────────────────────────────────────────────────────────
cmd_run() {
  log_section "Demo scenario"
  cd "${SCRIPT_DIR}"

  _owui_ensure_token
  local token llm_model
  token=$(cat "${TOKEN_FILE}")
  llm_model=$(_llm_model)

  log_step 1 "Creating knowledge base 'demo-docs'"
  local tmp http_code kb_id
  tmp=$(mktemp)
  http_code=$(curl -s -o "${tmp}" -w "%{http_code}" \
    -X POST "${WEBUI_BASE}/api/v1/knowledge" \
    -H "Authorization: Bearer ${token}" \
    -H "Content-Type: application/json" \
    -d '{"name":"demo-docs","description":"Demo fixture documents"}')

  if [[ "${http_code}" == "200" || "${http_code}" == "201" ]]; then
    kb_id=$(python3 -c \
      "import json,sys; print(json.load(open(sys.argv[1]))[\"id\"])" \
      "${tmp}" 2>/dev/null) || kb_id=""
    rm -f "${tmp}"
    log_ok "Knowledge base created (id=${kb_id})"
  else
    rm -f "${tmp}"
    log_warn "Knowledge base HTTP ${http_code} — looking for existing 'demo-docs'"
    kb_id=$(curl -s "${WEBUI_BASE}/api/v1/knowledge" \
      -H "Authorization: Bearer ${token}" | \
      python3 -c "import sys,json; kbs=json.load(sys.stdin); m=[k for k in kbs if isinstance(k,dict) and k.get(\"name\")==\"demo-docs\"]; print(m[0][\"id\"] if m else \"\")" \
      2>/dev/null) || kb_id=""
  fi

  if [[ -z "${kb_id}" ]]; then
    log_error "Cannot create or find knowledge base 'demo-docs'"
    exit 1
  fi

  log_step 2 "Uploading fixtures"
  _upload_fixture "${token}" "${kb_id}" "${FIXTURES_DIR}/document-retention-policy.md"
  if [[ -f "${FIXTURES_DIR}/it-security-policy.pdf" ]]; then
    _upload_fixture "${token}" "${kb_id}" "${FIXTURES_DIR}/it-security-policy.pdf"
  else
    log_warn "PDF fixture not found — skipping"
  fi

  log_step 3 "RAG query: document retention policy for financial records"
  local query_json tmp_ans rag_answer
  query_json=$(printf \
    '{"model":"%s","messages":[{"role":"user","content":"What is the document retention policy for financial records?"}],"files":[{"type":"collection","id":"%s"}]}' \
    "${llm_model}" "${kb_id}")
  tmp_ans=$(mktemp)
  http_code=$(curl -s -o "${tmp_ans}" -w "%{http_code}" \
    -X POST "${WEBUI_BASE}/api/chat/completions" \
    -H "Authorization: Bearer ${token}" \
    -H "Content-Type: application/json" \
    -d "${query_json}")

  if [[ "${http_code}" != "200" ]]; then
    log_error "RAG query failed (HTTP ${http_code})"
    cat "${tmp_ans}" >&2
    rm -f "${tmp_ans}"
    exit 1
  fi

  rag_answer=$(python3 -c \
    "import json,sys; print(json.load(open(sys.argv[1]))[\"choices\"][0][\"message\"][\"content\"])" \
    "${tmp_ans}" 2>/dev/null) || rag_answer=""
  rm -f "${tmp_ans}"

  if [[ -z "${rag_answer}" ]]; then
    log_error "RAG answer is empty"
    exit 1
  fi

  echo ""
  printf '[RAG ANSWER] %s\n' "${rag_answer}"
  echo ""

  if grep -qi "7 years" <<< "${rag_answer}"; then
    log_ok "Assertion passed: '7 years' found in RAG answer"
  else
    log_error "ASSERTION FAILED: expected '7 years' in answer"
    exit 1
  fi

  log_ok "Demo scenario complete."
}

# ── status ────────────────────────────────────────────────────────────────────
cmd_status() {
  cd "${SCRIPT_DIR}"
  docker compose ps
  echo ""
  log_info "Qdrant health:     $(curl -s -o /dev/null -w '%{http_code}' "${QDRANT_BASE}/readiness" 2>/dev/null || echo unreachable)"
  log_info "Ollama health:     $(curl -s -o /dev/null -w '%{http_code}' "${OLLAMA_BASE}/api/tags" 2>/dev/null || echo unreachable)"
  log_info "Open WebUI health: $(curl -s -o /dev/null -w '%{http_code}' "${WEBUI_BASE}/health" 2>/dev/null || echo unreachable)"
}

# ── stop ──────────────────────────────────────────────────────────────────────
cmd_stop() {
  cd "${SCRIPT_DIR}"
  log_info "Stopping services (volumes preserved)..."
  docker compose stop
  log_ok "Services stopped"
}

# ── reset ─────────────────────────────────────────────────────────────────────
cmd_reset() {
  cd "${SCRIPT_DIR}"
  log_info "Resetting — removing containers, networks and volumes..."
  docker compose down -v --remove-orphans 2>/dev/null || true
  rm -f "${TOKEN_FILE}"
  log_ok "Reset complete"
}

# ── dispatch ──────────────────────────────────────────────────────────────────
case "${1:-}" in
  check)  cmd_check ;;
  start)  cmd_start ;;
  run)    cmd_run ;;
  status) cmd_status ;;
  stop)   cmd_stop ;;
  reset)  cmd_reset ;;
  *)
    printf 'Usage: %s {check|start|run|status|stop|reset}\n' "$(basename "$0")"
    exit 2
    ;;
esac
