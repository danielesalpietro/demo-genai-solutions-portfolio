# Release Notes — content-creator

## Current status: candidate · v0.1.0-candidate

---

## v0.1.0-candidate — 2026-10-01

### Changes
- Initial candidate entry; short-video-maker and Piper TTS identified as primary stack
- No implementation yet

### Open items
- [ ] Verify license on short-video-maker and Toonflow-app
- [ ] Choose TTS engine: Piper (MIT, fast, CPU) vs Coqui TTS (Mozilla Public License)
- [ ] Define video quality/resolution target for demo (720p is sufficient)
- [ ] Confirm whether GPU is needed for video rendering at demo resolution

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

> **LLM model:** Llama 3.1 8B Q4_K_M for screenplay generation.  
> **TTS:** Piper runs efficiently on CPU; ~0.1× realtime for narration.  
> **Video rendering:** FFmpeg CPU encoding at 720p produces a ~30-second clip in ~20–60 seconds.

#### GPU-accelerated configuration

| Component | Minimum | Recommended |
|---|---|---|
| GPU VRAM | 6 GB | 8 GB+ |
| GPU (NVIDIA) | RTX 3060 · T4 | RTX 4070 · A10 |
| RAM | 16 GB | 32 GB |

> GPU accelerates LLM inference and optional diffusion-based image generation for scene thumbnails.  
> **Note:** Toonflow-app uses diffusion models; GPU with ≥8 GB vRAM required for animated storyboard scenes.

### Software

| Requirement | Minimum version |
|---|---|
| Docker Engine | 27.0 |
| Docker Compose | 2.30 |
| FFmpeg | Included in service image |
| OS | Linux; macOS (CPU-only) |

### Network

| Requirement | Details |
|---|---|
| Internet at setup | Required for image pull, LLM model, TTS voice model (~5–12 GB) |
| Internet at demo runtime | Not required |
| Offline capable | Yes, after initial setup |

### Ports

| Port | Service |
|---|---|
| 7860 | Gradio UI |
| 11434 | Ollama API |
| 5002 | TTS API |
