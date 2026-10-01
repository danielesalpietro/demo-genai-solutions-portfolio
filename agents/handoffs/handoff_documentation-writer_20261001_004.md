# Handoff: documentation-writer — T4

## Header

| Field | Value |
|---|---|
| Handoff file | `agents/handoffs/handoff_documentation-writer_20261001_004.md` |
| Role | `documentation-writer` |
| Issue | `#2` |
| Branch | `feat/issue-2-private-rag` |
| Follows | _(none — depends on T3 being complete)_ |
| Status | `pending` |
| Requested | `2026-10-01T00:00Z` |
| Completed | _(filled by session)_ |

## Assigned To

- **Role**: `documentation-writer`
- **Execution context**: `local`
- **OS**: any
- **Session**: _(filled by operator when activating)_

## Context

This task is part of the work for Issue #2: feat: implement private-rag — Enterprise Knowledge Assistant.

The documentation-writer creates `demos/private-rag/README.md` with all 9 required sections per the documentation-writer spec. The scripts (T3) and architecture outline (T2) are already in place; expand the architecture outline at `demos/private-rag/docs/architecture.md` into a full technical document.

**Prerequisites already delivered (verify before starting)**:
- T1: `demos/private-rag/compose.yaml`, `.env.example`
- T2: `demos/private-rag/demo.yaml`, `fixtures/`, `docs/architecture.md` (outline)
- T3: `demos/private-rag/demo.sh`, `test.sh`, `reset.sh`

## Prerequisites

Before executing:
- [ ] Read `agents/logbooks/logbook_docs-writer.md` if it exists
- [ ] Verify you are on branch `feat/issue-2-private-rag` and have pulled latest
- [ ] Verify T3 result file shows `status: completed`
- [ ] Read `demos/private-rag/compose.yaml` — note image names, ports, volumes
- [ ] Read `demos/private-rag/demo.sh` — note exact commands, expected output patterns
- [ ] Read `demos/private-rag/docs/architecture.md` — the outline to expand
- [ ] Read `agents/documentation-writer.md` — the 9 required sections

## Task Instructions

### Part A — `demos/private-rag/README.md`

Write `demos/private-rag/README.md` with exactly these 9 sections in order:

1. **Overview** — one paragraph: enterprise users upload internal documents (PDF, DOCX, Markdown) and query them through a chat interface. All inference, vector indexing, and retrieval run locally. No data leaves the machine. Target: regulated-industry teams.

2. **Architecture** — table of services and ports, brief data flow description:
   - Services: Open WebUI (port 3000), Ollama (port 11434), Qdrant (ports 6333/6334)
   - Data flow: upload → chunking → nomic-embed-text embedding → Qdrant; query → embedding → vector search → Qdrant → Mistral inference via Ollama → cited answer
   - Link to `docs/architecture.md` for technical detail

3. **Prerequisites** — exact versions:
   - Docker Engine ≥ 27.0
   - Docker Compose ≥ 2.30
   - RAM: 12 GB minimum, 16 GB recommended
   - Disk: 20 GB minimum, 40 GB recommended
   - GPU: not required (CPU path); NVIDIA 8 GB+ VRAM for GPU acceleration
   - NVIDIA Container Toolkit ≥ 1.14 (GPU path only)

4. **Quick start** — copy-pasteable shell commands:
   ```bash
   git clone https://github.com/DanieleS/demo-genai-solutions-portfolio
   cd demo-genai-solutions-portfolio/demos/private-rag
   cp .env.example .env
   # Edit .env: set WEBUI_SECRET_KEY to a random 32-char string
   ./demo.sh check
   ./demo.sh start
   # Open http://localhost:3000 — first-run admin setup is automated by demo.sh start
   ./demo.sh run
   ```

5. **Demo scenario** — narrative walkthrough mirroring Issue #2 steps 1–8. Include the exact `[RAG ANSWER]` block format as expected output from `demo.sh run`. The expected output MUST match what `demo.sh run` actually prints (read the script to confirm the format).

6. **Operations** — reference table:
   | Command | Effect |
   |---|---|
   | `./demo.sh check` | Verify prerequisites |
   | `./demo.sh start` | Start services, pull models |
   | `./demo.sh run` | Execute demo scenario |
   | `./demo.sh status` | Show service health |
   | `./demo.sh stop` | Stop services (volumes preserved) |
   | `./demo.sh reset` | Stop and remove everything |

7. **Troubleshooting** — at minimum these scenarios:
   - Port already in use (how to check and free ports 3000, 11434, 6333, 6334)
   - Ollama model pull fails (network timeout, how to retry)
   - Open WebUI shows "Connection refused" (services not healthy yet, wait and check status)
   - `demo.sh run` assertion fails (RAG answer did not contain "7 years" — check document was uploaded)
   - Low RAM: `mistral:7b-instruct-q4_K_M` requires ~8 GB RAM; close other applications

8. **Cleanup** — how to remove all artifacts:
   ```bash
   ./demo.sh reset    # stops services, removes volumes
   docker image rm ...  # list the images from compose.yaml if desired
   ```

9. **Security notes** — what credentials are used:
   - `WEBUI_SECRET_KEY`: JWT signing key for Open WebUI sessions. Set in `.env`. Never commit `.env`.
   - `QDRANT__SERVICE__API_KEY`: optional API key for Qdrant. Left blank in demo mode.
   - `WEBUI_ADMIN_PASSWORD`: admin account password. Default `DemoAdmin123!` in demo mode — change for any non-demo use.
   - All credentials managed via `.env`; `.env` is in `.gitignore`.
   - To rotate: `./demo.sh reset`, update `.env`, `./demo.sh start`.

### Part B — Expand `demos/private-rag/docs/architecture.md`

Expand the outline created by T2 into a full technical document covering:
- Component diagram (ASCII or text)
- Data flow for document ingestion and query
- Deployment modes (CPU, RTX 5060 Ti 16 GB, RTX 3090 24 GB, API backend)
- Network topology (internal `rag-net`, external port exposure)
- Volume layout (`ollama-data`, `qdrant-data`, `open-webui-data`)

### Part C — Commit

Stage and commit on branch `feat/issue-2-private-rag`:
- `demos/private-rag/README.md`
- `demos/private-rag/docs/architecture.md`

Commit message: `docs(private-rag): README with all 9 sections, architecture doc`

Append entry to `agents/logbooks/logbook_docs-writer.md` and commit: `chore(docs-writer): logbook update — private-rag T4`

## Expected Outputs

| Path | Description |
|---|---|
| `demos/private-rag/README.md` | Full README with all 9 required sections |
| `demos/private-rag/docs/architecture.md` | Expanded technical architecture doc |
| `agents/logbooks/logbook_docs-writer.md` | Updated logbook entry (required) |
| `agents/handoffs/handoff_documentation-writer_20261001_004.result.md` | Result file (required) |

## Success Criteria

The task is complete when ALL of these are true:

- [ ] README has all 9 sections in order
- [ ] Quick start commands are copy-pasteable and correct
- [ ] Expected output in "Demo scenario" section matches `demo.sh run` actual output format
- [ ] No broken links (verify with `scripts/check-links.sh` if available)
- [ ] No hardcoded credentials or real email addresses
- [ ] Logbook entry written and committed
- [ ] Result file written with `status: completed`

## Credentials / Access

| What | Source | Operator-provided value |
|---|---|---|
| None required | — | — |

## Result

| Field | Value |
|---|---|
| Status | `pending` |
| Completed | _(filled by session)_ |
| Exit code | _(0 = success)_ |
| Session | _(filled by operator)_ |

### Summary

_(filled by session)_

### Artifacts produced

_(filled by session)_

### Issues encountered

_(filled by session)_

### Supervisor action needed

- [ ] None — task complete as specified
- [ ] Follow-up handoff needed: _(description)_
- [ ] Escalate to human: _(reason)_
