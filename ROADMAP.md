# Roadmap

## Now — Repository foundation

- [x] Repository scaffold and governance documents
- [x] `hello-compose` contract demo
- [x] Schema validation and CI pipeline
- [ ] Agent specification files (`agents/`)
- [ ] Extended policy set (`policies/`)
- [ ] Common template helpers (`templates/common/`)
- [ ] Additional validation scripts

## Next — First GenAI demos

- [ ] `private-rag` — Private and Sovereign RAG with local LLM and vector store
- [ ] `sovereign-ai` — Air-gapped model serving without external API calls
- [ ] `devsecops` — DevSecOps pipeline with container scanning and SBOM
- [ ] `sovereign-storage` — Encrypted object storage for AI artefacts

## Later — Platform maturity

- [ ] Scheduled maintenance workflow (stale demo detection)
- [ ] Dependency review workflow on every PR
- [ ] SBOM generation and release signing
- [ ] Compatibility matrix automation
- [ ] `CHANGELOG.md` automation on release

## Principles

- Each item starts from a typed GitHub Issue with acceptance criteria.
- Agents propose via PR; humans approve.
- No item moves to _Now_ without a linked Issue.
