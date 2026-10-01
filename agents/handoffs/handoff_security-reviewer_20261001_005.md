# Handoff: security-reviewer — T5

## Header

| Field | Value |
|---|---|
| Handoff file | `agents/handoffs/handoff_security-reviewer_20261001_005.md` |
| Role | `security-reviewer` |
| Issue | `#2` |
| Branch | `feat/issue-2-private-rag` |
| Follows | _(none — depends on T1 being complete)_ |
| Status | `pending` |
| Requested | `2026-10-01T00:00Z` |
| Completed | _(filled by session)_ |

## Assigned To

- **Role**: `security-reviewer`
- **Execution context**: `local`
- **OS**: Linux / WSL2 (Trivy and Gitleaks must be available)
- **Session**: _(filled by operator when activating)_

## Context

This task is part of the work for Issue #2: feat: implement private-rag — Enterprise Knowledge Assistant.

The security-reviewer audits all files produced by T1–T3 for security issues before the PR gate check (T6). The reviewer is **read-only**: it reports findings but does not modify implementation files. If a HIGH/CRITICAL CVE is found, it must escalate to human before T6 proceeds.

**Prerequisites already delivered (verify before starting)**:
- T1: `demos/private-rag/compose.yaml`, `demos/private-rag/.env.example`, `packages/private-rag/docker-compose.cloud.yaml`
- T2: `demos/private-rag/fixtures/` (documents only — no secrets expected)
- T3: `demos/private-rag/demo.sh`, `test.sh`, `reset.sh` (optional — review if available)

## Prerequisites

Before executing:
- [ ] Read `agents/logbooks/logbook_security-reviewer.md` if it exists
- [ ] Verify you are on branch `feat/issue-2-private-rag` and have pulled latest
- [ ] Verify T1 result file shows `status: completed`
- [ ] Confirm `trivy` is installed (`trivy --version`); if not, install via `apt-get install trivy` or `brew install trivy`
- [ ] Confirm `gitleaks` is installed (`gitleaks version`); if not, install from https://github.com/gitleaks/gitleaks/releases
- [ ] Read `agents/security-reviewer.md` — the full checklist

## Task Instructions

### Part A — Static file review

1. Review `demos/private-rag/compose.yaml`:
   - Check every image for `:latest` tag → FAIL if found
   - Check for `privileged: true` → FAIL if found
   - Check for `network_mode: host` → FAIL if found
   - Check for `/var/run/docker.sock` mount → FAIL if found
   - Check for `cap_drop: [ALL]` on every service → note if missing
   - Check for `no-new-privileges: true` on every service → note if missing
   - Check for `read_only: true` where feasible → note where missing

2. Review `packages/private-rag/docker-compose.cloud.yaml`:
   - Same checks as above
   - Confirm vllm image is no longer `latest` (T1 should have pinned it)

3. Review `demos/private-rag/.env.example`:
   - Confirm no value looks like a real secret (all values should be `CHANGE_ME_*`, empty, or an obvious placeholder)
   - Confirm the file itself is not `.env` (which should never be committed)

4. Review `demos/private-rag/demo.sh` (if T3 is complete):
   - Look for any hardcoded credentials, tokens, or API keys
   - Note: the default admin password `DemoAdmin123!` is acceptable in a demo context but must be documented in README security notes

5. Review `demos/private-rag/fixtures/` — confirm files contain only synthetic/fictional data; no real names, real email addresses, real company data, or anything resembling PII.

### Part B — Trivy image scan

6. For each image in `demos/private-rag/compose.yaml`, run Trivy:
   ```bash
   trivy image --severity HIGH,CRITICAL --exit-code 0 <image-with-digest>
   ```
   (Use `--exit-code 0` to collect results without failing; you will evaluate them manually.)

7. For the vllm image in `packages/private-rag/docker-compose.cloud.yaml`, run the same scan.

8. List all HIGH/CRITICAL CVEs found. For each:
   - Note CVE ID, CVSS score, affected package, and fix status (fixed/not-fixed/will-not-fix)
   - If any CVE has CVSS ≥ 7.0 and a fix is available: **ESCALATE to human** (do not proceed to T6)
   - If CVE has CVSS ≥ 7.0 but fix is not available: document as an accepted exception with justification

### Part C — Gitleaks scan

9. Run Gitleaks on the branch diff:
   ```bash
   gitleaks detect --source . --log-opts "origin/develop..HEAD" --exit-code 0
   ```
10. If any findings: list them verbatim and **ESCALATE to human**.

### Part D — GitHub Actions workflow review (if new workflows added)

11. Review any new or modified workflow files in `.github/workflows/`:
    - No `pull_request_target` trigger without justification
    - No `permissions: write-all`
    - All external actions pinned to a commit SHA

### Part E — Write findings report

12. Write a findings report in `agents/handoffs/handoff_security-reviewer_20261001_005.result.md` with:
    - Section "PASS" listing all checks that passed
    - Section "FINDINGS" listing any issues found (severity: BLOCKER / WARNING / NOTE)
    - Section "CVE SUMMARY" with the Trivy output summary
    - Section "GITLEAKS SUMMARY" with the scan result
    - Section "RECOMMENDATION" — GO / HOLD (HOLD only if BLOCKER findings exist)

### Part F — Logbook

13. Append entry to `agents/logbooks/logbook_security-reviewer.md` and commit: `chore(security-reviewer): logbook update — private-rag T5`

## Expected Outputs

| Path | Description |
|---|---|
| `agents/logbooks/logbook_security-reviewer.md` | Updated logbook entry (required) |
| `agents/handoffs/handoff_security-reviewer_20261001_005.result.md` | Findings report with GO/HOLD recommendation (required) |

**Important**: security-reviewer is read-only. Do NOT modify `compose.yaml`, `demo.sh`, or any implementation file. Report findings only.

## Success Criteria

The task is complete when ALL of these are true:

- [ ] All checklist items from `agents/security-reviewer.md` have a documented result
- [ ] Trivy scan completed for all images; results documented
- [ ] Gitleaks scan completed; results documented
- [ ] If any BLOCKER found: escalation comment posted on Issue #2 and Supervisor notified in result file
- [ ] Result file includes GO or HOLD recommendation
- [ ] Logbook entry written and committed
- [ ] Result file written with `status: completed`

## Credentials / Access

| What | Source | Operator-provided value |
|---|---|---|
| None required (read-only review) | — | — |

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

- [ ] None — GO recommendation, T6 may proceed
- [ ] HOLD — BLOCKER findings, escalate to human before T6
