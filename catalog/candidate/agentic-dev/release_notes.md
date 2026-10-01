# Release Notes — agentic-dev

## Current status: candidate · v0.1.0-candidate

---

## v0.1.0-candidate — 2026-10-01

### Changes
- Initial candidate entry; docker/compose-for-agents and LangGraph identified as primary stack
- Apache-2.0 + MIT license compatibility confirmed
- No implementation yet

### Open items
- [ ] Design synthetic target repository fixture (Python, intentional bugs, tests)
- [ ] Define sandbox isolation: git-in-container vs bind mount with restricted permissions
- [ ] Decide scope of PR creation: local `git` commands only, or GitHub API integration
- [ ] Confirm LLM choice for code reasoning (Llama 3.1 8B vs Code-specific model)

---

## Prerequisites

### Hardware

#### CPU-only configuration

| Component | Minimum | Recommended |
|---|---|---|
| CPU | x86_64 with AVX2 | x86_64, 8+ cores, AVX2 |
| RAM | 8 GB | 16 GB |
| Disk | 20 GB | 30 GB |
| GPU | Not required | Not required |

> **Recommended model:** Llama 3.1 8B Q4_K_M or Qwen2.5-Coder 7B Q4_K_M.  
> Code-specific models (Qwen2.5-Coder, DeepSeek-Coder) improve code reasoning accuracy significantly.  
> Expected latency per agent cycle (CPU): 20–60 seconds.

#### GPU-accelerated configuration

| Component | Minimum | Recommended |
|---|---|---|
| GPU VRAM | 8 GB | 16 GB |
| GPU (NVIDIA) | RTX 3060 12 GB | RTX 4080 16 GB · A10 24 GB |
| RAM | 16 GB | 32 GB |

> **Recommended model for GPU:** Qwen2.5-Coder 7B FP16 (≈14 GB vRAM) or Llama 3.1 8B Q4_K_M (≈4.7 GB vRAM).

### Software

| Requirement | Minimum version |
|---|---|
| Docker Engine | 27.0 |
| Docker Compose | 2.30 |
| NVIDIA Container Toolkit | 1.14 (if GPU) |
| OS | Linux; macOS (CPU-only); Windows WSL2 |

### Network

| Requirement | Details |
|---|---|
| Internet at setup | Required for image pull and model download (~6–10 GB) |
| Internet at demo runtime | Not required (local git only; no GitHub API call required) |
| Offline capable | Yes, after initial setup |

### Ports

| Port | Service |
|---|---|
| 7860 | Gradio / agent UI |
| 11434 | Ollama API |
| 3000 | Local Gitea (optional; if GitHub API simulation needed) |
