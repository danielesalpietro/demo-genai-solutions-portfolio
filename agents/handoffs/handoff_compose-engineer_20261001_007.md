# Handoff: compose-engineer — T1b (follow-up)

## Header

| Field | Value |
|---|---|
| Handoff file | `agents/handoffs/handoff_compose-engineer_20261001_007.md` |
| Role | `compose-engineer` |
| Issue | `#2` |
| Branch | `feat/issue-2-private-rag` |
| Follows | `handoff_compose-engineer_20261001_001.md` |
| Status | `pending` |
| Requested | `2026-10-01T00:00Z` |
| Completed | _(filled by session)_ |

## Assigned To

- **Role**: `compose-engineer`
- **Execution context**: `local`
- **OS**: any
- **Session**: _(filled by operator when activating)_

## Context

Follow-up to T1. During Supervisor verification of T1's output, one finding was identified that blocks T3 (script-engineer):

**Finding**: `demos/private-rag/compose.yaml` defines `rag-net` with `internal: true`. This prevents all containers on that network from reaching the internet. However, the Issue requires `demo.sh start` to pull Ollama models (`nomic-embed-text`, `mistral:7b-instruct-q4_K_M` etc.) from ollama.com at first startup. With `internal: true`, `docker exec ollama ollama pull <model>` will fail with a network error — Ollama cannot reach its registry.

**Fix**: Remove `internal: true` from the `rag-net` network definition. The network remains a private bridge (containers cannot be reached from the host except through explicitly published ports); removing `internal` simply allows containers to initiate outbound connections.

This is a one-line fix.

## Prerequisites

Before executing:
- [ ] Verify you are on branch `feat/issue-2-private-rag` and have pulled latest
- [ ] Verify T1 result file (`handoff_compose-engineer_20261001_001.result.md`) shows `status: completed`

## Task Instructions

1. Open `demos/private-rag/compose.yaml`.

2. Find the `networks` section at the bottom:
   ```yaml
   networks:
     rag-net:
       driver: bridge
       internal: true
   ```

3. Remove the `internal: true` line. Result:
   ```yaml
   networks:
     rag-net:
       driver: bridge
   ```

4. Verify no `:latest` tag was accidentally reintroduced:
   ```bash
   grep -n "latest" demos/private-rag/compose.yaml
   ```
   Must return no results.

5. (Optional but preferred) Validate:
   ```bash
   docker compose -f demos/private-rag/compose.yaml config --quiet
   ```

6. Commit on branch `feat/issue-2-private-rag`:
   ```
   fix(private-rag): remove internal:true from rag-net to allow model pull
   ```

7. Append a short note to `agents/logbooks/logbook_compose-engineer.md`:
   ```
   ## T1b — 2026-10-01 — fix: remove internal:true from rag-net
   One-line fix per Supervisor review finding. internal:true prevented Ollama from pulling models at startup.
   ```
   Commit: `chore(compose-engineer): logbook update — T1b network fix`

## Expected Outputs

| Path | Description |
|---|---|
| `demos/private-rag/compose.yaml` | `rag-net` no longer has `internal: true` |
| `agents/logbooks/logbook_compose-engineer.md` | Short T1b note appended |
| `agents/handoffs/handoff_compose-engineer_20261001_007.result.md` | Result file (required) |

## Success Criteria

- [ ] `grep -n "internal" demos/private-rag/compose.yaml` returns no results
- [ ] `grep -n "latest" demos/private-rag/compose.yaml` returns no results
- [ ] Commit pushed to `feat/issue-2-private-rag`
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

| Path | Status |
|---|---|
| `demos/private-rag/compose.yaml` | modified |

### Issues encountered

_(filled by session)_

### Supervisor action needed

- [ ] None — task complete as specified
