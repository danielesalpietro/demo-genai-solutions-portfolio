# Release Notes — speech-intelligence

## Current status: candidate · v0.1.0-candidate

---

## v0.1.0-candidate — 2026-10-01

### Changes
- Initial candidate entry; faster-whisper and WhisperLive identified
- License compatibility confirmed (MIT for transcription engine and model weights)
- No implementation yet

### Open items
- [ ] Choose default model size for CPU demo (tiny vs base vs small)
- [ ] Decide whether to include live microphone input (requires WhisperLive WebSocket service)
- [ ] Define sample audio fixture (synthetic or publicly licensed recording)

---

## Prerequisites

### Hardware

#### CPU-only — standard transcription (recommended for most demos)

| Component | Minimum | Recommended |
|---|---|---|
| CPU | x86_64 with AVX2 | x86_64, 4+ cores, AVX2 |
| RAM | 4 GB | 8 GB |
| Disk | 5 GB | 8 GB |
| GPU | Not required | Not required |

**Model size guidance for CPU:**

| Model | Parameters | VRAM / RAM | CPU speed (approx.) | Use case |
|---|---|---|---|---|
| tiny | 39 M | ~1 GB | ~30× realtime | Quick demo |
| base | 74 M | ~1 GB | ~15× realtime | Balanced |
| small | 244 M | ~2 GB | ~6× realtime | **Recommended default** |
| medium | 769 M | ~5 GB | ~2× realtime | Higher accuracy |
| large-v3 | 1 550 M | ~10 GB | ~0.5× realtime | Maximum accuracy |

#### GPU-accelerated configuration

| Component | Minimum | Recommended |
|---|---|---|
| GPU VRAM | 4 GB (small model) | 10 GB+ (large-v3) |
| GPU (NVIDIA) | GTX 1060 6 GB · T4 16 GB | RTX 3060 12 GB · RTX 4070 12 GB · A10 24 GB |
| RAM | 8 GB | 16 GB |

> With a T4 or RTX 3060, `large-v3` transcribes at ~30× realtime (1 hour audio in ~2 min).

### Software

| Requirement | Minimum version |
|---|---|
| Docker Engine | 27.0 |
| Docker Compose | 2.20 |
| NVIDIA Container Toolkit | 1.14 (if GPU) |
| OS | Linux, macOS, Windows WSL2 |

### Network

| Requirement | Details |
|---|---|
| Internet at setup | Required for image pull and Whisper model download (~150 MB – 3 GB) |
| Internet at demo runtime | Not required |
| Offline capable | Yes, after initial setup |

### Ports

| Port | Service |
|---|---|
| 8000 | faster-whisper API |
| 9090 | WhisperLive WebSocket (optional) |
| 7860 | Gradio UI |
| 11434 | Ollama API |
