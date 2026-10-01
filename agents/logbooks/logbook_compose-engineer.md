# Logbook: compose-engineer

## Entry T1 — 2026-10-01

| Field | Value |
|---|---|
| Handoff | `agents/handoffs/handoff_compose-engineer_20261001_001.md` |
| Issue | `#2` |
| Branch | `feat/issue-2-private-rag` |
| Status | `completed` |

### Work performed

**Part A — `demos/private-rag/compose.yaml`**

Created the three-service topology: `qdrant`, `ollama`, `app` (Open WebUI).

All images pinned to digest:
- `qdrant/qdrant:v1.19.1@sha256:12364fe851b9f17356fc88189fc06d1b521262e04659ec7345975b00c9246a10`
- `ollama/ollama:0.35.0@sha256:2a6e883b917fc543389599dae79918f5cac9e1438890506982f44aa4f5625d01`
- `ghcr.io/open-webui/open-webui:v0.11.4@sha256:9591b13f13843c7721c2b8eaf7382846c81b3ffe126526d1888d1fed50c6a33f`

Digests retrieved via:
- qdrant/vllm: Docker Hub tags API (`hub.docker.com/v2/repositories/.../tags/<tag>`)
- open-webui: GHCR manifest API (`ghcr.io/v2/.../manifests/<tag>`) with anonymous bearer token
- ollama: Docker Hub (tag is `0.35.0` without `v` prefix on Docker Hub, `v0.35.0` on GitHub releases)

Hardening applied on all three services: `security_opt: [no-new-privileges:true]`, `cap_drop: [ALL]`. `read_only: true` applied to `qdrant` and `ollama` (primary write paths are named volumes); NOT applied to `app` per handoff (Open WebUI writes to `/app/data`). `tmpfs: [/tmp]` added to read-only services.

Health checks: qdrant `/readiness`, ollama `/api/tags`, app `/health`.

Network: internal bridge `rag-net`; only `app` exposes port 3000:8080.

**Part B — `demos/private-rag/.env.example`**

Created with placeholder values for `WEBUI_SECRET_KEY`, `QDRANT__SERVICE__API_KEY`, `OPENAI_API_BASE_URLS`.

**Part C — `packages/private-rag/docker-compose.cloud.yaml`**

Pinned `vllm/vllm-openai:latest` → `vllm/vllm-openai:v0.30.0@sha256:8a69ffad015f138d7170c4ddc429e230a3bc1c1719f67e14324749df200a4b90`.

### Validation

`docker compose config --quiet` could not be run — Docker daemon not available in this shell environment (Windows 11, no Docker Desktop active in session). YAML structure verified manually:
- 3 occurrences of `no-new-privileges:true` ✓
- 3 occurrences of `cap_drop:` ✓
- No `:latest` tags in compose.yaml ✓
- No `:latest` tags in docker-compose.cloud.yaml ✓

Operator should run `docker compose -f demos/private-rag/compose.yaml config --quiet` to confirm on a system with Docker available.

### Residual risks / notes

- Digest for `ollama/ollama:0.35.0` is the multi-arch manifest digest from Docker Hub (`hub.docker.com`). Docker Hub uses `0.35.0` (no `v` prefix); GitHub releases use `v0.35.0`.
- The `internal: true` flag on `rag-net` prevents containers from reaching external networks post-startup (fully offline once models are pulled into volumes). This is intentional.
- If models need to be pulled at runtime (not pre-loaded), operators must run `docker compose run ollama pull <model>` before the stack starts, or temporarily remove `internal: true` from `rag-net`.
