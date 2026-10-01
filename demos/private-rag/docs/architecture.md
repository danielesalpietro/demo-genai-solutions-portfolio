# Private RAG — Architecture

## Component Diagram

```
  ┌─────────────────────────────────────────────────────────────┐
  │                        Host machine                          │
  │                                                               │
  │  User Browser ──── port 3000 ────► ┌──────────────────────┐ │
  │                                    │     Open WebUI        │ │
  │                                    │  (open-webui:v0.11.4) │ │
  │                                    │    port 8080 (int.)   │ │
  │                                    └───────┬───────┬───────┘ │
  │                                            │       │         │
  │                             rag-net        │       │         │
  │              ┌─────────────────────────────┘       │         │
  │              ▼                                     ▼         │
  │  ┌───────────────────────┐         ┌───────────────────────┐ │
  │  │       Qdrant          │         │       Ollama           │ │
  │  │  (qdrant:v1.19.1)    │         │  (ollama:0.35.0)      │ │
  │  │  REST  6333 (host)    │         │  REST  11434 (host)   │ │
  │  │  gRPC  6334 (host)    │         │                       │ │
  │  │  storage: qdrant-data │         │  storage: ollama-data │ │
  │  └───────────────────────┘         └───────────────────────┘ │
  │                                                               │
  └─────────────────────────────────────────────────────────────┘
```

All inter-service communication uses Docker DNS names (`qdrant`, `ollama`, `app`) on the `rag-net` bridge network. No host-networking or privileged containers are used.

---

## Data Flow

### Document Ingestion

```
User (browser)
  │
  │  POST /api/v1/files/  (multipart upload)
  ▼
Open WebUI
  │  chunk document (configurable size / overlap)
  │  POST /api/embeddings  →  Ollama (nomic-embed-text)
  │                           ← float32 vector [768-dim]
  │  PUT /collections/documents/points  →  Qdrant
  │                                        stores (vector, payload)
  └─► "File added to knowledge base"
```

### Query and Retrieval

```
User (browser)
  │
  │  POST /api/chat/completions  (with files=[{type:"collection",id:"…"}])
  ▼
Open WebUI
  │  embed question  →  Ollama (nomic-embed-text)
  │                      ← query vector [768-dim]
  │  vector search  →  Qdrant
  │                      ← top-k chunks + metadata
  │  build prompt:
  │    [system]  You are a helpful assistant.
  │    [context] <retrieved chunks>
  │    [user]    <original question>
  │  POST /api/chat  →  Ollama (mistral:7b-instruct-q4_K_M or variant)
  │                      ← streamed token response
  └─► streamed answer with cited sources to browser
```

---

## Deployment Modes

| Mode | `GPU_TIER` value | LLM model | VRAM required | Notes |
|---|---|---|---|---|
| CPU (default) | `cpu` | `mistral:7b-instruct-q4_K_M` | none | ~8 GB RAM; ~6–8 tok/s on modern CPU |
| RTX 5060 Ti | `rtx5060ti` | `mistral-nemo:12b-instruct-2407-q4_K_M` | 12 GB | CUDA 12.x; NVIDIA Container Toolkit ≥ 1.14 |
| RTX 3090 | `rtx3090` | `mistral-small3.1:24b-instruct-2503-q4_K_M` | 24 GB | CUDA 12.x; full 24 GB VRAM model |
| Cloud API | `cloud` (future) | via `OPENAI_API_BASE_URLS` | none | Routes inference to an external OpenAI-compatible endpoint |

GPU profiles are activated by setting `GPU_TIER` in `.env`. The `compose.yaml` Ollama service must be extended with `deploy.resources.reservations.devices` for GPU access — see the NVIDIA Container Toolkit documentation.

The embedding service (`nomic-embed-text`) and Qdrant are identical across all modes; only the LLM selection changes.

---

## Network Topology

```
Host OS
  ├── 0.0.0.0:3000  ──►  app:8080      (Open WebUI HTTP)
  ├── 0.0.0.0:11434 ──►  ollama:11434  (Ollama REST — for direct model management)
  ├── 0.0.0.0:6333  ──►  qdrant:6333   (Qdrant REST — for administration)
  └── 0.0.0.0:6334  ──►  qdrant:6334   (Qdrant gRPC — used by Open WebUI)

Docker bridge network: rag-net
  app     → qdrant  (http://qdrant:6333, grpc://qdrant:6334)
  app     → ollama  (http://ollama:11434)
  ollama  → internet (model pulls from registry.ollama.ai)
  qdrant  → (no outbound calls)
```

Port overrides: set `DEMO_PORT`, `OLLAMA_PORT`, `QDRANT_PORT`, `QDRANT_GRPC_PORT` in `.env` if defaults conflict with existing services.

---

## Volume Layout

| Volume name | Mounted in | Path inside container | Contents |
|---|---|---|---|
| `ollama-data` | `ollama` | `/root/.ollama` | Downloaded models (nomic-embed-text, mistral variants); ~8–25 GB depending on tier |
| `qdrant-data` | `qdrant` | `/qdrant/storage` | Vector collections, WAL, snapshots; size grows with ingested documents |
| `open-webui-data` | `app` | `/app/data` | SQLite database (users, knowledge base metadata, chat history), uploaded file cache |

All three volumes are named Docker volumes managed by Compose. They persist across `./demo.sh stop` and are removed only by `./demo.sh reset` (`docker compose down -v`).

---

## Security Design

- All containers run with `cap_drop: ALL` and `security_opt: no-new-privileges:true`.
- Qdrant and Ollama containers are `read_only: true`; writable paths are mounted via `tmpfs` or named volumes.
- `ENABLE_SIGNUP: "false"` on Open WebUI prevents self-registration; accounts must be created by the admin.
- `WEBUI_AUTH: "true"` enforces authentication on every Open WebUI request.
- Qdrant `QDRANT__SERVICE__API_KEY` is optional for local demos; set it for any network-exposed deployment.
- All secrets live in `.env` which is `.gitignore`d; the only secret in the image layers is the session signing key path (not its value).
