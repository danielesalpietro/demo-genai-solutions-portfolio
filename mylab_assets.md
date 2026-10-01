# My Lab Assets

> Reference for Claude Code sessions â€” last surveyed 2026-10-01

---

## Workstation (Windows 11)

| Field | Value |
|---|---|
| Role | Development / Claude Code host |
| OS | Windows 11 |
| SSH key | `C:\Users\danie\Downloads\.ssh\id_ed25519` |

---

## Server: berlin-3eie (HP Z8 G4)

### Access

| Field | Value |
|---|---|
| Hostname | `berlin-3eie` |
| IP | `192.168.1.110` |
| Port | `22` |
| User | `admin` |
| Key | `C:\Users\danie\Downloads\.ssh\id_ed25519` |
| Connect | `ssh -i "C:\Users\danie\Downloads\.ssh\id_ed25519" -p 22 admin@192.168.1.110` |

### OS & Platform

| Field | Value |
|---|---|
| OS | Ubuntu 24.04.2 LTS (Noble Numbat) |
| Kernel | 6.8.0-138-generic |
| Note | Configured as a VastAI node (kaalia runtime shim, vast.ai registry mirrors) |

### CPU

| Field | Value |
|---|---|
| Model | 2Ã— Intel Xeon Gold 6244 @ 3.60 GHz |
| Cores | 8 cores / 16 threads per socket = **32 vCPUs** |
| NUMA node 0 | CPUs 0-7, 16-23 â†’ 109 GB RAM |
| NUMA node 1 | CPUs 8-15, 24-31 â†’ 126 GB RAM |
| NUMA distance | 10 (local) / 21 (remote) |

### RAM

| Type | DIMMs | Per DIMM | Total |
|---|---|---|---|
| DDR4 ECC @ 2400 MT/s | 15 slots | 16 GB | **~240 GB** usable |
| Intel Optane PMEM (App Direct) | 4 Ã— (2 per CPU) | 126.375 GiB each | **505 GiB raw** |

> Optane PMEM is configured in App Direct mode (not as regular DRAM). See `/mnt/pmem_emh2` and `/dev/pmem0`.

### GPUs

| # | Model | VRAM | Compute Cap | Architecture | PCIe slot | NUMA | Power |
|---|---|---|---|---|---|---|---|
| GPU 0 | **NVIDIA GeForce RTX 3090** | **24 GB** GDDR6X | 8.6 (Ampere) | GA102 | 2D:00.0 | Node 0 | 350 W cap |
| GPU 1 | **NVIDIA GeForce RTX 5060 Ti** | **16 GB** | 12.0 (Blackwell) | 2d04 | 99:00.0 | Node 1 | 180 W cap |

| Field | Value |
|---|---|
| Driver | 595.84 |
| CUDA | 13.2 |
| GPUâ†”GPU link | SYS (cross-NUMA PCIe, **no NVLink**) |
| UUID GPU 0 | `GPU-43a04d95-0acb-c344-96a9-0efd013e32a4` |
| UUID GPU 1 | `GPU-f8774b4a-bc76-d044-772a-5fbef5d2083c` |
| CDI device | `nvidia.com/gpu=0`, `nvidia.com/gpu=1`, `nvidia.com/gpu=all` |

**NUMA GPU affinity** (important for performance):
- Ollama / inference on NUMA 0 â†’ prefer `device: 0` (RTX 3090, 24 GB)
- vLLM on NUMA 1 â†’ prefer `device: 1` (RTX 5060 Ti, 16 GB)
- Cross-NUMA use is possible but adds PCIe latency

### Storage

| Device | Size | Mount | Used | Notes |
|---|---|---|---|---|
| `/dev/pmem0s2` | 98 GB | `/` | 21 GB (22%) | Root FS on Optane â€” fast |
| `/dev/pmem0s1` | 511 MB | `/boot/efi` | 6 MB | EFI |
| `/dev/pmem0s3` | 152 GB | `/grastorp/volumes/...` | 3 GB | Optane â€” available |
| `/dev/pmem1` | 248 GB | `/mnt/pmem_emh2` | 230 GB (**93%**) âš ï¸ | Contains MoE-Infinity + emh2_pool.bin |
| `/dev/sdc1` | 932 GB | `/mnt/wdc-docker` | 358 GB (39%) | **Docker data-root** â€” main free space |
| `/dev/nvme0n1` | 894 GB | _unmounted_ | â€” | Samsung MZ1L2960HCJR (enterprise NVMe) |
| `/dev/nvme1n1` | 476 GB | _unmounted_ | â€” | Samsung MZVLB512HAJQ (consumer NVMe) |
| `/dev/sda` | 465 GB | _unmounted_ | â€” | WD HDD |
| `/dev/sdb` | 931 GB | _unmounted_ | â€” | Seagate HDD |
| `/dev/sdd` | 476 GB | _unmounted_ | â€” | Micron MTFDDAK512TDL SATA SSD |

**âš ï¸ Storage warnings**:
- `/mnt/pmem_emh2` is at 93% â€” do NOT write large model files here
- Two NVMe drives (894 GB + 476 GB) are **unmounted and available** â€” ideal for model storage or workspace
- `/workspace` does not exist â€” must be created before running cloud-override demos

### Network

| Interface | State | Address |
|---|---|---|
| `eno1` | UP | `192.168.1.110/24` |
| `enp4s0f2np2` | DOWN | â€” |

### Docker

| Field | Value |
|---|---|
| Version | 29.7.2 |
| Compose | v5.5.0 |
| data-root | `/mnt/wdc-docker/docker` |
| Default runtime | `runc` |
| Available runtimes | `runc`, `nvidia` (kaalia shim), `runsc` (gVisor) |
| Registry mirrors | docker.io + 5Ã— vast.ai mirrors |
| CDI | both GPUs registered |

**Disk usage (Docker)**:
- Images: 56 total / 194 GB (48 GB reclaimable)
- Volumes: 77 total / 54 GB (24 GB reclaimable)
- Build cache: 192 entries / 60 GB
- Containers: 36 stopped / 235 MB (all reclaimable)
- No containers currently running

**Named volume namespaces** (hints at past projects):
- `caliper_*` â€” Flowise + OpenWebUI + Qdrant + Ollama pipeline
- `vmemoryfabric_*` â€” virtual memory fabric experiments (multiple branches)
- `wap-northstream-lab_*` â€” Kafka / Elasticsearch / MinIO / OpenMetadata stack
- `clean_env_check_*`, `docker_forge_*`

### Software

| Tool | Version | Notes |
|---|---|---|
| make | 4.3 | available at `/usr/bin/make` |
| CUDA toolkit | â€” | Not in PATH; driver CUDA 13.2 available |

---

## Planning notes for private-rag demo

- **Create `/workspace`** before first run: `sudo mkdir -p /workspace && sudo chown admin:admin /workspace`
- Recommend placing `/workspace` on `/mnt/wdc-docker` (574 GB free): `sudo mkdir -p /mnt/wdc-docker/workspace && sudo ln -s /mnt/wdc-docker/workspace /workspace`
- **Ollama** (NUMA 0): assign to GPU 0 (RTX 3090, 24 GB) via `CUDA_VISIBLE_DEVICES=0`
- **vLLM** (NUMA 1): assign to GPU 1 (RTX 5060 Ti, 16 GB) via `CUDA_VISIBLE_DEVICES=1`
- Model size guide for this hardware:
  - Up to ~13B @ Q4 â†’ RTX 5060 Ti alone (16 GB)
  - Up to ~30B @ Q4 â†’ RTX 3090 alone (24 GB)
  - Up to ~46B @ Q4 â†’ both GPUs (40 GB, cross-NUMA â€” functional, not optimal)
- Docker `--gpus device=0` for RTX 3090; `--gpus device=1` for RTX 5060 Ti
- nvidia runtime via CDI: `deploy.resources.reservations.devices[0].capabilities: [gpu]`

---

## Open action items (as of 2026-10-01)

- [ ] Mount NVMe drives for model storage (`/dev/nvme0n1` 894 GB, `/dev/nvme1n1` 476 GB)
- [ ] Free up `/mnt/pmem_emh2` (93% full) â€” review MoE-Infinity data
- [ ] Create `/workspace` symlink to `/mnt/wdc-docker/workspace`
- [ ] Prune Docker build cache (60 GB) and stopped containers (235 MB) after validating no active projects need them
