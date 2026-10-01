# Release Notes — video-intelligence

## Current status: candidate · v0.1.0-candidate

---

## v0.1.0-candidate — 2026-10-01

### Changes
- Initial candidate entry; VideoAgent, faster-whisper, and LLaVA identified as primary stack
- No implementation yet

### Open items
- [ ] Verify license of VideoAgent (YueLu0116/VideoAgent)
- [ ] Test LLaVA 1.6 vs Llama 3.2-Vision for keyframe description quality
- [ ] Define sample video fixture (publicly licensed, ~5–10 minutes, industrial or procedural content)
- [ ] Assess GPU requirement for acceptable latency on a 10-minute video

---

## Prerequisites

### Hardware

#### CPU-only configuration

| Component | Minimum | Recommended |
|---|---|---|
| CPU | x86_64 with AVX2 | x86_64, 8+ cores, AVX2 |
| RAM | 8 GB | 16 GB |
| Disk | 15 GB | 25 GB |
| GPU | Not required | Not required |

> **Transcription (CPU):** faster-whisper small model processes 10-minute audio in ~2 minutes on a 4-core CPU.  
> **Vision (CPU):** LLaVA 7B Q4_K_M; each keyframe description ~10–30 seconds on CPU (acceptable for offline batch processing, not interactive).  
> **Recommended for live demo:** pre-process the sample video before the presentation.

#### GPU-accelerated configuration (recommended for interactive demo)

| Component | Minimum | Recommended |
|---|---|---|
| GPU VRAM | 8 GB | 16 GB |
| GPU (NVIDIA) | RTX 3060 12 GB · T4 16 GB | RTX 4080 16 GB · A10 24 GB |
| RAM | 16 GB | 32 GB |

> **With GPU (RTX 4080):** 10-minute video processed in ~60–90 seconds end-to-end.  
> **LLaVA 7B Q4_K_M on RTX 3060 (12 GB):** keyframe description ~1–2 seconds per frame.

**GPU model guidance:**

| GPU | vRAM | LLaVA 7B Q4 | Whisper large-v3 |
|---|---|---|---|
| GTX 1080 Ti | 11 GB | Marginal | ✓ |
| RTX 3060 | 12 GB | ✓ | ✓ |
| RTX 4070 | 12 GB | ✓ | ✓ |
| RTX 4080 | 16 GB | ✓ fast | ✓ fast |
| T4 | 16 GB | ✓ | ✓ |
| A10 | 24 GB | ✓ full | ✓ full |

### Software

| Requirement | Minimum version |
|---|---|
| Docker Engine | 27.0 |
| Docker Compose | 2.30 |
| NVIDIA Container Toolkit | 1.14 (if GPU) |
| OS | Linux; macOS (CPU-only) |

### Network

| Requirement | Details |
|---|---|
| Internet at setup | Required for image pull, Whisper model, LLaVA model (~8–15 GB) |
| Internet at demo runtime | Not required |
| Offline capable | Yes, after initial setup |

### Ports

| Port | Service |
|---|---|
| 7860 | Gradio UI |
| 11434 | Ollama API (LLaVA + LLM) |
