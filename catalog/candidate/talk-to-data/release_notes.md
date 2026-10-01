# Release Notes — talk-to-data

## Current status: candidate · v0.1.0-candidate

---

## v0.1.0-candidate — 2026-10-01

### Changes
- Initial candidate entry; upstream repositories identified (Vanna, LIDA, Ollama)
- License compatibility confirmed (MIT)
- No implementation yet; pending GitHub Issue

### Open items
- [ ] Choose between Vanna RAG backend and a custom schema-to-SQL prompt chain
- [ ] Define synthetic dataset (sales + margin, ≥10k rows)
- [ ] Confirm LIDA chart renderer integration with local Ollama

---

## Prerequisites

### Hardware

#### CPU-only configuration

| Component | Minimum | Recommended |
|---|---|---|
| CPU | x86_64 with AVX2 | x86_64, 6+ cores, AVX2 |
| RAM | 8 GB | 16 GB |
| Disk | 15 GB | 25 GB |
| GPU | Not required | Not required |

> **Recommended model:** Llama 3.2 3B Q4_K_M for CPU-only; response latency ≈ 3–8 s on modern CPU.  
> Text-to-SQL is token-light; smaller models are sufficient.

#### GPU-accelerated configuration

| Component | Minimum | Recommended |
|---|---|---|
| GPU VRAM | 6 GB | 8 GB+ |
| GPU (NVIDIA) | RTX 3060 12 GB · GTX 1080 Ti 11 GB | RTX 4070 12 GB · A10 24 GB |

> **Recommended model for GPU:** Mistral 7B Q4_K_M (≈4.1 GB vRAM) or Llama 3.1 8B Q4_K_M.

### Software

| Requirement | Minimum version |
|---|---|
| Docker Engine | 27.0 |
| Docker Compose | 2.20 |
| OS | Linux, macOS, Windows WSL2 |

### Network

| Requirement | Details |
|---|---|
| Internet at setup | Required for image and model pull (~6–10 GB total) |
| Internet at demo runtime | Not required |
| Offline capable | Yes, after initial setup |

### Ports

| Port | Service |
|---|---|
| 8000 | Vanna / LIDA API |
| 7860 | Gradio UI |
| 5432 | PostgreSQL |
| 11434 | Ollama API |
