# Logbook: compose-engineer

<!--
  This file is APPEND-ONLY. Never edit or delete prior entries.
  Each session that acts as this role appends one entry at the bottom.
  Format: ## <ISO datetime> — <entry-type>: <one-line summary>
  Entry types: plan | dispatch | execute | verify | pr | escalate | error | note
-->

---

## Usage

**Read** this file at the start of every session for this role to recover context.  
**Append** one entry per meaningful action taken. Commit after appending.  
Do not modify entries written by prior sessions.

---

<!-- ENTRIES BELOW — oldest first, newest last -->

## 2026-10-01T00:00Z — execute: private-rag T1 — compose topology, env example, vllm pin

**Handoff**: `agents/handoffs/handoff_compose-engineer_20261001_001.md`  
**Issue**: `#2` — feat: implement private-rag  
**Branch**: `feat/issue-2-private-rag`

**Actions taken**:
- Fetched latest stable image versions and manifest-list digests via Docker Hub API and `docker buildx imagetools inspect`.
- Created `demos/private-rag/compose.yaml`: 3-service topology (qdrant v1.19.1, ollama 0.35.0, open-webui v0.11.4), all images pinned with `tag@sha256:digest`, rag-net bridge network, named volumes, `no-new-privileges:true` + `cap_drop: ALL` on all services, `read_only: true` on qdrant and ollama, `restart: "no"`, health checks on all three services, `app` depends_on qdrant + ollama (service_healthy).
- Created `demos/private-rag/.env.example`: all env vars with placeholder values only.
- Pinned `vllm/vllm-openai` in `packages/private-rag/docker-compose.cloud.yaml` from `:latest` to `v0.30.0@sha256:8a69ffad…`.
- Validated: `docker compose -f demos/private-rag/compose.yaml config --quiet` → exit 0.
- Validated: `docker compose -f demos/private-rag/compose.yaml -f packages/private-rag/docker-compose.cloud.yaml config --quiet` → exit 0.

**Images pinned**:
| Service | Image | Tag | Digest (manifest list) |
|---|---|---|---|
| qdrant | `qdrant/qdrant` | `v1.19.1` | `sha256:12364fe851b9f17356fc88189fc06d1b521262e04659ec7345975b00c9246a10` |
| ollama | `ollama/ollama` | `0.35.0` | `sha256:2a6e883b917fc543389599dae79918f5cac9e1438890506982f44aa4f5625d01` |
| app | `ghcr.io/open-webui/open-webui` | `v0.11.4` | `sha256:9591b13f13843c7721c2b8eaf7382846c81b3ffe126526d1888d1fed50c6a33f` |
| vllm | `vllm/vllm-openai` | `v0.30.0` | `sha256:8a69ffad015f138d7170c4ddc429e230a3bc1c1719f67e14324749df200a4b90` |

**Notes**:
- SSH to `192.168.1.110` was attempted but timed out (sandbox network restriction); used local Docker Desktop instead for manifest inspection and validation.
- `read_only: true` applied to qdrant (+ tmpfs `/tmp`, `/qdrant/snapshots`) and ollama (+ tmpfs `/tmp`, `/run`). Open WebUI is not read-only as it writes to `/app/data`.
- T2 (demo-designer) and T5 (security-reviewer) can proceed independently; T3 (script-engineer) waits on T1+T2.

**Commit**: `143c2a8` — `feat(private-rag): compose topology, env example, vllm image pin`
