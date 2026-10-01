#!/usr/bin/env bash
# Structured logging helpers. Source this file; do not execute directly.
set -euo pipefail

_log() {
  local level="$1"; shift
  echo "[$(date -u '+%Y-%m-%dT%H:%M:%SZ')] [$level] $*"
}

log_info()    { _log INFO    "$@"; }
log_ok()      { _log OK      "$@"; }
log_warn()    { _log WARN    "$@" >&2; }
log_error()   { _log ERROR   "$@" >&2; }
log_section() { echo ""; echo "==> $*"; }

# Print a step banner: log_step 1 "Pull images"
log_step() {
  local n="$1"; shift
  echo ""
  echo "--- Step $n: $* ---"
}
