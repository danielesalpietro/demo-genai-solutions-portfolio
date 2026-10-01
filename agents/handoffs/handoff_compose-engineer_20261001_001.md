# Handoff: compose-engineer — T1

## Header

| Field | Value |
|---|---|
| Handoff file | `agents/handoffs/handoff_compose-engineer_20261001_001.md` |
| Role | `compose-engineer` |
| Issue | `#2` |
| Branch | `feat/issue-2-private-rag` |
| Follows | _(none)_ |
| Status | `pending` |
| Requested | `2026-10-01T00:00Z` |
| Completed | _(filled by session)_ |

## Assigned To

- **Role**: `compose-engineer`
- **Execution context**: `local`
- **OS**: Windows 11 / WSL2 acceptable for validation
- **Session**: _(filled by operator when activating)_

## Context

This task is part of the work for Issue #2: feat: implement private-rag — Enterprise Knowledge Assistant.

The goal is to create the Docker Compose topology for the private-rag demo, which consists of three services: Open WebUI (chat UI + RAG pipeline), Ollama (local LLM serving), and Qdrant (vector store). All services must run fully offline after initial image pull. Additionally, the existing `packages/private-rag/docker-compose.cloud.yaml` uses `vllm/vllm-openai:latest` which must be pinned to a digest.

## Prerequisites

Before executing:
- [ ] Read `agents/logbooks/logbook_compose-engineer.md` if it exists
- [ ] Verify you are on branch `feat/issue-2-private-rag`
- [ ] Confirm `docker compose` is available for validation (`docker compose version`)
- [ ] Pull latest `feat/issue-2-private-rag` from origin

## Task Instructions

### Part A — Create `demos/private-rag/compose.yaml`

1. Create directory `demos/private-rag/` if it does not exist.

2. Look up the current stable pinned digests for these images:
   - `ghcr.io/open-webui/open-webui` — use the latest stable release tag (e.g. `v0.6.x`) with its `@sha256:...` digest
   - `ollama/ollama` — use the latest stable release tag with digest
   - `qdrant/qdrant` — use the latest stable release tag (≥ v1.13) with digest

3. Write `demos/private-rag/compose.yaml` with the following structure:
   - **services**: `qdrant`, `ollama`, `app` (Open WebUI)
   - **Hardening** on every service: `read_only: true` where feasible (Open WebUI writes to `/app/data` so it cannot be read-only), `security_opt: [no-new-privileges:true]`, `cap_drop: [ALL]`
   - **Restart policy**: `restart: "no"` on all services (demos are not persistent)
   - **Health checks**:
     - `qdrant`: `curl -sf http://localhost:6333/readiness`
     - `ollama`: `curl -sf http://localhost:11434/api/tags`
     - `app` (Open WebUI): `curl -sf http://localhost:8080/health`
   - **Networks**: one internal network `rag-net`; only `app` exposes port 3000 externally (`app` container port is 8080, host port 3000)
   - **Volumes**: named volumes `ollama-data` and `qdrant-data` and `open-webui-data`
   - **Environment variables** (all from `.env`):
     - `app` (Open WebUI): `OLLAMA_BASE_URL=http://ollama:11434`, `OPENAI_API_BASE_URLS` (leave blank), `VECTOR_DB=qdrant`, `QDRANT_URI=http://qdrant:6333`, `WEBUI_SECRET_KEY`, `WEBUI_AUTH=true`, `DEFAULT_USER_ROLE=user`, `ENABLE_SIGNUP=false`
     - `qdrant`: `QDRANT__SERVICE__API_KEY` (from `.env`, optional for demo mode)
     - `ollama`: no required env vars beyond what the image sets
   - **Dependency ordering**: `app` depends_on `ollama` (condition: service_healthy), `app` depends_on `qdrant` (condition: service_healthy), `ollama` and `qdrant` have no dependencies
   - **NO** Docker socket mounts, host networking, or privileged containers

4. Validate: run `docker compose -f demos/private-rag/compose.yaml config --quiet` — must exit 0.

### Part B — Create `demos/private-rag/.env.example`

5. Write `demos/private-rag/.env.example` with all variables referenced in `compose.yaml` set to safe placeholder values. Include:
   ```
   WEBUI_SECRET_KEY=CHANGE_ME_32_CHAR_MIN
   QDRANT__SERVICE__API_KEY=
   ```
   All values must be placeholders (`CHANGE_ME`, empty, or `0`). No real secrets.

### Part C — Pin vllm image in cloud override

6. Open `packages/private-rag/docker-compose.cloud.yaml`. Find the `vllm` service entry with `image: vllm/vllm-openai:latest`. Replace `latest` with a pinned version tag + digest. Use the most recent stable `vllm/vllm-openai` release tag (e.g. `v0.8.x`) with `@sha256:...` digest. Look up the actual digest using `docker manifest inspect` or the GHCR/Docker Hub manifest API.

7. After pinning, validate: `docker compose -f demos/private-rag/compose.yaml -f packages/private-rag/docker-compose.cloud.yaml config --quiet` — must exit 0.

### Part D — Commit

8. Stage and commit the three files on branch `feat/issue-2-private-rag`:
   - `demos/private-rag/compose.yaml`
   - `demos/private-rag/.env.example`
   - `packages/private-rag/docker-compose.cloud.yaml`
   
   Commit message: `feat(private-rag): compose topology, env example, vllm image pin`

9. Append entry to `agents/logbooks/logbook_compose-engineer.md` and commit: `chore(compose-engineer): logbook update — private-rag T1`

## Expected Outputs

| Path | Description |
|---|---|
| `demos/private-rag/compose.yaml` | Compose topology — 3 services, pinned digests, health checks, hardened |
| `demos/private-rag/.env.example` | All env variables with placeholder values |
| `packages/private-rag/docker-compose.cloud.yaml` | vllm image pinned to digest (was `latest`) |
| `agents/logbooks/logbook_compose-engineer.md` | Updated logbook entry (required) |
| `agents/handoffs/handoff_compose-engineer_20261001_001.result.md` | Result file (required) |

## Success Criteria

The task is complete when ALL of these are true:

- [ ] `docker compose -f demos/private-rag/compose.yaml config --quiet` exits 0
- [ ] `docker compose -f demos/private-rag/compose.yaml -f packages/private-rag/docker-compose.cloud.yaml config --quiet` exits 0
- [ ] No image uses `:latest` tag in any committed file
- [ ] All images are pinned to `tag@sha256:digest`
- [ ] `.env.example` contains only placeholder values
- [ ] `no-new-privileges:true` and `cap_drop: [ALL]` present on all services
- [ ] Logbook entry written and committed
- [ ] Result file written with `status: completed`

## Credentials / Access

| What | Source | Operator-provided value |
|---|---|---|
| None required | — | — |

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
