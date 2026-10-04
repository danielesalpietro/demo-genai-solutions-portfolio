# CR-002: Timeline — T6 (gate check) blocked ≥ 3 days, target_date at risk

| Field | Value |
|---|---|
| ID | CR-002 |
| Opened | 2026-10-04 |
| Opened by | project-manager |
| Status | open |
| Severity | medium |
| Impact type | timeline |
| Affected WBS | D11-T6, D11-PR, D11 (target_date 2026-10-05) |
| GitHub Issue | #8 |
| Related CR | CR-001 (root cause) |

## Description

D11-T6 (gate check — make validate + smoke test) has been in `blocked` status since **2026-10-01**, for 3 calendar days. The PM protocol requires a change request when a task remains blocked for > 3 days.

**Root cause of block**: D11-T5 HOLD (3 CRITICAL CVEs in qdrant perl-base), for which no human decision has been received despite:
- Supervisor escalation comment on Issue #2 (2026-10-01)
- CR-001 opened (Issue #7, 2026-10-03)

T6 cannot start until BOTH conditions are resolved:
1. Human decision on CR-001 (CVE exception or patched image)
2. T5b (Trivy retry for open-webui + vllm) produces a result file

**Secondary factor**: D11-T1b (rag-net `internal:true` fix) has been dispatched since 2026-10-01 but not yet activated. While T1b is not a hard prerequisite for T6, it is required for a fully functional smoke test.

## Impact analysis

- **Timeline**: D11 target_date is **2026-10-05** (tomorrow). T6 requires at minimum 1 session day to run. T4b (setup_buildin.md) and the PR also follow T6. **Target_date 2026-10-05 will be missed.** Best-case estimate: PR open 2026-10-07 or later, depending on when CR-001 is resolved.
- **Scope**: No scope change — the deliverable definition is unchanged.
- **Resources**: No additional resources required. The block is a decision dependency, not a compute dependency.
- **Risk**: If the block persists beyond 2026-10-10, a timeline CR (CR-003) will trigger for target_date miss > 5 days.

## Options

| Option | Pros | Cons |
|---|---|---|
| A — Resolve CR-001 (Option A: accept CVE exception) immediately | Unblocks T6 same day; target_date slip minimised to ~2 days | Ships with CRITICAL CVE documentation in changelog |
| B — Resolve CR-001 (Option B: wait for patched qdrant) | No CVEs in shipped image | Indefinite block; target_date miss of unknown duration |
| C — Activate T6 in parallel with CR-001 on non-qdrant scope | Partial progress possible | Gate check would be incomplete (T5 not resolved); not recommended |

## Recommendation

This CR has no independent resolution path — it is a downstream consequence of CR-001. **Resolving CR-001 (Option A) also resolves CR-002.** The recommendation is identical: approve Option A on CR-001 / Issue #7, which will unblock T6 and allow a target-date slip of ~2 days rather than indefinite.

## Decision

_(human maintainer fills this section)_

- [ ] Accepted — resolving CR-001 resolves this CR; target-date slip noted
- [ ] Deferred to: <date>
- [ ] Rejected: <reason>
