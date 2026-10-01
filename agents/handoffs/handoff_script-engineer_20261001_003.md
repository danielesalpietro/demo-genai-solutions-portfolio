# Handoff: script-engineer — T3

## Header

| Field | Value |
|---|---|
| Handoff file | `agents/handoffs/handoff_script-engineer_20261001_003.md` |
| Role | `script-engineer` |
| Issue | `#2` |
| Branch | `feat/issue-2-private-rag` |
| Follows | _(none — depends on T1 and T2 being complete)_ |
| Status | `pending` |
| Requested | `2026-10-01T00:00Z` |
| Completed | _(filled by session)_ |

## Assigned To

- **Role**: `script-engineer`
- **Execution context**: `local`
- **OS**: Linux / macOS / WSL2
- **Session**: _(filled by operator when activating)_

## Context

This task is part of the work for Issue #2: feat: implement private-rag — Enterprise Knowledge Assistant.

The script-engineer creates the lifecycle scripts (`demo.sh`, `test.sh`, `reset.sh`) for the private-rag demo. These scripts must fully automate the demo narrative from the Issue: start services, automate Open WebUI first-run admin setup via API, upload a fixture document, issue a RAG query, and assert a cited answer is returned.

**Prerequisites already delivered (verify before starting)**:
- T1 (compose-engineer): `demos/private-rag/compose.yaml`, `demos/private-rag/.env.example`
- T2 (demo-designer): `demos/private-rag/fixtures/document-retention-policy.md`, fixture PDF (or note about generation), `demos/private-rag/demo.yaml`

## Prerequisites

Before executing:
- [ ] Read `agents/logbooks/logbook_script-engineer.md` if it exists
- [ ] Verify you are on branch `feat/issue-2-private-rag` and have pulled latest
- [ ] Verify T1 result file shows `status: completed`
- [ ] Verify T2 result file shows `status: completed`
- [ ] Read `demos/private-rag/.env.example` — know all variable names
- [ ] Read `demos/private-rag/fixtures/` — note exact filenames and key content assertions
- [ ] Read `templates/common/logging.sh` and `templates/common/wait-for-service.sh`
- [ ] Read `demos/hello-compose/demo.sh` as a reference implementation

## Task Instructions

All scripts must begin with `set -euo pipefail`. Use `templates/common/logging.sh` for structured output and `templates/common/wait-for-service.sh` for readiness waiting. No hardcoded ports or credentials — read from `.env` (sourced at script top if present).

### Part A — `demos/private-rag/demo.sh`

Write `demos/private-rag/demo.sh` implementing the following subcommands:

**`check`** — verify prerequisites:
1. Docker is installed and daemon is running
2. Docker Compose plugin is available
3. `.env` file exists in the same directory (or warn and continue with defaults)
4. Required ports are free: 3000, 11434, 6333, 6334
5. Print "Prerequisites OK" and exit 0 if all pass; exit 1 with clear message on first failure

**`start`** — start services and wait for healthy state:
1. Source `.env` if present
2. `docker compose up -d`
3. Wait for Qdrant health: `wait-for-service.sh http://localhost:6333/readiness` (timeout 120s)
4. Wait for Ollama health: `wait-for-service.sh http://localhost:11434/api/tags` (timeout 120s)
5. Wait for Open WebUI health: `wait-for-service.sh http://localhost:3000/health` (timeout 180s)
6. Pull Ollama models (embedding + LLM):
   - Always pull `nomic-embed-text` (embedding)
   - Pull the LLM based on `GPU_TIER` env var (`rtx3090` → `mistral-small3.1:24b-instruct-2503-q4_K_M`, `rtx5060ti` → `mistral-nemo:12b-instruct-2407-q4_K_M`, default/cpu → `mistral:7b-instruct-q4_K_M`)
   - Use `docker exec ollama ollama pull <model>`
7. Automate Open WebUI first-run admin account creation:
   - POST to `http://localhost:3000/api/v1/auths/signup` with body `{"name":"Admin","email":"admin@demo.local","password":"${WEBUI_ADMIN_PASSWORD:-DemoAdmin123!}"}`
   - If the response is 200/201, save the returned token to a temp file `/tmp/owui-token`
   - If the response is 400 (account already exists), call `POST /api/v1/auths/signin` instead and save token
8. Print service URLs: Open WebUI: http://localhost:3000, Ollama API: http://localhost:11434, Qdrant: http://localhost:6333

**`run`** — execute the demo scenario:
1. Source `.env` if present
2. Load auth token from `/tmp/owui-token`; if missing, re-run the signin step from `start`
3. Set the Open WebUI default model via API: `POST /api/v1/models/default` (if the endpoint exists) — otherwise skip
4. Create a knowledge base (collection) named "demo-docs": `POST /api/v1/knowledge` with name "demo-docs"
5. Upload fixture documents to the knowledge base:
   - Upload `demos/private-rag/fixtures/document-retention-policy.md` via `POST /api/v1/knowledge/{id}/file/add` (multipart form)
   - If a PDF fixture exists in `fixtures/`, upload it too; otherwise skip
6. Issue a RAG query: `POST /api/chat/completions` with:
   - model: the LLM model that was pulled in `start`
   - messages: `[{"role":"user","content":"What is the document retention policy for financial records?"}]`
   - Include the knowledge base in the request (check Open WebUI API docs for the correct `files` or `collection` parameter)
7. Parse the response and assert it is non-empty
8. Print the answer verbatim, prefixed with `[RAG ANSWER]`
9. Assert the answer contains "7 years" (case-insensitive); exit 1 with message "ASSERTION FAILED: expected '7 years' in answer" if not found
10. Print "Demo scenario complete." and exit 0

**`status`** — show service health:
1. `docker compose ps`
2. Print each service health endpoint result

**`stop`** — stop services, preserve volumes:
1. `docker compose stop` (NOT `down -v`)

**`reset`** — stop and remove everything:
1. `docker compose down -v --remove-orphans`
2. Remove `/tmp/owui-token` if it exists
3. Must be idempotent: re-running when nothing is running must exit 0

### Part B — `demos/private-rag/test.sh`

Write `demos/private-rag/test.sh` for contract tests (no running services required):

1. Verify all required files exist: `compose.yaml`, `.env.example`, `demo.yaml`, `demo.sh`, `test.sh`, `reset.sh`, `README.md`
2. Verify `demo.sh`, `test.sh`, `reset.sh` are executable
3. Verify `demo.yaml` is valid YAML (use `python3 -c "import yaml, sys; yaml.safe_load(sys.stdin)" < demo.yaml`)
4. Verify `compose.yaml` passes `docker compose config --quiet`
5. Verify no `latest` tag appears in `compose.yaml`
6. Verify `.env.example` does not contain any value that looks like a real secret (simple pattern: no values > 30 chars that aren't `CHANGE_ME_*`)
7. Verify `fixtures/document-retention-policy.md` exists and contains "7 years"
8. Print "All contract tests passed." and exit 0

### Part C — `demos/private-rag/reset.sh`

Write `demos/private-rag/reset.sh`:

1. `set -euo pipefail`
2. `cd "$(dirname "$0")"`
3. `docker compose down -v --remove-orphans 2>/dev/null || true`
4. `rm -f /tmp/owui-token`
5. Exit 0 always (idempotent by design with `|| true`)

### Part D — Make scripts executable and validate

6. `chmod +x demos/private-rag/demo.sh demos/private-rag/test.sh demos/private-rag/reset.sh`
7. Run `shellcheck demos/private-rag/demo.sh demos/private-rag/test.sh demos/private-rag/reset.sh` — fix all findings before committing

### Part E — Commit

8. Stage and commit on branch `feat/issue-2-private-rag`:
   - `demos/private-rag/demo.sh`
   - `demos/private-rag/test.sh`
   - `demos/private-rag/reset.sh`
   
   Commit message: `feat(private-rag): lifecycle scripts — demo.sh, test.sh, reset.sh`

9. Append entry to `agents/logbooks/logbook_script-engineer.md` and commit: `chore(script-engineer): logbook update — private-rag T3`

## Expected Outputs

| Path | Description |
|---|---|
| `demos/private-rag/demo.sh` | Full lifecycle script, shellcheck-clean, executable |
| `demos/private-rag/test.sh` | Contract tests, shellcheck-clean, executable |
| `demos/private-rag/reset.sh` | Idempotent reset, shellcheck-clean, executable |
| `agents/logbooks/logbook_script-engineer.md` | Updated logbook entry (required) |
| `agents/handoffs/handoff_script-engineer_20261001_003.result.md` | Result file (required) |

## Success Criteria

The task is complete when ALL of these are true:

- [ ] `shellcheck demos/private-rag/demo.sh demos/private-rag/test.sh demos/private-rag/reset.sh` exits 0
- [ ] All three scripts are executable (`-rwxr-xr-x`)
- [ ] `demo.sh reset` is idempotent (running twice exits 0)
- [ ] `demo.sh run` includes assertion on "7 years" in RAG answer
- [ ] No hardcoded ports or credentials in scripts
- [ ] Logbook entry written and committed
- [ ] Result file written with `status: completed`

## Credentials / Access

| What | Source | Operator-provided value |
|---|---|---|
| None required for writing scripts | — | — |

## Result

| Field | Value |
|---|---|
| Status | `pending` |
| Completed | _(filled by session)_ |
| Exit code | _(0 = success)_ |
| Session | _(filled by operator)_ |

### Summary

_(filled by session)_

### Artifacts produced

_(filled by session)_

### Issues encountered

_(filled by session)_

### Supervisor action needed

- [ ] None — task complete as specified
- [ ] Follow-up handoff needed: _(description)_
- [ ] Escalate to human: _(reason)_
