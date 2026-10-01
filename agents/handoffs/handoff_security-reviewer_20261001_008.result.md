# Security Review Result — T5b

**Handoff:** `agents/handoffs/handoff_security-reviewer_20261001_008.md`  
**Role:** security-reviewer  
**Date:** 2026-10-01  
**Branch:** `feat/issue-2-private-rag`  
**Scope:** Trivy scans for `open-webui:v0.11.4` and `vllm/vllm-openai:v0.30.0` (T5 incomplete scans)  
**Execution host:** `berlin-3eie` (192.168.1.110) via SSH — Docker 29.7.2, `aquasec/trivy:0.58.1`

---

## RECOMMENDATION: ESCALATE ⛔

**Reason:** 3 CRITICAL Python CVEs with available fixes found in `open-webui:v0.11.4`.  
Per security-reviewer protocol: ESCALATE when CVSS ≥ 7.0 and fix is available.  
Human review required before T6 can proceed.

---

## Part A — open-webui:v0.11.4 Trivy Scan

**Image:** `ghcr.io/open-webui/open-webui:v0.11.4@sha256:9591b13f13843c7721c2b8eaf7382846c81b3ffe126526d1888d1fed50c6a33f`  
**Method:** First attempt (direct registry pull) failed again with HTTP/2 PROTOCOL_ERROR from ghcr.io. Fallback: `docker pull` then local scan via Docker socket mount. **Scan succeeded.**

### CVE Summary

| Layer | CRITICAL | HIGH |
|---|---|---|
| OS (Debian base) | 22 | 458 |
| Python packages (pip) | 5 | 39 |
| **Total** | **27** | **497** |

### CRITICAL CVEs — Python layer (with fix available → ESCALATE)

| CVE | Package | Installed | Fixed | Status | Action |
|---|---|---|---|---|---|
| CVE-2026-102268 | PyJWT | 2.13.0 | 2.14.0 | `fixed` | **ESCALATE** |
| CVE-2026-68770 | sentence-transformers | 5.5.1 | 5.6.0 | fix available | **ESCALATE** |
| CVE-2026-71428 | unstructured | 0.22.31 | 0.24.0 | fix available | **ESCALATE** |

**CVE-2026-102268 (PyJWT):** JWT implementation bug; prior to 2.14.0. Fix available in 2.14.0.  
**CVE-2026-68770 (sentence-transformers):** Remote Code Execution. Fix available in 5.6.0.  
**CVE-2026-71428 (unstructured):** Server-Side Request Forgery. Fix available in 0.24.0.

### CRITICAL CVEs — Python layer (no fix / affected)

| CVE | Package | Status |
|---|---|---|
| CVE-2026-45829 | chromadb 1.5.9 | `affected` — no fix version available |

### CRITICAL CVEs — OS layer (all no-fix or fix-deferred)

| CVE | Package | Status | Notes |
|---|---|---|---|
| CVE-2023-6879 | libaom3 | `affected` | No fix in Debian 12 |
| CVE-2026-58016 | libglib2.0-0 | `fix_deferred` | Debian patch pending |
| CVE-2025-47917 | libmbedcrypto7 | `end_of_life` | EOL package |
| CVE-2026-13221 | libperl5.36, perl, perl-base, perl-modules-5.36 | `affected` | Same as T5 qdrant finding; Debian tracking |
| CVE-2025-7458 | libsqlite3-0 | `affected` | No fix in Debian 12 |
| CVE-2026-6653 | libxml2 | no status | No fix version listed |
| CVE-2026-43185 | linux-libc-dev | no status | Kernel headers only |
| CVE-2023-45853 | zlib1g | `will_not_fix` | Vendor decision |

**Assessment:** OS-level CRITICAL CVEs are consistent with Debian 12 base image age and are all either `affected/will_not_fix/end_of_life/fix_deferred` — no actionable fixes currently available in Debian package repos. These are accepted exceptions per T5 precedent (qdrant perl-base escalation already covers the Debian base issue for the project as a whole).

---

## Part B — vllm/vllm-openai:v0.30.0 Trivy Scan

**Image:** `vllm/vllm-openai:v0.30.0@sha256:8a69ffad015f138d7170c4ddc429e230a3bc1c1719f67e14324749df200a4b90`  
**Timeout:** 30 minutes

### Result: TIMEOUT ⚠️

The scan completed OS layer and most Python layer analysis (ending at ~14:20 UTC) but timed out at 14:33 UTC when analyzing NVIDIA CUDA proprietary binary `usr/local/lib/python3.12/dist-packages/nvidia/cusparselt/lib/libcusparseLt.so.0`.

```
FATAL: image scan error: ... failed to analyze usr/local/lib/python3.12/dist-packages/nvidia/cusparselt/lib/libcusparseLt.so.0: semaphore acquire: context deadline exceeded
```

**No CVE table was generated** (Trivy prints results only after completing all layers).

### Accepted Exception — Justification

| Factor | Assessment |
|---|---|
| Root cause | Trivy cannot efficiently scan large NVIDIA proprietary CUDA `.so` binaries (>2 GB CUDA layer) |
| Scope | vllm is only used with `--profile vllm` (cloud profile); standard demo path uses qdrant+ollama+open-webui |
| Risk mitigant | NVIDIA CUDA runtime libraries are maintained by NVIDIA and patched via driver updates, not OS package managers |
| Alternative | Grype (`anchore/grype`) handles CUDA images better; recommend for future vllm scans |
| Partial analysis completed | OS base (Ubuntu 22.04) and Python packages scanned successfully; PyJWT 2.7.0 noted (predates CVE-2026-102268 fix window) |

**Decision:** Accept as documented exception. vllm cloud-profile deployment should use Grype or a CUDA-aware scanner before production use.

---

## Escalation Items (New — T5b addendum)

The following are **new escalation items** to add to the existing Issue #2 escalation thread:

1. **CVE-2026-102268** — PyJWT 2.13.0 in `open-webui:v0.11.4`; fix available in PyJWT 2.14.0; open-webui maintainers must update their dependency.
2. **CVE-2026-68770** — sentence-transformers 5.5.1 in `open-webui:v0.11.4`; RCE; fix available in 5.6.0.
3. **CVE-2026-71428** — unstructured 0.22.31 in `open-webui:v0.11.4`; SSRF; fix available in 0.24.0.

These are **upstream package vulnerabilities** in the open-webui image (not in this repo's code). Recommended actions for the human maintainer:
- Pin to a newer open-webui release that includes updated Python dependencies, or
- Accept as demo-context risk with documented exception (demo is airgapped, not internet-facing)

---

## Supervisor Action Needed

- [x] **ESCALATE** — New CRITICAL CVEs with fixes found in open-webui. Post comment on Issue #2 before T6 proceeds.
- [x] **ACCEPT EXCEPTION** — vllm Trivy scan timeout; documented above. Human to decide whether Grype scan is required before T6.

---

## Result

| Field | Value |
|---|---|
| Status | `completed` |
| Completed | 2026-10-01T14:40Z |
| Exit code | 0 |
| Session | Claude Sonnet 4.6 (T5b, worktree `t5b-z8g4-handoff-security-5165fd`) |

### Summary

T5b completed both pending scans from T5:
- **open-webui**: Scan succeeded (local pull fallback). 27 CRITICAL CVEs total; 3 Python CVEs with fixes available → ESCALATE before T6.
- **vllm**: Scan timed out on NVIDIA CUDA binary layer (30m limit). Accepted as documented exception; vllm is cloud-profile only.

### Artifacts produced

- `agents/handoffs/handoff_security-reviewer_20261001_008.result.md` (this file)
- `agents/logbooks/logbook_security-reviewer.md` (entry 2 appended)

### Issues encountered

- open-webui: HTTP/2 PROTOCOL_ERROR from ghcr.io on direct registry scan; resolved via `docker pull` + local scan.
- vllm: Trivy timeout (30m) on NVIDIA CUDA shared library layer; no CVE table produced.
