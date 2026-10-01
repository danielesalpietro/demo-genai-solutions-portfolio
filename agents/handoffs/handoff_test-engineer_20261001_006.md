# Handoff: test-engineer — T6

## Header

| Field | Value |
|---|---|
| Handoff file | `agents/handoffs/handoff_test-engineer_20261001_006.md` |
| Role | `test-engineer` |
| Issue | `#2` |
| Branch | `feat/issue-2-private-rag` |
| Follows | _(depends on T3, T4, T5 all complete with no HOLD)_ |
| Status | `pending` |
| Requested | `2026-10-01T00:00Z` |
| Completed | _(filled by session)_ |

## Assigned To

- **Role**: `test-engineer`
- **Execution context**: `local`
- **OS**: Linux / WSL2 with Docker
- **Session**: _(filled by operator when activating)_

## Context

This task is part of the work for Issue #2: feat: implement private-rag — Enterprise Knowledge Assistant.

The test-engineer is the final gate check before the Supervisor opens the Pull Request. It verifies that all acceptance criteria are satisfied and that CI gates would pass.

**Do NOT start this task if T5 (security-reviewer) returned HOLD.**

**Prerequisites already delivered (verify before starting)**:
- T1: compose.yaml, .env.example, vllm image pinned
- T2: demo.yaml, fixtures, docs/architecture.md
- T3: demo.sh, test.sh, reset.sh
- T4: README.md
- T5: security-reviewer result file with `RECOMMENDATION: GO`

## Prerequisites

Before executing:
- [ ] Read `agents/logbooks/logbook_test-engineer.md` if it exists
- [ ] Verify you are on branch `feat/issue-2-private-rag` and have pulled latest
- [ ] Verify result files for T1, T2, T3, T4 all show `status: completed`
- [ ] Verify T5 result file shows `status: completed` and `RECOMMENDATION: GO`
- [ ] Ensure Docker daemon is running
- [ ] Ensure `make` is available

## Task Instructions

### Part A — Static checks

1. Run YAML lint on all YAML files in `demos/private-rag/`:
   ```bash
   yamllint demos/private-rag/compose.yaml demos/private-rag/demo.yaml
   ```
   Fix any lint errors (minor formatting is acceptable; structural errors are not).

2. Run shellcheck on all scripts:
   ```bash
   shellcheck demos/private-rag/demo.sh demos/private-rag/test.sh demos/private-rag/reset.sh
   ```

3. Validate `demo.yaml` against the schema:
   ```bash
   check-jsonschema --schemafile schemas/demo.schema.json demos/private-rag/demo.yaml
   ```

4. Validate compose config:
   ```bash
   docker compose -f demos/private-rag/compose.yaml config --quiet
   docker compose -f demos/private-rag/compose.yaml -f packages/private-rag/docker-compose.cloud.yaml config --quiet
   ```

5. Check no `:latest` tag in any committed file:
   ```bash
   grep -rn ":latest" demos/private-rag/ packages/private-rag/
   ```
   Must return no results.

### Part B — Contract tests

6. Run `demos/private-rag/test.sh`:
   ```bash
   bash demos/private-rag/test.sh
   ```
   Must exit 0.

7. Verify all required demo contract files exist and are correctly typed:
   - `demos/private-rag/README.md` — regular file, non-empty
   - `demos/private-rag/compose.yaml` — regular file, non-empty
   - `demos/private-rag/.env.example` — regular file, non-empty
   - `demos/private-rag/demo.yaml` — regular file, non-empty
   - `demos/private-rag/demo.sh` — executable
   - `demos/private-rag/test.sh` — executable
   - `demos/private-rag/reset.sh` — executable
   - `demos/private-rag/fixtures/` — directory with ≥ 2 files

### Part C — `make validate`

8. Run:
   ```bash
   make validate
   ```
   Must exit 0. If it fails, diagnose the failure, create a follow-up handoff for the appropriate role, and do NOT proceed to Part D.

### Part D — Smoke test (requires Docker and network access for image pull)

9. Copy `.env.example` to `.env` in `demos/private-rag/` and set a test `WEBUI_SECRET_KEY`:
   ```bash
   cp demos/private-rag/.env.example demos/private-rag/.env
   echo "WEBUI_SECRET_KEY=TestSecret32CharactersLongXXXXXX" >> demos/private-rag/.env
   ```

10. Run the full smoke sequence:
    ```bash
    demos/private-rag/demo.sh check    # must exit 0
    demos/private-rag/demo.sh start    # must exit 0; services healthy within 5 minutes
    demos/private-rag/demo.sh run      # must exit 0; [RAG ANSWER] printed; "7 years" assertion passes
    demos/private-rag/demo.sh reset    # must exit 0
    demos/private-rag/demo.sh reset    # must exit 0 (idempotency check)
    ```

11. Remove the test `.env`:
    ```bash
    rm demos/private-rag/.env
    ```

12. Alternatively, run via make:
    ```bash
    make smoke DEMO=private-rag
    ```

### Part E — Cloud test gate (conditional)

13. If the RTX 5060 Ti or RTX 3090 GPU runner is available:
    ```bash
    make cloud-test DEMO=private-rag PLATFORM=runpod GPU=rtx5060ti
    ```
    If the GPU runner is not available in this session, document this in the result file. The Supervisor will request a separate remote session for this gate.

### Part F — Acceptance criteria checklist

14. Go through every acceptance criterion from Issue #2 and mark each one as PASS or FAIL with evidence:

**Demo contract**:
- [ ] compose.yaml — images pinned, health checks, no latest tags
- [ ] .env.example — all variables present with placeholders
- [ ] demo.yaml — valid against schema, status experimental
- [ ] demo.sh — implements all 6 commands
- [ ] test.sh — exits 0 on clean environment
- [ ] reset.sh — idempotent
- [ ] README.md — 9 required sections present

**Functional**:
- [ ] start pulls models and reaches healthy state
- [ ] run uploads fixture and issues RAG query with cited answer
- [ ] reset removes volumes and is idempotent

**Fixtures**:
- [ ] ≥ 2 synthetic documents (PDF + Markdown)

**Cloud package**:
- [ ] setup.sh supports INFERENCE_BACKEND=ollama|vllm|api
- [ ] docker-compose.cloud.yaml includes vllm profile
- [ ] make cloud-test result (pass / deferred to remote session)

**CI**:
- [ ] make validate exits 0
- [ ] make smoke DEMO=private-rag exits 0
- [ ] CVE findings: documented (from T5)
- [ ] Gitleaks: clean (from T5)

### Part G — Commit and logbook

15. Commit `.env.example` changes if any (do NOT commit `.env`).

16. Append entry to `agents/logbooks/logbook_test-engineer.md` and commit: `chore(test-engineer): logbook update — private-rag T6`

## Expected Outputs

| Path | Description |
|---|---|
| `agents/logbooks/logbook_test-engineer.md` | Updated logbook entry (required) |
| `agents/handoffs/handoff_test-engineer_20261001_006.result.md` | Gate report with full AC checklist (required) |

## Success Criteria

The task is complete when ALL of these are true:

- [ ] `make validate` exits 0
- [ ] `make smoke DEMO=private-rag` exits 0 OR documented failure with follow-up handoff created
- [ ] All static checks pass (yamllint, shellcheck, check-jsonschema, compose config)
- [ ] All contract test file existence checks pass
- [ ] Full AC checklist documented in result file
- [ ] Logbook entry written and committed
- [ ] Result file written with `status: completed`

## Credentials / Access

| What | Source | Operator-provided value |
|---|---|---|
| Docker Hub (for image pull) | host network | _(may require login if rate-limited)_ |
| RunPod API key (cloud-test only) | `RUNPOD_API_KEY` env var | _(operator sets if needed)_ |

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

- [ ] None — all gates pass, Supervisor may open PR
- [ ] Follow-up handoff needed: _(description)_
- [ ] Escalate to human: _(reason — e.g. smoke test failure, cloud-test deferred)_
