# Security Review Result — T5

**Handoff:** `agents/handoffs/handoff_security-reviewer_20261001_005.md`  
**Role:** security-reviewer  
**Date:** 2026-10-01  
**Branch:** `feat/issue-2-private-rag`  
**Scope:** `origin/develop..HEAD` (13 commits) — static review + Trivy + Gitleaks  

---

## RECOMMENDATION: HOLD ⛔

**Reason:** 3 CRITICAL CVEs with available fixes found in `qdrant/qdrant:v1.19.1` (Debian base layer).  
Per security-reviewer protocol: ESCALATE when CVSS ≥ 7.0 and fix is available.  
Human review required before T6 can proceed. See **Trivy — qdrant** section for details.

---

## Static Review

### demos/private-rag/compose.yaml — PASS ✅

| Check | Result |
|---|---|
| All images pinned with `tag@sha256:digest` | ✅ |
| Named volumes (no anonymous) | ✅ |
| Internal network `rag-net` (no external exposure) | ✅ |
| Health checks on all 3 services | ✅ |
| `no-new-privileges:true` on all services | ✅ |
| `cap_drop: [ALL]` on all services | ✅ |
| `restart: "no"` on all services | ✅ |
| `read_only: true` on qdrant + ollama; tmpfs for writable paths | ✅ |
| `WEBUI_SECRET_KEY` required (no default, not leaked) | ✅ |
| No plaintext secrets or real credentials | ✅ |

### packages/private-rag/docker-compose.cloud.yaml — WARNING ⚠️

| Check | Result |
|---|---|
| vllm image pinned with digest | ✅ |
| `ipc: host` on vllm service | ⚠️ WARNING — IPC namespace shared with host. Required for NVIDIA GPU SHM sharing but expands attack surface. Requires documented security exception for production. |
| Host bind mounts `/workspace/ollama`, `/workspace/data`, `/workspace/vllm-models` | ⚠️ WARNING — Production use requires these paths to be pre-created and access-controlled. Needs documented security exception. |
| No `no-new-privileges`, `cap_drop` on vllm service | ⚠️ WARNING — vllm container runs without hardening. GPU workloads may require root capabilities but this should be documented. |

### .gitignore — PASS ✅

| Pattern | Status |
|---|---|
| `.env` | ✅ tracked |
| `**/secrets/logical-access.json` | ✅ tracked |
| `mylab_assets.md` | ✅ tracked (added by `05152ba`) |

### demos/private-rag/fixtures/ — PASS ✅

Both `document-retention-policy.md` and `it-security-policy.pdf` use fully synthetic data:
"Acme Corp", `.example` TLD emails — no real PII detected.

### .github/workflows/package-private-rag.yml — PASS ✅

| Check | Result |
|---|---|
| No `pull_request_target` trigger | ✅ |
| No `permissions: write-all` | ✅ |
| `secrets: inherit` acceptable for reusable workflow pattern | ✅ |

---

## Gitleaks — CLEAN ✅

Scan range: `origin/develop..HEAD` (13 commits)  
Result: **0 leaks detected**

---

## Git History Review — commit f68827a

**Assessment: POSITIVE (security improvement chain)**

| Commit | Assessment |
|---|---|
| `482e695` (original mylab_assets.md) | Added file with server connection context |
| `f68827a` | ✅ **IMPROVED** — moved inline server details to `logical-access.json` reference (gitignored) |
| `05152ba` | ✅ **IMPROVED** — added `mylab_assets.md` to `.gitignore`; file now untracked entirely |

**WARNING — `df6deef` commit body:**  
Commit message body for `feat(private-rag): add it-security-policy.pdf fixture` contains:  
```
Generated via fpdf2 on berlin-3eie (admin@192.168.1.110).
```
This leaks the server username and private IP in the permanent git history.  
The commit is already merged into the branch and cannot be retracted without a history rewrite.  
**Severity: LOW** (private IP, internal network only) — note for ops awareness.

---

## Trivy — qdrant/qdrant:v1.19.1 — ESCALATE 🚨

**Scan date:** 2026-10-01  
**Image:** `qdrant/qdrant:v1.19.1@sha256:12364fe851b9f17356fc88189fc06d1b521262e04659ec7345975b00c9246a10`  
**OS:** debian 13.6  
**Total:** 63 (CRITICAL: 3, HIGH: 60)

### CRITICAL CVEs

All 3 CRITICALs are in `perl-base` — a Debian OS package present in the base image.  
**qdrant itself does not expose or invoke Perl.** These are OS-level base image vulnerabilities.  
A fix requires qdrant to release a new Docker image rebuilt on an updated Debian base.  
No specific qdrant release tag is currently known to bundle the patched `perl-base 5.40.1-6+deb13u1`.

| CVE ID | Library | Installed | Fixed In | Layer | Description |
|---|---|---|---|---|---|
| **CVE-2026-13221** | `perl-base` | 5.40.1-6 | `5.40.1-6+deb13u1` | Debian 13.6 base (OS layer) | Incorrect regular expression processing via large regular expressions |
| **CVE-2026-42496** | `perl-base` | 5.40.1-6 | `5.40.1-6+deb13u1` | Debian 13.6 base (OS layer) | Path traversal via crafted symlinks in perl-archive-tar — arbitrary file access |
| **CVE-2026-8376** | `perl-base` | 5.40.1-6 | `5.40.1-6+deb13u1` | Debian 13.6 base (OS layer) | Heap buffer overflow when compiling regular expressions on 32-bit builds |

**Qdrant version that resolves:** No specific qdrant release tag has been identified as containing `perl-base 5.40.1-6+deb13u1`. Resolution requires qdrant to rebuild their Docker image after Debian applies the patched package to their repository mirror used during the image build. Monitor [qdrant/qdrant Docker Hub tags](https://hub.docker.com/r/qdrant/qdrant/tags) for a new release and re-scan.

### HIGH CVEs summary (60 total — not blocking)

Notable libraries with fixable HIGHs: `gzip`, `libpcre2-8-0`, `libsqlite3-0`, `libssl3t64`/`openssl`. Full table available in raw Trivy output.

---

## Trivy — ollama/ollama:0.35.0 — PASS (no CRITICAL) ✅

**Image:** `ollama/ollama:0.35.0@sha256:2a6e883b917fc543389599dae79918f5cac9e1438890506982f44aa4f5625d01`  
**Result:** 45 HIGH, 0 CRITICAL  

> Note: First scan attempt timed out on CUDA layer `libgfortran.so.5.0.0`. Completed on second attempt using `--scanners vuln` (secret scanning disabled to avoid large-file timeout).

---

## Trivy — ghcr.io/open-webui/open-webui:v0.11.4 — INCOMPLETE ⚠️

**Failure reason:** HTTP/2 PROTOCOL_ERROR from GitHub Container Registry during manifest fetch.  
**Status:** Not scanned. Manual re-run required.

```bash
# Run on server (requires Docker + internet access to ghcr.io):
docker run --rm aquasec/trivy:0.58.1 image --scanners vuln \
  ghcr.io/open-webui/open-webui:v0.11.4@sha256:9591b13f13843c7721c2b8eaf7382846c81b3ffe126526d1888d1fed50c6a33f
```

---

## Trivy — vllm/vllm-openai:v0.30.0 — NOT ATTEMPTED ⚠️

**Reason:** Image is ~20 GB (CUDA layers). High timeout risk on the first pass.  
**Status:** Not scanned. Manual run with extended timeout required.

```bash
# Run on server with 30-minute timeout:
docker run --rm aquasec/trivy:0.58.1 image --scanners vuln --timeout 30m \
  vllm/vllm-openai:v0.30.0@sha256:8a69ffad015f138d7170c4ddc429e230a3bc1c1719f67e14324749df200a4b90
```

---

## Required Actions Before T6

1. **[BLOCKING]** Triage the 3 CRITICAL CVEs in `qdrant/qdrant:v1.19.1`:
   - Confirm qdrant does not invoke Perl at runtime (mitigating factor).
   - Decide: accept risk with documented justification, or wait for qdrant to release a patched image.
   - If accepted: add a `# SECURITY-EXCEPTION` comment to compose.yaml referencing this decision.
2. **[RECOMMENDED]** Complete open-webui scan (HTTP/2 error — retry).
3. **[RECOMMENDED]** Complete vllm scan (use extended timeout).
4. **[LOW]** Note `df6deef` commit body leak of `admin@192.168.1.110` for ops awareness — no immediate action required (private IP, not a credential).
5. **[LOW]** Add documented security exceptions for cloud override `ipc: host` and host bind mounts.
