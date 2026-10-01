# Release Notes — context-fabric

## Current status: candidate · v0.1.0-candidate

---

## v0.1.0-candidate — 2026-10-01

### Changes
- Initial candidate entry; ContextFabric AI repository identified
- No implementation yet

### Open items
- [ ] **Verify license on current repo state** (shubhamdusane/context-fabric) — escalate if non-permissive
- [ ] Obtain or generate synthetic industrial tag fixture set (PLC/DCS naming conventions; no real OT data)
- [ ] Confirm Ollama compatibility with the existing ContextFabric codebase
- [ ] Decide scope: full multi-agent pipeline vs single-agent normalisation for initial demo

---

## Prerequisites

### Hardware

| Component | Minimum | Recommended |
|---|---|---|
| CPU | x86_64 with AVX2 | x86_64, 6+ cores, AVX2 |
| RAM | 8 GB | 16 GB |
| Disk | 15 GB | 25 GB |
| GPU | Not required | Not required |

> **Recommended model:** Llama 3.1 8B Q4_K_M (strong structured output / JSON mode).  
> Semantic normalisation benefits from instruction-following capability; 8B models are sufficient.  
> Expected latency per 500-tag batch (CPU, 8-core): 2–5 minutes (batch processing, not interactive).

#### GPU-accelerated configuration

| Component | Minimum | Recommended |
|---|---|---|
| GPU VRAM | 6 GB | 12 GB+ |
| GPU (NVIDIA) | RTX 3060 12 GB · T4 | RTX 4070 12 GB · A10 24 GB |

> With GPU, 500-tag normalisation completes in ~30 seconds.

### Software

| Requirement | Minimum version |
|---|---|
| Docker Engine | 27.0 |
| Docker Compose | 2.20 |
| OS | Linux, macOS, Windows WSL2 |

### Network

| Requirement | Details |
|---|---|
| Internet at setup | Required for image pull and model download (~5–8 GB) |
| Internet at demo runtime | Not required |
| OT network connectivity | Not required (demo uses file-based fixtures) |
| Offline capable | Yes, after initial setup |

### Ports

| Port | Service |
|---|---|
| 7860 | Gradio UI |
| 11434 | Ollama API |
