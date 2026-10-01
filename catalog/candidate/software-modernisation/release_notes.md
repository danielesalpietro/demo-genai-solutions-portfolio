# Release Notes — software-modernisation

## Current status: candidate · v0.1.0-candidate

---

## v0.1.0-candidate — 2026-10-01

### Changes
- Initial candidate entry; OpenRewrite and LangGraph identified as primary stack
- Apache-2.0 + MIT license compatibility confirmed
- No implementation yet

### Open items
- [ ] Choose target language for demo fixture: Java (Spring Boot 2→3) or Python (Flask 2→3 + dep upgrade)
- [ ] Define synthetic legacy application fixture (intentional outdated deps + deprecated APIs)
- [ ] Confirm OpenRewrite CLI availability as Docker image
- [ ] Design human-in-the-loop checkpoint: assessment approval before transformation execution

---

## Prerequisites

### Hardware

| Component | Minimum | Recommended |
|---|---|---|
| CPU | x86_64 with AVX2 | x86_64, 8+ cores, AVX2 |
| RAM | 8 GB | 16 GB |
| Disk | 20 GB | 30 GB |
| GPU | Not required | Not required |

> Code analysis and transformation are primarily CPU-bound tasks.  
> **Recommended LLM model (CPU):** Llama 3.1 8B Q4_K_M or Qwen2.5-Coder 7B Q4_K_M.  
> OpenRewrite transformations on a small project (~10 k LOC) complete in <30 seconds on any modern CPU.

#### GPU-accelerated configuration (for faster LLM code reasoning)

| Component | Minimum | Recommended |
|---|---|---|
| GPU VRAM | 8 GB | 12 GB+ |
| GPU (NVIDIA) | RTX 3060 12 GB | RTX 4070 12 GB · A10 24 GB |

### Software

| Requirement | Minimum version |
|---|---|
| Docker Engine | 27.0 |
| Docker Compose | 2.30 |
| Java (in container) | 17 (for OpenRewrite; provided in service image) |
| OS | Linux; macOS; Windows WSL2 |

### Network

| Requirement | Details |
|---|---|
| Internet at setup | Required for image pull and model download (~6–10 GB) |
| Internet at demo runtime | Not required |
| Offline capable | Yes, after initial setup |

### Ports

| Port | Service |
|---|---|
| 7860 | Gradio / agent UI |
| 11434 | Ollama API |
