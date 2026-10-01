# Private RAG — Enterprise Knowledge Assistant

## 1. Overview

The Enterprise Knowledge Assistant lets regulated-industry teams upload internal documents (PDF, DOCX, Markdown) and query them through a chat interface. All inference, vector indexing, and retrieval run locally on the host machine. No data leaves the machine and no external API calls are made: embeddings, vector search, and LLM inference are fully self-contained. Target users are compliance, legal, and operations teams that must keep sensitive documents inside a controlled perimeter.

---

## 2. Architecture

### Services

| Service | Image | Host Port | Purpose |
|---|---|---|---|
| Open WebUI | `ghcr.io/open-webui/open-webui:v0.11.4` | `3000` → `8080` | Chat UI, document management, RAG orchestration |
| Ollama | `ollama/ollama:0.35.0` | `11434` | Embedding model + LLM inference |
| Qdrant | `qdrant/qdrant:v1.19.1` | `6333` (REST), `6334` (gRPC) | Vector store |

All three services communicate on the isolated bridge network `rag-net`; only Open WebUI port 3000 is exposed to the host.

### Data Flow

**Ingestion**: document upload → Open WebUI chunks the document → `nomic-embed-text` (via Ollama) generates embeddings → embeddings + metadata stored in Qdrant collection.

**Query**: user question → `nomic-embed-text` embeds the question → Qdrant vector search retrieves top-k chunks → chunks assembled into a context window → full prompt sent to Mistral (via Ollama) → streamed, cited answer returned to the user.

See [`docs/architecture.md`](docs/architecture.md) for full technical detail including component diagrams, deployment modes, and volume layout.

---

## 3. Prerequisites

| Requirement | Minimum | Recommended |
|---|---|---|
| Docker Engine | 27.0 | latest |
| Docker Compose | 2.30 | latest |
| RAM | 12 GB | 16 GB |
| Disk | 20 GB free | 40 GB free |
| GPU | not required (CPU path) | NVIDIA 8 GB+ VRAM |
| NVIDIA Container Toolkit | — | ≥ 1.14 (GPU path only) |

---

## 4. Quick Start

```bash
git clone https://github.com/DanieleS/demo-genai-solutions-portfolio
cd demo-genai-solutions-portfolio/demos/private-rag
cp .env.example .env
# Edit .env: set WEBUI_SECRET_KEY to a random 32-character string
./demo.sh check
./demo.sh start
# Open http://localhost:3000 — first-run admin setup is automated by demo.sh start
./demo.sh run
```

> **First run**: `./demo.sh start` pulls the Ollama models (`nomic-embed-text` and the LLM). This takes 5–15 minutes depending on bandwidth. Subsequent starts reuse cached layers.

---

## 5. Demo Scenario

The `./demo.sh run` command executes the following steps automatically:

1. Authenticates with Open WebUI (creates the admin account on first run, signs in on subsequent runs).
2. Creates a knowledge base named `demo-docs`.
3. Uploads `fixtures/document-retention-policy.md` (and `fixtures/it-security-policy.pdf` if present) to the knowledge base; the documents are chunked and embedded into Qdrant.
4. Sends a RAG query: *"What is the document retention policy for financial records?"*
5. Asserts that the answer contains the string `7 years`.

### Expected terminal output (abbreviated)

```
=== Demo scenario ===
[INFO] Step 1: Creating knowledge base 'demo-docs'
[OK]   Knowledge base created (id=<uuid>)
[INFO] Step 2: Uploading fixtures
[OK]   document-retention-policy.md added to knowledge base
[INFO] Step 3: RAG query: document retention policy for financial records

[RAG ANSWER] Financial records must be retained for a minimum of 7 years in accordance
with regulatory requirements. This includes general ledger records, accounts payable and
receivable, bank statements, tax returns, and payroll records.

[OK]   Assertion passed: '7 years' found in RAG answer
[OK]   Demo scenario complete.
```

The exact phrasing of the RAG answer will vary with each run; the assertion requires only that `7 years` appears in the answer.

---

## 6. Operations

| Command | Effect |
|---|---|
| `./demo.sh check` | Verify prerequisites: Docker daemon, Compose plugin, port availability |
| `./demo.sh start` | Start all services, wait for health, pull models, set up admin account |
| `./demo.sh run` | Execute the full demo scenario (create KB, upload docs, RAG query, assert) |
| `./demo.sh status` | Show container status and HTTP health for all three services |
| `./demo.sh stop` | Stop services; volumes (models, embeddings) are preserved for fast restart |
| `./demo.sh reset` | Stop services and remove all volumes and the auth token cache |

---

## 7. Troubleshooting

### Port already in use

`./demo.sh check` reports which port is occupied. To identify and free the process:

```bash
# Linux / macOS
lsof -i :3000
lsof -i :11434
lsof -i :6333
lsof -i :6334

# Windows (PowerShell)
netstat -ano | findstr ":3000"
```

Stop the conflicting process or change the port in `.env` (e.g. `DEMO_PORT=3001`).

### Ollama model pull fails (network timeout)

Model pulls happen inside the `ollama` container. Retry by re-running `./demo.sh start`; the pull resumes from the last downloaded layer. If behind a proxy, set `HTTP_PROXY` and `HTTPS_PROXY` in `.env` and uncomment the `environment:` block for the `ollama` service in `compose.yaml`.

### Open WebUI shows "Connection refused"

Services may still be initialising after `docker compose up`. Wait 30 seconds and run `./demo.sh status` to check health endpoints. If Ollama or Qdrant shows `unreachable`, inspect logs:

```bash
docker compose logs ollama
docker compose logs qdrant
```

### `demo.sh run` assertion fails — `7 years` not in answer

The RAG answer depends on the document having been correctly ingested. Check:

1. `./demo.sh status` — confirm all services report HTTP 200.
2. Run `./demo.sh reset` then `./demo.sh start` to re-ingest from a clean state.
3. Confirm `fixtures/document-retention-policy.md` exists and is not empty.

### Low RAM — Ollama OOM or very slow inference

`mistral:7b-instruct-q4_K_M` (the CPU-path model) requires approximately 8 GB of RAM to run. Close other applications and browser tabs. If the host has less than 12 GB total, use a smaller model by editing the `_llm_model()` function in `demo.sh` to use `phi3:mini` or similar.

---

## 8. Cleanup

Remove all demo artifacts (containers, volumes, networks, and the auth token cache):

```bash
./demo.sh reset
```

To also remove the pulled Docker images (frees 10–15 GB):

```bash
docker image rm qdrant/qdrant:v1.19.1
docker image rm ollama/ollama:0.35.0
docker image rm ghcr.io/open-webui/open-webui:v0.11.4
```

---

## 9. Security Notes

| Credential | Description | Default | Notes |
|---|---|---|---|
| `WEBUI_SECRET_KEY` | JWT signing key for Open WebUI sessions | `CHANGE_ME_32_CHAR_MIN_SECRET_KEY` | **Must be changed before use.** Set in `.env`. Never commit `.env`. |
| `QDRANT__SERVICE__API_KEY` | Optional REST API key for Qdrant | _(blank — no auth)_ | Blank is acceptable for local-only demos. Set for any shared or network-exposed deployment. |
| `WEBUI_ADMIN_PASSWORD` | Admin account password for Open WebUI | `DemoAdmin123!` | Default is intentionally weak for demo convenience. **Change for any non-demo use.** |

All credentials are managed via `.env`; `.env` is listed in `.gitignore` and must never be committed.

**To rotate credentials**:

```bash
./demo.sh reset        # remove all volumes (old tokens, embeddings)
# Edit .env with new values
./demo.sh start        # fresh admin account created with new credentials
```
