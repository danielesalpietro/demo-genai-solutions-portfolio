#!/usr/bin/env bash
# Manage demo credentials: logical-access.json (cleartext) and encrypted password files.
#
# USAGE
#   manage-credentials.sh <command> [args...]
#
# COMMANDS — password files (AES-256-CBC encrypted)
#   init   <demo> <noprod|prod>                  — initialize encrypted password file
#   show   <demo> <noprod|prod>                  — decrypt and display credentials
#   set    <demo> <noprod|prod> <key> <value>    — set / update one credential
#   unset  <demo> <noprod|prod> <key>            — remove one credential
#   rotate <demo> <noprod|prod>                  — re-encrypt with a new passphrase
#   list-keys <demo> <noprod|prod>               — list credential keys (no values)
#
# COMMANDS — logical-access.json (cleartext construction keys)
#   access init  <demo>                          — create logical-access.json from template
#   access show  <demo>                          — display logical-access.json
#   access set   <demo> <key> <value>            — set a field (dot-notation: cloud.runpod_api_key)
#   access check <demo>                          — verify all required fields are non-empty
#
# ENCRYPTED FILES
#   packages/<demo>/secrets/passwords-noprod.enc  — generic non-production passwords
#   packages/<demo>/secrets/passwords-prod.enc    — production passwords
#
# CLEARTEXT FILE (gitignored)
#   packages/<demo>/secrets/logical-access.json   — temporary construction API keys
#
# SECURITY
#   - Encrypted .enc files may be committed to the repository.
#   - logical-access.json is GITIGNORED — never commit it.
#   - Passphrases are NEVER stored anywhere; the operator keeps them.
#   - Temporary decrypted files use restricted permissions and are removed on exit.
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# --- helpers ------------------------------------------------------------------
die()  { echo "ERROR: $*" >&2; exit 1; }
info() { echo "INFO : $*"; }

require_demo() {
  local demo="$1"
  [[ -d "$root/packages/$demo" ]] || die "Unknown demo: '$demo' (no packages/$demo/)"
}

require_env() {
  local env="$1"
  [[ "$env" == "noprod" || "$env" == "prod" ]] || \
    die "environment must be 'noprod' or 'prod', got: '$env'"
}

secrets_dir() { echo "$root/packages/$1/secrets"; }
enc_file()    { echo "$root/packages/$1/secrets/passwords-${2}.enc"; }
access_file() { echo "$root/packages/$1/secrets/logical-access.json"; }
tmp_file()    { echo "$root/packages/$1/secrets/.passwords-${2}.tmp"; }

# Creates secrets/ directory and per-directory .gitignore if missing
ensure_secrets_dir() {
  local demo="$1"
  local dir
  dir="$(secrets_dir "$demo")"
  mkdir -p "$dir"
  local gi="$dir/.gitignore"
  if [[ ! -f "$gi" ]]; then
    cat > "$gi" <<'GIEOF'
# Cleartext credential files — NEVER commit these
logical-access.json
*.pem
*.key
*.p12
.passwords-*.tmp
GIEOF
  fi
}

encrypt_to_file() {
  local plaintext="$1" outfile="$2"
  openssl enc -aes-256-cbc -pbkdf2 -iter 100000 -base64 -salt \
    -in "$plaintext" -out "$outfile"
  chmod 640 "$outfile"
}

decrypt_to_stdout() {
  local enc="$1"
  openssl enc -d -aes-256-cbc -pbkdf2 -iter 100000 -base64 \
    -in "$enc"
}

decrypt_to_tmp() {
  local demo="$1" env="$2"
  local enc tmp
  enc="$(enc_file "$demo" "$env")"
  tmp="$(tmp_file "$demo" "$env")"
  [[ -f "$enc" ]] || die "Password file not found: $enc — run 'init $demo $env' first"
  info "Decrypting $enc ..."
  # Restrict permissions before writing plaintext
  touch "$tmp" && chmod 600 "$tmp"
  openssl enc -d -aes-256-cbc -pbkdf2 -iter 100000 -base64 \
    -in "$enc" -out "$tmp"
  echo "$tmp"
}

# Trap to clean up any .tmp files left by this process
trap_cleanup() {
  find "$root/packages" -name '.passwords-*.tmp' -newer "$root/packages" \
    -delete 2>/dev/null || true
}
trap trap_cleanup EXIT

# --- command: init ------------------------------------------------------------
cmd_init() {
  local demo="${1:?Usage: $0 init <demo> <noprod|prod>}"
  local env="${2:?Usage: $0 init <demo> <noprod|prod>}"
  require_demo "$demo"; require_env "$env"
  ensure_secrets_dir "$demo"

  local enc; enc="$(enc_file "$demo" "$env")"
  if [[ -f "$enc" ]]; then
    read -r -p "File $enc already exists. Overwrite? [y/N] " ans
    [[ "$ans" =~ ^[Yy]$ ]] || { info "Aborted."; exit 0; }
  fi

  # Build default JSON template
  local template; template="$(tmp_file "$demo" "$env")"
  touch "$template" && chmod 600 "$template"
  python3 - "$demo" "$env" > "$template" <<'PYEOF'
import json, sys, datetime
demo, env = sys.argv[1], sys.argv[2]
data = {
    "_note": f"Encrypted credentials for demo '{demo}' — environment: {env}",
    "demo": demo,
    "environment": env,
    "version": "1",
    "updated": datetime.datetime.utcnow().strftime("%Y-%m-%dT%H:%M:%SZ"),
    "credentials": {}
}
print(json.dumps(data, indent=2))
PYEOF

  info "Enter passphrase to encrypt passwords-${env}.enc:"
  encrypt_to_file "$template" "$enc"
  rm -f "$template"
  info "Created: $enc"
  info "Store the passphrase safely — it is NOT saved anywhere."
}

# --- command: show ------------------------------------------------------------
cmd_show() {
  local demo="${1:?Usage: $0 show <demo> <noprod|prod>}"
  local env="${2:?Usage: $0 show <demo> <noprod|prod>}"
  require_demo "$demo"; require_env "$env"
  local tmp; tmp="$(decrypt_to_tmp "$demo" "$env")"
  python3 -c "import json,sys; print(json.dumps(json.load(open(sys.argv[1])), indent=2))" "$tmp"
  rm -f "$tmp"
}

# --- command: list-keys -------------------------------------------------------
cmd_list_keys() {
  local demo="${1:?Usage: $0 list-keys <demo> <noprod|prod>}"
  local env="${2:?Usage: $0 list-keys <demo> <noprod|prod>}"
  require_demo "$demo"; require_env "$env"
  local tmp; tmp="$(decrypt_to_tmp "$demo" "$env")"
  python3 -c "
import json, sys
d = json.load(open(sys.argv[1]))
creds = d.get('credentials', {})
if not creds:
    print('(no credentials set)')
else:
    for k in sorted(creds.keys()):
        print(f'  {k}')
" "$tmp"
  rm -f "$tmp"
}

# --- command: set -------------------------------------------------------------
cmd_set() {
  local demo="${1:?Usage: $0 set <demo> <noprod|prod> <key> <value>}"
  local env="${2:?Usage: $0 set <demo> <noprod|prod> <key> <value>}"
  local key="${3:?key required}"
  local value="${4?value required (use empty string \"\" to clear)}"
  require_demo "$demo"; require_env "$env"

  local tmp enc
  tmp="$(decrypt_to_tmp "$demo" "$env")"
  enc="$(enc_file "$demo" "$env")"

  python3 - "$tmp" "$key" "$value" <<'PYEOF'
import json, sys, datetime
path, key, val = sys.argv[1], sys.argv[2], sys.argv[3]
d = json.load(open(path))
d["credentials"][key] = val
d["updated"] = datetime.datetime.utcnow().strftime("%Y-%m-%dT%H:%M:%SZ")
with open(path, "w") as f:
    json.dump(d, f, indent=2)
print(f"Set credentials.{key}")
PYEOF

  info "Re-encrypting (use same passphrase):"
  encrypt_to_file "$tmp" "$enc"
  rm -f "$tmp"
  info "Updated: $enc"
}

# --- command: unset -----------------------------------------------------------
cmd_unset() {
  local demo="${1:?Usage: $0 unset <demo> <noprod|prod> <key>}"
  local env="${2:?Usage: $0 unset <demo> <noprod|prod> <key>}"
  local key="${3:?key required}"
  require_demo "$demo"; require_env "$env"

  local tmp enc
  tmp="$(decrypt_to_tmp "$demo" "$env")"
  enc="$(enc_file "$demo" "$env")"

  python3 - "$tmp" "$key" <<'PYEOF'
import json, sys, datetime
path, key = sys.argv[1], sys.argv[2]
d = json.load(open(path))
if key in d.get("credentials", {}):
    del d["credentials"][key]
    d["updated"] = datetime.datetime.utcnow().strftime("%Y-%m-%dT%H:%M:%SZ")
    with open(path, "w") as f:
        json.dump(d, f, indent=2)
    print(f"Removed credentials.{key}")
else:
    print(f"Key not found: credentials.{key}")
PYEOF

  info "Re-encrypting (use same passphrase):"
  encrypt_to_file "$tmp" "$enc"
  rm -f "$tmp"
}

# --- command: rotate ----------------------------------------------------------
cmd_rotate() {
  local demo="${1:?Usage: $0 rotate <demo> <noprod|prod>}"
  local env="${2:?Usage: $0 rotate <demo> <noprod|prod>}"
  require_demo "$demo"; require_env "$env"

  local tmp enc
  tmp="$(decrypt_to_tmp "$demo" "$env")"
  enc="$(enc_file "$demo" "$env")"

  info "Enter NEW passphrase for $enc:"
  encrypt_to_file "$tmp" "$enc"
  rm -f "$tmp"
  info "Rotated: $enc — update any team members or CI secrets that held the old passphrase."
}

# --- command: access ----------------------------------------------------------
cmd_access() {
  local subcmd="${1:?Usage: $0 access <init|show|set|check> <demo> [key] [value]}"
  shift
  local demo="${1:?Usage: $0 access $subcmd <demo> [key] [value]}"
  require_demo "$demo"
  ensure_secrets_dir "$demo"
  local af; af="$(access_file "$demo")"

  case "$subcmd" in
    init)
      if [[ -f "$af" ]]; then
        read -r -p "$af already exists. Overwrite? [y/N] " ans
        [[ "$ans" =~ ^[Yy]$ ]] || { info "Aborted."; exit 0; }
      fi
      local tmpl="$root/packages/$demo/secrets/logical-access.json.template"
      if [[ -f "$tmpl" ]]; then
        cp "$tmpl" "$af"
      else
        python3 - "$demo" > "$af" <<'PYEOF'
import json, sys
demo = sys.argv[1]
print(json.dumps({
    "_note": "TEMPORARY construction keys — rotate after use. NEVER COMMIT THIS FILE.",
    "demo": demo,
    "environment": "dev",
    "cloud": {
        "runpod_api_key": "",
        "vast_ai_api_key": "",
        "ghcr_token": "",
        "ssh_private_key_path": "~/.ssh/id_ed25519"
    },
    "inference_apis": {
        "mistral_api_key": "",
        "together_api_key": ""
    },
    "expires_at": "",
    "rotation_notes": ""
}, indent=2))
PYEOF
      fi
      chmod 600 "$af"
      info "Created: $af"
      info "Fill in credentials, then DO NOT add this file to git."
      ;;

    show)
      [[ -f "$af" ]] || die "$af not found — run 'access init $demo' first"
      cat "$af"
      ;;

    set)
      local key="${2:?key required (dot-notation: cloud.runpod_api_key)}"
      local value="${3?value required}"
      [[ -f "$af" ]] || die "$af not found — run 'access init $demo' first"
      python3 - "$af" "$key" "$value" <<'PYEOF'
import json, sys
path, key, val = sys.argv[1], sys.argv[2], sys.argv[3]
d = json.load(open(path))
parts = key.split(".")
node = d
for part in parts[:-1]:
    node = node.setdefault(part, {})
node[parts[-1]] = val
with open(path, "w") as f:
    json.dump(d, f, indent=2)
print(f"Set {key}")
PYEOF
      info "Updated: $af"
      ;;

    check)
      [[ -f "$af" ]] || die "$af not found — run 'access init $demo' first"
      python3 - "$af" <<'PYEOF'
import json, sys
d = json.load(open(sys.argv[1]))
cloud = d.get("cloud", {})
missing = [k for k, v in cloud.items() if not v and k != "ssh_private_key_path"]
if missing:
    print("WARNING: empty fields in cloud:")
    for k in missing:
        print(f"  cloud.{k}")
    sys.exit(1)
else:
    print("OK: all cloud fields populated.")
PYEOF
      ;;

    *) die "Unknown access subcommand: $subcmd (use init|show|set|check)" ;;
  esac
}

# --- dispatch -----------------------------------------------------------------
cmd="${1:-}"
shift || true

case "$cmd" in
  init)        cmd_init "$@" ;;
  show)        cmd_show "$@" ;;
  list-keys)   cmd_list_keys "$@" ;;
  set)         cmd_set "$@" ;;
  unset)       cmd_unset "$@" ;;
  rotate)      cmd_rotate "$@" ;;
  access)      cmd_access "$@" ;;
  "")
    cat <<'USAGE'
manage-credentials.sh — demo credential management

ENCRYPTED PASSWORD FILES (openssl AES-256-CBC):
  init   <demo> <noprod|prod>                  create password file
  show   <demo> <noprod|prod>                  decrypt and display
  list-keys <demo> <noprod|prod>               list keys (no values)
  set    <demo> <noprod|prod> <key> <value>    set one credential
  unset  <demo> <noprod|prod> <key>            remove one credential
  rotate <demo> <noprod|prod>                  re-encrypt with new passphrase

CLEARTEXT ACCESS FILE (logical-access.json — gitignored):
  access init  <demo>                          create from template
  access show  <demo>                          display file
  access set   <demo> <key.subkey> <value>     set field (dot-notation)
  access check <demo>                          verify fields populated

EXAMPLES:
  ./scripts/manage-credentials.sh init private-rag noprod
  ./scripts/manage-credentials.sh set  private-rag noprod POSTGRES_PASSWORD s3cr3t
  ./scripts/manage-credentials.sh show private-rag noprod
  ./scripts/manage-credentials.sh rotate private-rag prod
  ./scripts/manage-credentials.sh access init private-rag
  ./scripts/manage-credentials.sh access set  private-rag cloud.runpod_api_key abc123
USAGE
    ;;
  *) die "Unknown command: '$cmd' — run without arguments for help" ;;
esac
