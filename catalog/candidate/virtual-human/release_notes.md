# Release Notes — virtual-human

## Current status: candidate · v0.1.0-candidate

---

## v0.1.0-candidate — 2026-10-01

### Changes
- Initial candidate entry; IAcine-3D-Avatar identified as primary base
- No implementation yet

### Open items
- [ ] Verify license on IAcine-3D-Avatar repo (currently MIT — reconfirm)
- [ ] Test Piper TTS latency in a browser-driven pipeline
- [ ] Evaluate whether GPU is needed for acceptable TTS + LLM combined latency
- [ ] Decide on avatar hosting: ReadyPlayerMe cloud vs local GLB file

---

## Prerequisites

### Hardware

#### CPU-only configuration

| Component | Minimum | Recommended |
|---|---|---|
| CPU | x86_64 with AVX2 | x86_64, 8+ cores, AVX2 |
| RAM | 8 GB | 16 GB |
| Disk | 10 GB | 20 GB |
| GPU | Not required | Not required |

> **LLM model (CPU):** Llama 3.2 3B Q4_K_M (~2 GB, ~10 tok/s); acceptable for conversational latency.  
> **TTS:** Piper runs on CPU; voice synthesis ~0.05× realtime (very fast).  
> **Browser GPU:** WebGL rendering uses the display GPU (even integrated); no CUDA required.  
> Conversational response latency on CPU: 3–8 seconds total (LLM + TTS + animation sync).

#### Dedicated GPU configuration (recommended for live demos)

| Component | Minimum | Recommended |
|---|---|---|
| GPU VRAM | 6 GB | 8 GB+ |
| GPU (NVIDIA) | RTX 3060 12 GB · GTX 1070 8 GB | RTX 4060 8 GB · RTX 4070 12 GB |
| RAM | 16 GB | 32 GB |

> **LLM model (GPU, 8 GB vRAM):** Llama 3.1 8B Q4_K_M (≈4.7 GB vRAM); response ~1–2 seconds.  
> At a live presentation, sub-2-second response makes the demo noticeably more engaging.

**Display note:** The browser renderer uses the system GPU for WebGL. On a laptop with an integrated GPU (Intel Iris Xe, AMD Radeon 780M), 3D rendering is smooth at standard demo resolution (1080p). A discrete GPU improves frame rate but is not required for display rendering.

### Software

| Requirement | Minimum version |
|---|---|
| Docker Engine | 27.0 |
| Docker Compose | 2.20 |
| Browser | Chrome 120+ · Firefox 121+ (WebGL 2.0 required) |
| OS | Linux, macOS, Windows WSL2 |

### Network

| Requirement | Details |
|---|---|
| Internet at setup | Required for image pull, LLM model, Piper voice model (~5–10 GB) |
| ReadyPlayerMe avatar | One-time download of GLB file (~50 MB); can be cached |
| Internet at demo runtime | Not required (after initial asset cache) |
| Offline capable | Yes, after initial setup |

### Ports

| Port | Service |
|---|---|
| 3000 | Avatar web application |
| 11434 | Ollama API |
| 5002 | Piper TTS API |
| 8000 | LLM proxy / conversation API |
