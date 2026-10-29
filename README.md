# GenAI Solutions Portfolio

A curated library of self-contained, reproducible Generative AI demonstrations built on Docker Compose. Each demo runs entirely on-premise — no cloud account required — and follows a strict contract: versioned images, health checks, documented credentials, automated smoke tests, and a reset path.

The repository is designed to be operated by a team of specialised AI agents (composer, designer, security reviewer, documentation writer …) coordinated by a Supervisor, working through GitHub Issues and Pull Requests under human oversight.

## Demo catalog

### Ready to use

| Demo | Capability | GPU |
|---|---|---|
| [hello-compose](demos/hello-compose/) | Repository contract reference demo (nginx) | No |

### In development

| Demo | Capability | GPU |
|---|---|---|
| [private-rag](demos/private-rag/) | Enterprise Knowledge Assistant — upload internal documents, query them via chat; all inference runs locally (Open WebUI + Ollama + Qdrant) | No |

### Candidates (planned)

| Tier | Demo | Capability | GPU |
|---|---|---|---|
| 1 | talk-to-data | Natural language → SQL + visualisation | No |
| 1 | speech-intelligence | Transcription, language detection, action items | No |
| 1 | supply-chain-agent | Multi-agent supply chain finance analysis | No |
| 2 | visual-inspection | Computer vision quality audit | Optional |
| 2 | agentic-dev | Agentic software engineering lifecycle | No |
| 2 | context-fabric | Industrial operational context fabric | No |
| 3 | embodied-ai | Robot manipulation simulation | Yes |
| 3 | content-creator | Script → storyboard → short video | Optional |
| 3 | virtual-human | 3D conversational avatar | Optional |
| 4 | drug-discovery | Molecular property prediction, QSAR | Optional |
| 4 | software-modernisation | Legacy codebase assessment and refactoring | No |
| 4 | video-intelligence | Video Q&A, chapter generation, semantic search | Optional |
| 4 | agents-4-everything | Multi-agent collaboration showcase | No |
| 4 | finance-agent | Financial research assistant on public data | No |

Tier reflects implementation complexity. See [`catalog/`](catalog/) for per-demo descriptions, prerequisites, and provenance.

## Quick start

```bash
# Run the reference demo
cp demos/hello-compose/.env.example demos/hello-compose/.env
make validate
make smoke DEMO=hello-compose
```

```bash
# Run the private-rag demo (requires Docker, 12 GB RAM, 20 GB disk)
cd demos/private-rag
cp .env.example .env          # set WEBUI_SECRET_KEY
./demo.sh check               # verify prerequisites
./demo.sh start               # pull images and models (~5 min first run)
./demo.sh run                 # execute demo scenario
```

## Repository structure

```
demos/          one directory per demo; each satisfies the demo contract
catalog/        lifecycle tracking: candidate → develop → ready-to-use
agents/         agent role definitions, handoff templates, logbooks
scripts/        repository tooling (create-demo, check-links, …)
templates/      shared shell libraries (logging, wait-for-service)
policies/       governance rules (issue management, security, …)
```

## Adding a new demo

```bash
./scripts/create-demo.sh my-demo
```

Complete `demos/my-demo/demo.yaml`, implement the stack, add tests, write documentation. Open a `demo:new` GitHub Issue to register work — see [`CONTRIBUTING.md`](CONTRIBUTING.md).

## Governance

- All work starts from a typed GitHub Issue.
- Changes arrive through Pull Requests; CI runs contract, security, and smoke checks.
- Human review is mandatory before merge; agents cannot approve their own PRs.
- `AGENTS.md` is the canonical operating contract for human contributors and AI agents.
