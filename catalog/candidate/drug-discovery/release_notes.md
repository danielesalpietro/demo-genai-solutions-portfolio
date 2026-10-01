# Release Notes — drug-discovery

## Current status: candidate · v0.1.0-candidate

---

## v0.1.0-candidate — 2026-10-01

### Changes
- Initial candidate entry; DeepChem and AI-drug-discovery repositories identified
- MIT license compatibility confirmed for DeepChem
- No implementation yet

### Open items
- [ ] Verify license of AI-drug-discovery (mayk-it/AI-drug-discovery)
- [ ] Define SMILES fixture set (synthetic or publicly licensed compound library)
- [ ] Decide between Jupyter notebook UI and Gradio interface for demo delivery
- [ ] Assess GPU necessity: GNN inference is feasible on CPU for demo-scale datasets

---

## Prerequisites

### Hardware

#### CPU-only configuration (recommended for demo-scale datasets)

| Component | Minimum | Recommended |
|---|---|---|
| CPU | x86_64 with AVX2 | x86_64, 8+ cores, AVX2 |
| RAM | 8 GB | 16 GB |
| Disk | 10 GB | 20 GB |
| GPU | Not required (demo scale) | Not required |

> **Dataset size:** 100–1000 molecules; CPU inference with pre-trained models completes in seconds.  
> RDKit fingerprint computation: negligible time on CPU.  
> DeepChem GNN inference (100 molecules): ~1–5 seconds on a 4-core CPU.

#### GPU-accelerated configuration (large-scale screening)

| Component | Minimum | Recommended |
|---|---|---|
| GPU VRAM | 6 GB | 12 GB+ |
| GPU (NVIDIA) | RTX 3060 · T4 | RTX 4080 · A10 |
| RAM | 16 GB | 32 GB |
| Disk | 20 GB | 40 GB |

> GPU is relevant for training new models or screening 100 000+ compounds; not required for a demo scenario with pre-trained models.

### Software

| Requirement | Minimum version |
|---|---|
| Docker Engine | 27.0 |
| Docker Compose | 2.20 |
| OS | Linux; macOS (CPU-only) |

### Network

| Requirement | Details |
|---|---|
| Internet at setup | Required for image pull and pre-trained model download (~3–5 GB) |
| Internet at demo runtime | Not required |
| Offline capable | Yes, after initial setup |

### Ports

| Port | Service |
|---|---|
| 8888 | Jupyter Lab |
| 7860 | Gradio UI (alternative) |
