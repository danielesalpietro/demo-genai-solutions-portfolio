# Release Notes — finance-agent

## Current status: candidate · v0.1.0-candidate

---

## v0.1.0-candidate — 2026-10-01

### Changes
- Initial candidate entry; FinanceAgent and FinanceBench identified
- Demo scope explicitly limited to research and analysis (no transaction execution)
- No implementation yet

### Open items
- [ ] Verify license of FinanceAgent repository
- [ ] Obtain or prepare public filing fixtures (publicly available annual reports; no confidential data)
- [ ] Confirm that no real-time market data API is required at demo runtime
- [ ] Define scope boundary: make explicit in UI that this is a research tool, not a financial advisor

---

## Prerequisites

### Hardware

| Component | Minimum | Recommended |
|---|---|---|
| CPU | x86_64 with AVX2 | x86_64, 6+ cores, AVX2 |
| RAM | 8 GB | 16 GB |
| Disk | 10 GB | 20 GB |
| GPU | Not required | Not required |

> Financial document Q&A is primarily a text reasoning task; CPU inference is suitable.  
> **Recommended model:** Llama 3.1 8B Q4_K_M; strong instruction following and long-context reasoning.  
> PDF fixture pre-indexing (one-time at startup): ~1–3 minutes for 50 documents on CPU.

#### GPU-accelerated configuration

| Component | Minimum | Recommended |
|---|---|---|
| GPU VRAM | 6 GB | 8 GB+ |
| GPU (NVIDIA) | RTX 3060 12 GB · T4 | RTX 4070 12 GB · A10 24 GB |

> With GPU, interactive Q&A response latency drops to ~1–3 seconds per query.

### Software

| Requirement | Minimum version |
|---|---|
| Docker Engine | 27.0 |
| Docker Compose | 2.20 |
| OS | Linux; macOS; Windows WSL2 |

### Network

| Requirement | Details |
|---|---|
| Internet at setup | Required for image pull and model download (~6–10 GB) |
| Internet at demo runtime | Not required (public filings loaded as fixtures) |
| Financial data API | Not required |
| Offline capable | Yes, after initial setup |

### Ports

| Port | Service |
|---|---|
| 7860 | Gradio UI |
| 11434 | Ollama API |
| 6333 | Qdrant (vector store for filings) |
