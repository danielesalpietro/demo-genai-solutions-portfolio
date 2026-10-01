# Handoff: security-reviewer — T5b (incomplete scans)

## Header

| Field | Value |
|---|---|
| Handoff file | `agents/handoffs/handoff_security-reviewer_20261001_008.md` |
| Role | `security-reviewer` |
| Issue | `#2` |
| Branch | `feat/issue-2-private-rag` |
| Follows | `handoff_security-reviewer_20261001_005.md` |
| Status | `pending` |
| Requested | `2026-10-01T00:00Z` |
| Completed | _(filled by session)_ |

## Assigned To

- **Role**: `security-reviewer`
- **Execution context**: `remote:z8g4` (berlin-3eie — Docker + internet access required)
- **OS**: Ubuntu 24.04.2 LTS
- **Session**: _(filled by operator when activating)_

## Context

T5 (handoff_security-reviewer_20261001_005.result.md) completed with HOLD. Two Trivy scans were not completed:
1. `ghcr.io/open-webui/open-webui:v0.11.4` — HTTP/2 PROTOCOL_ERROR from ghcr.io during manifest fetch
2. `vllm/vllm-openai:v0.30.0` — skipped due to ~20 GB image size and timeout risk

These scans must be completed before T6 (test-engineer) can run the final gate check.

**Context on the T5 HOLD status**: The CRITICAL CVEs in `qdrant/qdrant:v1.19.1` (perl-base) have been escalated to the human maintainer via Issue #2 comment. T5b proceeds regardless — its findings are additive. If open-webui or vllm have CRITICAL CVEs with fixes available, those must also be escalated before T6.

## Prerequisites

Before executing:
- [ ] Read `agents/logbooks/logbook_security-reviewer.md`
- [ ] Verify you are on branch `feat/issue-2-private-rag` and have pulled latest
- [ ] Read T5 result file: `agents/handoffs/handoff_security-reviewer_20261001_005.result.md`
- [ ] Confirm Docker daemon is running on berlin-3eie (`docker info`)
- [ ] Confirm internet access to ghcr.io (`curl -I https://ghcr.io`)
- [ ] Confirm disk space for vllm pull (~20 GB): `df -h /var/lib/docker`

## Task Instructions

### Part A — Retry open-webui Trivy scan

1. Run the scan (using the exact digest from T1):
   ```bash
   docker run --rm aquasec/trivy:0.58.1 image --scanners vuln --timeout 15m \
     ghcr.io/open-webui/open-webui:v0.11.4@sha256:9591b13f13843c7721c2b8eaf7382846c81b3ffe126526d1888d1fed50c6a33f \
     --format table 2>&1 | tee /tmp/trivy-open-webui.txt
   ```
   
2. If it still fails with HTTP/2 error, try pulling the image first then scanning locally:
   ```bash
   docker pull ghcr.io/open-webui/open-webui:v0.11.4@sha256:9591b13f13843c7721c2b8eaf7382846c81b3ffe126526d1888d1fed50c6a33f
   docker run --rm aquasec/trivy:0.58.1 image --scanners vuln \
     ghcr.io/open-webui/open-webui:v0.11.4@sha256:9591b13f13843c7721c2b8eaf7382846c81b3ffe126526d1888d1fed50c6a33f
   ```

3. Report: total CVEs (CRITICAL/HIGH), any CRITICAL CVEs with fixes available.

### Part B — vllm Trivy scan

4. Run with extended timeout:
   ```bash
   docker run --rm aquasec/trivy:0.58.1 image --scanners vuln --timeout 30m \
     vllm/vllm-openai:v0.30.0@sha256:8a69ffad015f138d7170c4ddc429e230a3bc1c1719f67e14324749df200a4b90 \
     --format table 2>&1 | tee /tmp/trivy-vllm.txt
   ```

5. Report: total CVEs (CRITICAL/HIGH), any CRITICAL CVEs with fixes available.
   Note: vllm is only used in the cloud profile (`--profile vllm`), not in the standard demo path.

### Part C — Result

6. Write `agents/handoffs/handoff_security-reviewer_20261001_008.result.md` with:
   - open-webui scan: total counts, CRITICAL CVEs (if any), recommendation
   - vllm scan: total counts, CRITICAL CVEs (if any), recommendation
   - Overall addendum: PASS (no new blockers) or ESCALATE (new CRITICAL CVEs with fixes found)

7. Append logbook entry: `chore(security-reviewer): logbook update — T5b incomplete scans`
8. Commit and push result file + logbook.

## Expected Outputs

| Path | Description |
|---|---|
| `/tmp/trivy-open-webui.txt` | Raw scan output (local only, not committed) |
| `/tmp/trivy-vllm.txt` | Raw scan output (local only, not committed) |
| `agents/logbooks/logbook_security-reviewer.md` | Updated logbook entry |
| `agents/handoffs/handoff_security-reviewer_20261001_008.result.md` | Result with scan summaries |

## Success Criteria

- [ ] open-webui Trivy scan completed (or documented permanent failure with workaround)
- [ ] vllm Trivy scan completed (or documented reason for skip with risk acceptance)
- [ ] CRITICAL CVEs (if any) with available fixes escalated to human via Issue #2 comment
- [ ] Result file written with `status: completed`

## Credentials / Access

| What | Source | Operator-provided value |
|---|---|---|
| SSH to berlin-3eie | `ssh -i <key> -p 22 admin@192.168.1.110` | _(operator provides key in-session)_ |
| Docker Hub pull (rate limit) | `docker login` if needed | _(operator confirms)_ |
| ghcr.io anonymous pull | No auth required for public images | — |

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

- [ ] None — PASS (no new blockers)
- [ ] New CRITICAL CVEs found — escalate to human before T6
