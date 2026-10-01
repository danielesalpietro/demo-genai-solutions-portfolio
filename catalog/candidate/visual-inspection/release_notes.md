# Release Notes — visual-inspection

## Current status: candidate · v0.1.0-candidate

---

## v0.1.0-candidate — 2026-10-01

### Changes
- Initial candidate entry; two implementation options documented (VIO and visual_inspection)
- Anomalib selected as anomaly detection backend (Apache-2.0)
- No implementation yet

### Open items
- [ ] Verify current maintenance status and license of VIO (octo-technology/VIO)
- [ ] Choose between Option A (VIO) and Option B (visual_inspection) for initial demo
- [ ] Source or generate sample image fixture set (synthetic defects; no proprietary imagery)
- [ ] Confirm model: PaDiM (CPU-friendly) vs EfficientAD (faster GPU inference)

---

## Prerequisites

### Hardware

#### CPU-only — rapid demo (Option B: visual_inspection)

| Component | Minimum | Recommended |
|---|---|---|
| CPU | x86_64 with SSE4.2 | x86_64, 4+ cores, AVX2 |
| RAM | 4 GB | 8 GB |
| Disk | 5 GB | 8 GB |
| GPU | Not required | Not required |

> **Model:** PaDiM (MVTec AD) — CPU inference is viable at standard demo resolution (224×224).  
> Expected inference latency on 4-core CPU: ~200 ms/image.

#### GPU-accelerated configuration

| Component | Minimum | Recommended |
|---|---|---|
| GPU VRAM | 4 GB | 8 GB+ |
| GPU (NVIDIA) | GTX 1060 6 GB · MX450 | RTX 3060 12 GB · RTX 4070 · T4 |
| RAM | 8 GB | 16 GB |

> **Model for GPU:** EfficientAD or PatchCore — inference at ~20–50 ms/image on RTX 3060.

**GPU note:** OpenVINO CPU fallback allows inference without CUDA; recommended for convention-floor demos where GPU availability is uncertain.

#### Enterprise edge deployment (Option A: VIO)

| Component | Minimum | Recommended |
|---|---|---|
| CPU | x86_64, 4+ cores | x86_64, 8+ cores |
| RAM | 8 GB | 16 GB |
| Disk | 15 GB | 30 GB |
| GPU | Not required (OpenVINO CPU) | NVIDIA T4 / RTX 4070 for multi-camera |

### Software

| Requirement | Minimum version |
|---|---|
| Docker Engine | 27.0 |
| Docker Compose | 2.20 |
| NVIDIA Container Toolkit | 1.14 (if GPU) |
| OS | Linux preferred; macOS supported for CPU-only |

### Network

| Requirement | Details |
|---|---|
| Internet at setup | Required for image pull and pre-trained model checkpoint download (~1–3 GB) |
| Internet at demo runtime | Not required |
| Webcam | Optional; demo functions with static sample images |
| Offline capable | Yes, after initial setup |

### Ports

| Port | Service |
|---|---|
| 7860 | Gradio UI |
| 8080 | VIO hub dashboard (Option A only) |
