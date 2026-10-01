# Release Notes — private-rag

## Current status: candidate · v0.1.0-candidate

---

## v0.1.0-candidate — 2026-10-01

### Changes
- Initial candidate entry; upstream repositories identified and verified
- License compatibility confirmed (MIT + Apache-2.0)
- Hardware prerequisites documented
- No implementation yet; pending GitHub Issue and acceptance criteria

### Open items before development begins
- [ ] Confirm default Ollama model (Llama 3.1 8B vs Mistral 7B)
- [ ] Decide on document ingestion pipeline (Unstructured vs Tika)
- [ ] Define synthetic document fixture set
- [ ] Confirm GPU availability in CI smoke environment

---

## Prerequisites

### Hardware

#### CPU-only configuration (recommended for demos without a GPU)

| Component | Minimum | Recommended |
|---|---|---|
| CPU | x86_64 with AVX2 | x86_64, 8+ cores, AVX2/AVX-512 |
| RAM | 8 GB | 16 GB |
| Disk | 20 GB | 40 GB |
| GPU | Not required | Not required |

> **Recommended model for CPU-only:** Llama 3.2 3B Q4_K_M (≈2.0 GB, ~10 tok/s on 8-core CPU)  
> **Acceptable model for CPU-only:** Mistral 7B Q4_K_M (≈4.1 GB, ~5 tok/s on 8-core CPU)

#### GPU-accelerated configuration

| Component | Minimum | Recommended |
|---|---|---|
| CPU | x86_64 with AVX2 | x86_64, 8+ cores |
| RAM | 16 GB | 32 GB |
| Disk | 30 GB | 60 GB |
| GPU VRAM | 8 GB | 16 GB+ |
| GPU (NVIDIA) | RTX 3060 12 GB · T4 | RTX 4080 16 GB · A10 24 GB · A100 |
| GPU (AMD) | RX 7600 8 GB (ROCm) | RX 7900 XTX 24 GB |

> **Recommended model for 8 GB vRAM:** Llama 3.1 8B Q4_K_M (≈4.7 GB vRAM, ~60 tok/s)  
> **Recommended model for 16 GB vRAM:** Llama 3.1 8B FP16 (≈15 GB vRAM, ~120 tok/s) or Mistral 7B FP16

### Software

| Requirement | Minimum version | Notes |
|---|---|---|
| Docker Engine | 27.0 | |
| Docker Compose | 2.30 | |
| NVIDIA Container Toolkit | 1.14 | Only if GPU used |
| OS | Linux (kernel 5.15+) | macOS and Windows WSL2 supported; GPU passthrough requires Linux |

### Network

| Requirement | Details |
|---|---|
| Internet at setup | Required to pull Ollama image, Qdrant image, Open WebUI image, and LLM weights |
| Model pull size | ~2–8 GB depending on model choice |
| Internet at demo runtime | Not required |
| Offline capable | Yes, after initial setup |

### Ports

| Port | Service |
|---|---|
| 3000 | Open WebUI |
| 11434 | Ollama API |
| 6333 | Qdrant HTTP |
| 6334 | Qdrant gRPC |
