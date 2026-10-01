# Handoff: demo-designer — T2

## Header

| Field | Value |
|---|---|
| Handoff file | `agents/handoffs/handoff_demo-designer_20261001_002.md` |
| Role | `demo-designer` |
| Issue | `#2` |
| Branch | `feat/issue-2-private-rag` |
| Follows | _(none)_ |
| Status | `pending` |
| Requested | `2026-10-01T00:00Z` |
| Completed | _(filled by session)_ |

## Assigned To

- **Role**: `demo-designer`
- **Execution context**: `local`
- **OS**: any
- **Session**: _(filled by operator when activating)_

## Context

This task is part of the work for Issue #2: feat: implement private-rag — Enterprise Knowledge Assistant.

The demo-designer produces the `demo.yaml` manifest, the synthetic fixture documents that the demo will ingest, and the architecture documentation outline. These artifacts feed downstream roles: script-engineer (T3) needs the fixture file names and content to write deterministic assertions; documentation-writer (T4) needs the architecture outline.

## Prerequisites

Before executing:
- [ ] Read `agents/logbooks/logbook_demo-designer.md` if it exists
- [ ] Verify you are on branch `feat/issue-2-private-rag`
- [ ] Read `schemas/demo.schema.json` — demo.yaml must be valid against it
- [ ] Read `demos/hello-compose/demo.yaml` as a reference example
- [ ] Check all existing `demos/*/demo.yaml` files for port conflicts
- [ ] Pull latest `feat/issue-2-private-rag` from origin

## Task Instructions

### Part A — Port conflict check

1. Read all `demos/*/demo.yaml` files. List their `spec.ports` arrays. The private-rag demo will use ports `3000`, `11434`, `6333`, `6334`. Confirm none of these conflict with another demo's ports. If there is a conflict, document it in the result file and flag for Supervisor.

### Part B — Create `demos/private-rag/demo.yaml`

2. Create `demos/private-rag/demo.yaml` with the following content (adjust if port conflict found):

```yaml
apiVersion: ape.demo/v1
kind: Demo
metadata:
  name: private-rag
  title: Private RAG — Enterprise Knowledge Assistant
spec:
  category: retrieval-augmented-generation
  lifecycle: experimental
  maturity: alpha
  entrypoints:
    start: ./demo.sh start
    run: ./demo.sh run
    test: ./test.sh
    reset: ./reset.sh
  security:
    privilegedContainers: false
    defaultCredentialsAllowed: false
    secretsFromEnvironment: true
  requirements:
    docker: ">= 27"
    compose: ">= 2.30"
    memoryGB: 12
    diskGB: 40
    gpuRequired: false
  ports:
    - 3000
    - 11434
    - 6333
    - 6334
  validation:
    composeConfig: true
    healthChecks: true
    smokeTest: true
```

3. Validate `demo.yaml` against `schemas/demo.schema.json` using `check-jsonschema --schemafile schemas/demo.schema.json demos/private-rag/demo.yaml`. If `check-jsonschema` is not available, validate manually by checking every required field against the schema.

### Part C — Create fixture documents

4. Create directory `demos/private-rag/fixtures/`.

5. Create `demos/private-rag/fixtures/document-retention-policy.md` — a synthetic Markdown document about corporate document retention policy. It MUST contain:
   - A section titled "Financial Records Retention" with the exact sentence: "Financial records must be retained for a minimum of **7 years** in accordance with regulatory requirements."
   - A section titled "Employee Records Retention" with a stated retention period.
   - A section titled "Email and Electronic Communications" with a stated retention period.
   - Total length: 300–600 words. No real company name — use "Acme Corp" as placeholder.
   - The content must be specific enough that a RAG query "What is the document retention policy for financial records?" returns the 7-year answer.

6. Create `demos/private-rag/fixtures/it-security-policy.md` — a synthetic Markdown document about IT security policy. It MUST contain:
   - A section titled "Password Policy" with the exact sentence: "All user passwords must be at least **12 characters** and changed every **90 days**."
   - A section titled "Acceptable Use Policy" with clear rules.
   - A section titled "Data Classification" with at least three classification levels.
   - Total length: 300–600 words. Same "Acme Corp" placeholder.
   
   Note: The issue acceptance criteria require one PDF and one Markdown fixture. For the PDF, use the `it-security-policy.md` content — the script-engineer will convert it to PDF programmatically using a tool available in the demo environment (e.g. `pandoc` or Python's `fpdf2`). Document this conversion requirement in the result file for the script-engineer (T3).
   
   Alternative: create a minimal valid synthetic PDF directly using Python's `fpdf2` library with the it-security-policy content. If you can generate a valid PDF as a fixture file `demos/private-rag/fixtures/it-security-policy.pdf`, do so. Otherwise create only the Markdown file and note in the result that T3 must generate the PDF.

### Part D — Create architecture outline

7. Create `demos/private-rag/docs/` directory and write `demos/private-rag/docs/architecture.md` as an outline with these sections (brief bullet points only — the documentation-writer will expand them):
   - Overview
   - Component diagram (text description: Open WebUI → Qdrant for vectors, Open WebUI → Ollama for inference)
   - Data flow (document upload → chunking → embedding → vector store; query → retrieval → generation)
   - Deployment modes (CPU / RTX 5060 Ti / RTX 3090 / API)
   - Networking

### Part E — Commit

8. Stage and commit on branch `feat/issue-2-private-rag`:
   - `demos/private-rag/demo.yaml`
   - `demos/private-rag/fixtures/document-retention-policy.md`
   - `demos/private-rag/fixtures/it-security-policy.md` (and PDF if generated)
   - `demos/private-rag/docs/architecture.md`
   
   Commit message: `feat(private-rag): demo manifest, fixtures, architecture outline`

9. Append entry to `agents/logbooks/logbook_demo-designer.md` and commit: `chore(demo-designer): logbook update — private-rag T2`

## Expected Outputs

| Path | Description |
|---|---|
| `demos/private-rag/demo.yaml` | Schema-validated demo manifest |
| `demos/private-rag/fixtures/document-retention-policy.md` | Synthetic policy doc — RAG test anchor |
| `demos/private-rag/fixtures/it-security-policy.md` | Synthetic IT policy doc |
| `demos/private-rag/fixtures/it-security-policy.pdf` | PDF version (create if feasible; else note for T3) |
| `demos/private-rag/docs/architecture.md` | Architecture outline for docs-writer |
| `agents/logbooks/logbook_demo-designer.md` | Updated logbook entry (required) |
| `agents/handoffs/handoff_demo-designer_20261001_002.result.md` | Result file (required) |

## Success Criteria

The task is complete when ALL of these are true:

- [ ] `demo.yaml` validates against `schemas/demo.schema.json` without errors
- [ ] No port conflicts with existing demos
- [ ] `fixtures/document-retention-policy.md` contains "7 years" in the financial records section
- [ ] At least one fixture is a PDF or a note for T3 to generate it
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
