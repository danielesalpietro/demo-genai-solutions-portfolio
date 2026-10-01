# Release Notes — supply-chain-agent

## Current status: candidate · v0.1.0-candidate

---

## v0.1.0-candidate — 2026-10-01

### Changes
- Initial candidate entry; upstream repositories and orchestration framework identified
- LangGraph selected as primary orchestrator (production-grade stateful workflows)
- No implementation yet

### Open items
- [ ] Confirm upstream repository license (verify current repo state)
- [ ] Define synthetic invoice + PO fixture set (include mismatch scenarios)
- [ ] Design human-in-the-loop approval step in the Compose service topology
- [ ] Decide: run six agents in a single container (Compose simplicity) or as separate services?

---

## Prerequisites

### Hardware

| Component | Minimum | Recommended |
|---|---|---|
| CPU | x86_64 with AVX2 | x86_64, 8+ cores, AVX2 |
| RAM | 8 GB | 16 GB |
| Disk | 20 GB | 30 GB |
| GPU | Not required | Not required |

> Multi-agent pipelines with six LLM calls per run benefit from faster CPU inference.  
> **Recommended model:** Llama 3.1 8B Q4_K_M for CPU; Mistral 7B Q4_K_M for GPU.  
> Expected total latency per demo run (CPU, 8-core): 30–90 seconds.

#### GPU-accelerated configuration

| Component | Minimum | Recommended |
|---|---|---|
| GPU VRAM | 8 GB | 16 GB |
| GPU (NVIDIA) | RTX 3060 12 GB · T4 | RTX 4080 16 GB · A10 24 GB |

> With GPU, expected total latency per demo run: 5–15 seconds.

### Software

| Requirement | Minimum version |
|---|---|
| Docker Engine | 27.0 |
| Docker Compose | 2.30 |
| NVIDIA Container Toolkit | 1.14 (if GPU) |
| OS | Linux, macOS, Windows WSL2 |

### Network

| Requirement | Details |
|---|---|
| Internet at setup | Required for image pull and model download (~6–10 GB) |
| Internet at demo runtime | Not required |
| Offline capable | Yes, after initial setup |

### Ports

| Port | Service |
|---|---|
| 7860 | Gradio UI |
| 11434 | Ollama API |
| 5432 | PostgreSQL (audit log) |
