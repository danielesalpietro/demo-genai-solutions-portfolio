# Release Notes — hello-compose

## Current status: ready-to-use · v0.1.0

---

## v0.1.0 — 2026-10-01

### Changes
- Initial implementation satisfying the full demo contract
- nginx 1.27.5-alpine with hardened Compose configuration
- Healthcheck on `/health`; port configurable via `DEMO_PORT` (default 18080)
- `demo.sh` implements all required subcommands
- `demo.yaml` includes `requirements`, `ports`, and `validation` sections

### Known limitations
- Static HTML only; no AI component
- Not representative of GenAI capabilities

---

## Prerequisites

### Hardware

| Component | Minimum | Recommended |
|---|---|---|
| CPU | Any x86_64 or arm64 | Any modern CPU |
| RAM | 64 MB | 256 MB |
| Disk | 100 MB (image + files) | 200 MB |
| GPU | Not required | Not required |

### Software

| Requirement | Minimum version |
|---|---|
| Docker Engine | 24.0 |
| Docker Compose | 2.20 |
| OS | Linux, macOS, Windows (WSL2) |

### Network

| Requirement | Details |
|---|---|
| Internet at setup | Required once to pull `nginx:1.27.5-alpine` (~40 MB) |
| Internet at demo runtime | Not required |
| Offline capable | Yes, after initial image pull |

### Ports

| Port | Service |
|---|---|
| 18080 (configurable) | nginx HTTP |
