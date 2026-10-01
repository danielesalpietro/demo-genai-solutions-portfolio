# Infrastructure reference

Source of truth for execution targets available to handoff sessions.
Sensitive values (SSH key paths, passwords, tokens) are never stored here —
they are provided by the operator in-session. See `mylab_assets.md` (local,
gitignored) for full hardware survey and per-asset planning notes.

---

## Systems

### berlin-3eie (HP Z8 G4) — primary deploy & test server

| Field | Value |
|---|---|
| Hostname | `berlin-3eie` |
| IP | `192.168.1.110` |
| Port | `22` |
| User | `admin` |
| OS | Ubuntu 24.04.2 LTS (kernel 6.8.0-138-generic) |
| SSH key | Local on operator workstation — provided in-session, never committed |
| Connect | `ssh -i <key> -p 22 admin@192.168.1.110` |

**CPU**: 2× Intel Xeon Gold 6244 @ 3.60 GHz — 32 vCPUs total (2 NUMA nodes)

**RAM**: ~240 GB DDR4 ECC + 505 GiB Intel Optane PMEM (App Direct mode)

**GPUs**:

| # | Model | VRAM | CUDA Cap | NUMA | CDI |
|---|---|---|---|---|---|
| GPU 0 | RTX 3090 | 24 GB GDDR6X | 8.6 (Ampere) | Node 0 | `nvidia.com/gpu=0` |
| GPU 1 | RTX 5060 Ti | 16 GB | 12.0 (Blackwell) | Node 1 | `nvidia.com/gpu=1` |

**NUMA GPU affinity** (performance-critical):
- Ollama → GPU 0 (RTX 3090, NUMA 0) — `CUDA_VISIBLE_DEVICES=0`
- vLLM → GPU 1 (RTX 5060 Ti, NUMA 1) — `CUDA_VISIBLE_DEVICES=1`

**Docker**:
- Version: 29.7.2, Compose: v5.5.0
- data-root: `/mnt/wdc-docker/docker` (574 GB free — main workspace)
- Available runtimes: `runc`, `nvidia` (kaalia shim), `runsc` (gVisor)
- CDI: both GPUs registered

**Storage — key paths**:

| Path | Size | Free | Notes |
|---|---|---|---|
| `/` | 98 GB | ~77 GB | Root on Optane (fast) |
| `/mnt/wdc-docker` | 932 GB | ~574 GB | **Docker data-root — use for /workspace** |
| `/mnt/pmem_emh2` | 248 GB | ~18 GB | ⚠️ 93% full — do NOT write here |
| `/dev/nvme0n1` | 894 GB | unmounted | Available for model storage |
| `/dev/nvme1n1` | 476 GB | unmounted | Available for model storage |

**Pre-run setup**: `/workspace` confirmed operational (T3 script-engineer ran 15 contract tests there on 2026-10-01).

**Rules for remote sessions on berlin-3eie** (the server must be left exactly as found):
- Clone repo to `/tmp/demo-genai-XXXXXX` (via `mktemp -d`) — NEVER to `~` or a permanent path
- After session: `rm -rf $CLONE_DIR` — mandatory, not optional
- After session: remove only Docker containers and volumes created by this session (`docker ps --filter label=com.docker.compose.project=<project>`)
- Do NOT install packages permanently, create systemd units, cron entries, or modify `/etc/`
- Do NOT touch existing named volumes (`caliper_*`, `vmemoryfabric_*`, `wap-northstream-lab_*`, etc.)
- Do NOT remove or prune images/volumes that preexisted — check `docker ps` and `docker volume ls` before any remove
- Commit and push result files BEFORE `rm -rf` (repo gone = cannot push)

**Open action items** (tracked here for linux-agent dispatch):
- [x] Create `/workspace` symlink to `/mnt/wdc-docker/workspace` _(done — T3 confirmed)_
- [ ] Mount `/dev/nvme0n1` (894 GB) for model storage
- [ ] Mount `/dev/nvme1n1` (476 GB) for model storage
- [ ] Prune Docker build cache (60 GB) and stopped containers after validating no active projects

---

## Execution context codes

| Code | Target | How to activate |
|---|---|---|
| `local` | Operator workstation (Windows 11) | Desktop-app tab or local terminal |
| `remote:z8g4` | berlin-3eie (192.168.1.110, Linux) | `ssh -i <key> admin@192.168.1.110` → `claude` → `/remote-control <handoff>` |
| `remote:runpod` | RunPod GPU cloud | `scripts/test-cloud.sh <demo> runpod <gpu>` |
| `remote:vastai` | Vast.ai GPU cloud | `scripts/test-cloud.sh <demo> vastai <gpu>` |

---

## Model size guide for berlin-3eie

| Config | Max model size @ Q4 | Notes |
|---|---|---|
| GPU 0 only (RTX 3090) | ~30B | Optimal — single NUMA node |
| GPU 1 only (RTX 5060 Ti) | ~13B | Optimal — single NUMA node |
| Both GPUs (40 GB total) | ~46B | Cross-NUMA PCIe — functional, not optimal |
| CPU-only | ~8B | Uses DDR4, not Optane |
