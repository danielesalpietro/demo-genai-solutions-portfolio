# Release Notes — embodied-ai

## Current status: candidate · v0.1.0-candidate

---

## v0.1.0-candidate — 2026-10-01

### Changes
- Initial candidate entry; ManiSkill and LeRobot identified as primary frameworks
- MIT + Apache-2.0 license compatibility confirmed
- No implementation yet; GPU requirement documented

### Open items
- [ ] Confirm GPU availability in development and demo environment
- [ ] Choose between ManiSkill (GPU-parallel, research-grade) and LeRobot (hardware roadmap)
- [ ] Define minimal task for CPU-only fallback (pick-and-place with single environment)
- [ ] Assess Genesis as alternative simulation backend

---

## Prerequisites

### Hardware

#### GPU configuration (required for full demo)

| Component | Minimum | Recommended |
|---|---|---|
| CPU | x86_64, 8 cores | x86_64, 12+ cores |
| RAM | 16 GB | 32 GB |
| Disk | 20 GB | 40 GB |
| GPU VRAM | 8 GB | 16 GB+ |
| GPU (NVIDIA) | RTX 3060 12 GB · RTX 3070 8 GB | RTX 4080 16 GB · RTX 4090 24 GB · A10 24 GB |

> **Primary GPU requirement:** ManiSkill GPU-parallelised simulation requires CUDA 11.8+ and ≥8 GB vRAM.  
> RTX 3060 12 GB: suitable for single-environment demo.  
> RTX 4080/4090: enables GPU-parallel demo with multiple simultaneous environments (visually impressive).  
> A100 40 GB: maximum throughput; not required for a demo scenario.

**GPU model table:**

| GPU | vRAM | CUDA | Single env | Multi-env (×N) |
|---|---|---|---|---|
| GTX 1080 Ti | 11 GB | 11.8 | ✓ (limited) | ✗ |
| RTX 3060 | 12 GB | 12.0 | ✓ | ×4 |
| RTX 3080 | 10 GB | 12.0 | ✓ | ×4 |
| RTX 4070 Ti | 12 GB | 12.3 | ✓ | ×8 |
| RTX 4090 | 24 GB | 12.3 | ✓ | ×32 |
| A10 | 24 GB | 12.1 | ✓ | ×32 |
| A100 40 GB | 40 GB | 12.4 | ✓ | ×128 |

#### CPU-only fallback (minimal demo, reduced visual quality)

| Component | Minimum | Recommended |
|---|---|---|
| CPU | x86_64, 8 cores, AVX2 | x86_64, 16 cores |
| RAM | 16 GB | 32 GB |
| Disk | 15 GB | 30 GB |

> CPU-only mode available in ManiSkill with software rendering (OSMesa). Single environment, slower physics step. Suitable for a conceptual demo; not recommended for a primary commercial presentation.

### Software

| Requirement | Minimum version | Notes |
|---|---|---|
| Docker Engine | 27.0 | |
| Docker Compose | 2.30 | |
| NVIDIA Container Toolkit | 1.14 | Required for GPU mode |
| CUDA (host) | 11.8 | Required for GPU mode |
| OS | Linux (kernel 5.15+) | GPU passthrough requires Linux; macOS CPU-only only |

### Network

| Requirement | Details |
|---|---|
| Internet at setup | Required for image pull, SAPIEN assets, and pre-trained policy checkpoints (~5–15 GB) |
| Internet at demo runtime | Not required |
| Offline capable | Yes, after initial asset download |

### Ports

| Port | Service |
|---|---|
| 8080 | Simulation web viewer |
| 7860 | Gradio instruction interface |
