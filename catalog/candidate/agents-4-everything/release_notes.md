# Release Notes — agents-4-everything

## Current status: candidate · v0.1.0-candidate

---

## v0.1.0-candidate — 2026-10-01

### Changes
- Initial candidate entry; LangGraph, CrewAI, and AutoGen identified as primary options
- MIT license compatibility confirmed for LangGraph and CrewAI
- Microsoft Agent Framework (AutoGen + Semantic Kernel merge) noted: GA Q1 2026
- No implementation yet

### Open items
- [ ] Choose primary framework for initial implementation (LangGraph recommended)
- [ ] Define scenario and agent roles for the demo (feasibility assessment is one option)
- [ ] Confirm CrewAI variant as secondary implementation (for comparison demo)

---

## Prerequisites

### Hardware

| Component | Minimum | Recommended |
|---|---|---|
| CPU | x86_64 with AVX2 | x86_64, 8+ cores, AVX2 |
| RAM | 8 GB | 16 GB |
| Disk | 15 GB | 25 GB |
| GPU | Not required | Not required |

> Three parallel LLM agents on CPU: total latency ~60–120 seconds (sequential execution).  
> With GPU, parallel agent calls complete in ~10–20 seconds.  
> **Recommended model:** Llama 3.1 8B Q4_K_M; sufficient for multi-step reasoning tasks.

#### GPU-accelerated configuration

| Component | Minimum | Recommended |
|---|---|---|
| GPU VRAM | 8 GB | 16 GB |
| GPU (NVIDIA) | RTX 3060 12 GB · T4 | RTX 4080 16 GB · A10 |

### Software

| Requirement | Minimum version |
|---|---|
| Docker Engine | 27.0 |
| Docker Compose | 2.30 |
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
| 7860 | Gradio UI |
| 11434 | Ollama API |
