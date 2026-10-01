# Private RAG — Enterprise Knowledge Assistant

> **Note**: Full documentation will be written by the documentation-writer (T4). This is a placeholder to satisfy demo contract requirements.

## Quick Start

```bash
cp .env.example .env          # copy and edit as needed
./demo.sh check               # verify prerequisites
./demo.sh start               # start services and pull models (~5 min first run)
./demo.sh run                 # execute demo scenario
./demo.sh stop                # stop services (volumes preserved)
./demo.sh reset               # remove everything
```

## Requirements

- Docker >= 27
- Docker Compose >= 2.30
- 12 GB RAM
- 40 GB disk (model downloads)
- GPU optional (set `GPU_TIER` in `.env`: `cpu` | `rtx5060ti` | `rtx3090`)

## Ports

| Port | Service |
|------|---------|
| 3000 | Open WebUI |
| 11434 | Ollama |
| 6333 | Qdrant REST |
| 6334 | Qdrant gRPC |

## Architecture

See [`docs/architecture.md`](docs/architecture.md) for component diagram and data flow.
