# Demo Catalog

This catalog tracks every demo across its lifecycle.

| State | Meaning |
|---|---|
| `candidate` | Upstream repository identified; feasibility confirmed; not yet in development |
| `develop` | Active development branch open; demo contract partially implemented |
| `ready-to-use` | Demo contract satisfied; smoke tests pass; documentation complete |

## Index

### Ready to use

| Demo | Description |
|---|---|
| [hello-compose](ready-to-use/hello-compose/) | Repository contract reference demo (nginx) |

### In development

_None yet. See `develop/README.md`._

### Candidates

| Demo | Capability | Tier | GPU required |
|---|---|---|---|
| [private-rag](candidate/private-rag/) | Enterprise Knowledge Assistant (RAG) | 1 | No |
| [talk-to-data](candidate/talk-to-data/) | Natural language → SQL + visualisation | 1 | No |
| [speech-intelligence](candidate/speech-intelligence/) | Transcription, language detection, action items | 1 | No |
| [supply-chain-agent](candidate/supply-chain-agent/) | Multi-agent supply chain finance analysis | 1 | No |
| [visual-inspection](candidate/visual-inspection/) | Computer vision quality audit | 2 | Optional |
| [agentic-dev](candidate/agentic-dev/) | Agentic software engineering lifecycle | 2 | No |
| [context-fabric](candidate/context-fabric/) | Industrial operational context fabric | 2 | No |
| [embodied-ai](candidate/embodied-ai/) | Robot manipulation simulation | 3 | Yes |
| [content-creator](candidate/content-creator/) | Script → storyboard → short video | 3 | Optional |
| [virtual-human](candidate/virtual-human/) | 3D conversational avatar | 3 | Optional |
| [drug-discovery](candidate/drug-discovery/) | Molecular property prediction, QSAR | 4 | Optional |
| [software-modernisation](candidate/software-modernisation/) | Legacy codebase assessment and refactoring | 4 | No |
| [video-intelligence](candidate/video-intelligence/) | Video Q&A, chapter generation, semantic search | 4 | Optional |
| [agents-4-everything](candidate/agents-4-everything/) | Multi-agent collaboration showcase | 4 | No |
| [finance-agent](candidate/finance-agent/) | Financial research assistant on public data | 4 | No |

## Lifecycle transitions

To promote a demo:

- `candidate → develop`: open a GitHub Issue (`demo:new`), confirm acceptance criteria, create branch
- `develop → ready-to-use`: `make validate` + `make smoke` pass; PR merged; documentation complete
- `ready-to-use → deprecated`: Maintenance Agent Issue + human decision; 60-day notice period
