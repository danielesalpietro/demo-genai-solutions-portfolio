# Security Reviewer Logbook

## Entry 2 — T5b: Retry open-webui + vllm Trivy scans (2026-10-01)

**Session:** Claude Sonnet 4.6 (desktop app, worktree `t5b-z8g4-handoff-security-5165fd`)  
**Handoff:** `agents/handoffs/handoff_security-reviewer_20261001_008.md`  
**Branch:** `feat/issue-2-private-rag`  
**Scope:** Trivy scans for the two images T5 could not complete

### Work performed

1. **open-webui:v0.11.4** Trivy scan:
   - Direct registry scan failed again (HTTP/2 PROTOCOL_ERROR from ghcr.io)
   - Fallback: `docker pull` image onto berlin-3eie, then local scan via Docker socket — **succeeded**
   - OS layer: 22 CRITICAL / 458 HIGH (all `affected`/`will_not_fix`/`end_of_life`/`fix_deferred`)
   - Python layer: 5 CRITICAL / 39 HIGH
   - **3 CRITICAL Python CVEs with fixes available → ESCALATE**: PyJWT (CVE-2026-102268→2.14.0), sentence-transformers (CVE-2026-68770→5.6.0), unstructured (CVE-2026-71428→0.24.0)

2. **vllm/vllm-openai:v0.30.0** Trivy scan:
   - 30-minute timeout; scan aborted on NVIDIA CUDA library `libcusparseLt.so.0`
   - No CVE table produced; partial analysis only
   - Accepted as documented exception: vllm is cloud-profile only; CUDA binaries require Grype or CUDA-aware scanner

### Outcome

- **RECOMMENDATION: ESCALATE** — 3 new CRITICAL Python CVEs with fixes in open-webui
- Result file written: `agents/handoffs/handoff_security-reviewer_20261001_008.result.md`
- vllm scan limitation documented with justified exception

### Notes

- Security reviewer is READ-ONLY — no implementation files modified
- ghcr.io HTTP/2 issue is persistent; local pull fallback is the reliable approach for open-webui scans
- vllm CUDA layer analysis will require a different tool (Grype recommended)

---

## Entry 1 — T5: Static Review + Trivy + Gitleaks (2026-10-01)

**Session:** Claude Sonnet 4.6 (desktop app, worktree `compose-engineer-handoff-9c4a2d`)  
**Handoff:** `agents/handoffs/handoff_security-reviewer_20261001_005.md`  
**Branch:** `feat/issue-2-private-rag`  
**Scope:** `origin/develop..HEAD` (13 commits)

### Work performed

1. **Static review** of all compose files, .gitignore, fixture data, CI workflow:
   - `demos/private-rag/compose.yaml` → PASS
   - `packages/private-rag/docker-compose.cloud.yaml` → 3 warnings (ipc:host, host bind mounts, unhardened vllm)
   - `.gitignore`, fixtures, CI workflow → PASS

2. **Gitleaks** (`gitleaks detect --source . --log-opts origin/develop..HEAD`):
   - Result: CLEAN — 0 leaks in 13 commits

3. **Commit history review (f68827a)**:
   - f68827a and 05152ba form a positive security improvement chain (credentials moved out of tracked files)
   - WARNING: `df6deef` commit body leaks `admin@192.168.1.110` in permanent history

4. **Trivy image scans** (run on berlin-3eie via SSH, Docker-based `aquasec/trivy:0.58.1`):
   - `qdrant/qdrant:v1.19.1` → 3 CRITICAL + 60 HIGH (all in Debian base layer, not qdrant binary)
   - `ollama/ollama:0.35.0` → 0 CRITICAL + 45 HIGH (first attempt timed out on CUDA layers; second pass with `--scanners vuln` succeeded)
   - `open-webui:v0.11.4` → SCAN FAILED (HTTP/2 error from GHCR)
   - `vllm/vllm-openai:v0.30.0` → NOT ATTEMPTED (~20 GB image, timeout risk)

### Outcome

- **RECOMMENDATION: HOLD** — 3 CRITICAL CVEs with available fix in qdrant's `perl-base` (Debian 13.6 base layer)
- Result file written: `agents/handoffs/handoff_security-reviewer_20261001_005.result.md`
- Per protocol: human review required before T6 (script-engineer/integration) can proceed

### Notes

- Security reviewer is READ-ONLY — no files were modified during this session
- SSH + Docker-based Trivy approach worked well for qdrant and ollama; GHCR HTTP/2 issues require retry for open-webui
- The 3 CRITICAL CVEs are Debian OS-level (perl-base), not qdrant application code. qdrant does not invoke Perl at runtime, but protocol requires escalation regardless of mitigating context.
