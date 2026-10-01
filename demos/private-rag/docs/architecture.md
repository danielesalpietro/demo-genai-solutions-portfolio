# Private RAG — Architecture Outline

> **Note**: This is a structured outline for the documentation-writer (T4) to expand into full narrative documentation. Bullet points are intentionally terse.

---

## Overview

- Fully self-hosted, air-gapped-capable RAG stack
- No data leaves the host; all inference and embedding runs locally
- Targets enterprise knowledge management use cases (policy retrieval, internal Q&A)
- GPU-optional: runs on CPU (slower) or accelerated on NVIDIA RTX 3090 / RTX 5060 Ti

---

## Component Diagram

```
User Browser
     |
     v
Open WebUI (port 3000)
     |                    |
     v                    v
Qdrant (6333/6334)    Ollama (11434)
  vector store          LLM inference
```

- **Open WebUI** -> Qdrant: stores and retrieves document chunk embeddings for RAG context
- **Open WebUI** -> Ollama: sends assembled prompts; receives generated responses
- **Qdrant** gRPC (6334) used internally by Open WebUI; REST (6333) exposed for administration
- All three services on isolated `rag-net` bridge network; only Open WebUI port 3000 exposed to host

---

## Data Flow

### Ingestion path

1. User uploads document (PDF, Markdown, plain text) via Open WebUI
2. Open WebUI chunks the document (configurable chunk size / overlap)
3. Chunks are embedded using the embedding model served by Ollama
4. Embeddings + metadata stored in Qdrant collection `documents`

### Query path

1. User submits a natural-language question via Open WebUI chat
2. Question is embedded; Qdrant retrieves top-k similar chunks
3. Retrieved chunks are assembled into a context window with the question
4. Full prompt sent to Ollama LLM; streamed response returned to user

---

## Deployment Modes

| Mode | Profile | Notes |
|---|---|---|
| CPU | default | No GPU needed; slower inference; suitable for testing |
| RTX 5060 Ti | `--profile gpu-5060ti` | NVIDIA RTX 5060 Ti; CUDA 12.x driver required |
| RTX 3090 | `--profile gpu-3090` | NVIDIA RTX 3090; CUDA 12.x driver required |
| Cloud API | `--profile cloud` | vLLM sidecar replaces Ollama; requires API key |

GPU profiles add `deploy.resources.reservations.devices` to the Ollama service. The Qdrant and Open WebUI services are identical across all modes.

---

## Networking

- Bridge network `rag-net` with `internal: false` (required for Ollama model pulls and Open WebUI updates)
- Port bindings (host -> container):
  - `3000:8080` -- Open WebUI
  - `11434:11434` -- Ollama REST API
  - `6333:6333` -- Qdrant REST
  - `6334:6334` -- Qdrant gRPC
- All inter-service communication uses Docker DNS service names (`qdrant`, `ollama`, `app`)
- No host networking; no privileged containers