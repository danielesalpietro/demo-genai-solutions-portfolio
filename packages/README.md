# Packages

Each directory here maps 1:1 to a demo in `demos/` or `catalog/`.  
A package bundles everything needed to deploy that demo on a cloud GPU instance (RunPod, Vast.ai) or a local GPU workstation, independently of the host machine's software environment.

## Directory layout

```
packages/<demo>/
├── package.yaml              # manifest: GPU, models, ports, disk
├── docker-compose.cloud.yaml # Compose override for cloud (env defaults, volume mounts)
├── setup.sh                  # startup script (model pull, service start)
├── runpod/
│   ├── template.json         # RunPod pod template
│   └── deploy.sh             # deploy via runpodctl CLI
└── vastai/
    ├── config.json           # Vast.ai instance configuration
    └── deploy.sh             # deploy via vast CLI
```

## Lifecycle

| Demo state | Package state | Image built |
|---|---|---|
| candidate | template (no implementation) | No |
| develop | in-progress | Pre-release tag |
| ready-to-use | complete | Stable tag in GHCR |

## Quick deploy (ready-to-use demos)

```bash
# RunPod
export RUNPOD_API_KEY=<your-key>
./scripts/deploy-runpod.sh hello-compose

# Vast.ai
export VAST_AI_API_KEY=<your-key>
./scripts/deploy-vastai.sh hello-compose
```

## Inference tiers

Each demo supports up to **five inference tiers** selected at deploy time via `INFERENCE_BACKEND` env var and `GPU_TIER` env var:

| `INFERENCE_BACKEND` | `GPU_TIER` | Backend | Default model (Mistral family) | Hardware needed |
|---|---|---|---|---|
| `ollama` | `cpu` | Ollama | `mistral:7b-instruct-q4_K_M` | CPU + ~8 GB RAM |
| `ollama` | `rtx5060ti` | Ollama | `mistral-nemo:12b-instruct-2407-q4_K_M` | RTX 5060 Ti 16 GB |
| `ollama` | `rtx3090` | Ollama | `mistral-small3.1:24b-instruct-2503-q4_K_M` | RTX 3090 24 GB |
| `vllm` | `rtx5060ti` (+ CPU offload) | vLLM | `mistralai/Mistral-Small-3.1-24B-Instruct-2503` | RTX 5060 Ti + 32 GB RAM |
| `api` | _(none)_ | Remote API | `mistral-small-latest` (Mistral AI) | No GPU — API key only |

### vLLM + CPU offload

When `INFERENCE_BACKEND=vllm`, the package starts `vllm/vllm-openai` instead of Ollama.  
CPU offload (`--cpu-offload-gb`) allows running a 24B model on a 16 GB GPU by paging layers to RAM.  
Default parameters per demo are in `spec.inference.vllm` of `package.yaml`.

```bash
# Example: run private-rag with vLLM CPU offload on RTX 5060 Ti
GPU_TIER=rtx5060ti INFERENCE_BACKEND=vllm \
  docker compose \
    -f demos/private-rag/compose.yaml \
    -f packages/private-rag/docker-compose.cloud.yaml \
    up -d
```

### Remote API (GPU-as-a-Service inference)

When `INFERENCE_BACKEND=api`, services call an OpenAI-compatible endpoint instead of a local model.  
No GPU instance required — suitable for lightweight demos or when budget favors API billing over GPU rental.  
Supported providers: `mistral` (Mistral AI), `runpod-serverless`, `together`, `openai-compatible`.

```bash
# Example: run finance-agent against Mistral AI API
INFERENCE_BACKEND=api MISTRAL_API_KEY=sk-... \
  docker compose \
    -f demos/finance-agent/compose.yaml \
    -f packages/finance-agent/docker-compose.cloud.yaml \
    up -d
```

Required secrets per provider:

| Provider | Secret env var | Notes |
|---|---|---|
| `mistral` | `MISTRAL_API_KEY` | la-plateforme.mistral.ai |
| `runpod-serverless` | `RUNPOD_API_KEY` | endpoint ID in `baseUrl` |
| `together` | `TOGETHER_API_KEY` | together.ai |
| `openai-compatible` | configured per `keySecret` field | any OpenAI-spec endpoint |

### GPU hardware mapping

| `GPU_TIER` | Remote runner | RunPod / Vast.ai equivalents |
|---|---|---|
| `rtx3090` | RTX 3090 24 GB | RTX 3090 · A100 80 GB |
| `rtx5060ti` | RTX 5060 Ti 16 GB | RTX 4070 Ti Super · A10 · A6000 |
| `cpu` | CPU-only | any CPU instance |
| _(api tier)_ | — | no GPU instance needed |

## Make targets

```bash
make package-validate DEMO=private-rag                          # validate package.yaml
make package-build    DEMO=private-rag                          # build + push image to GHCR
make deploy-runpod    DEMO=private-rag GPU=rtx3090              # deploy to RunPod
make deploy-vastai    DEMO=private-rag GPU=rtx5060ti            # deploy to Vast.ai
make cloud-test       DEMO=private-rag PLATFORM=runpod GPU=rtx5060ti  # run automated cloud test
```

## Automated cloud testing

`scripts/test-cloud.sh` orchestrates the complete test cycle on a remote GPU instance:

```
deploy → wait-for-SSH → wait-for-demo-ready → run test.sh → fetch artifacts → destroy
```

The instance is always destroyed at exit (success or failure) to contain costs.

### Test artifact retrieval

Artifacts are saved to `test-results/<demo>/` on the CI runner:

| File | Content |
|---|---|
| `run.log` | Full stdout/stderr of `test.sh` |
| `summary.json` | Instance ID, platform, GPU tier, exit code, timestamp |
| `*.png`, `*.json`, `*.csv`, etc. | Any files written to `/workspace/<demo>/test-results/` by `test.sh` |

GitHub Actions uploads the entire `test-results/<demo>/` directory as a workflow artifact (retained 30 days).

### Setup sentinel contract

Each `setup.sh` must write `/workspace/.demo-ready` after all services are healthy:

```bash
# At end of setup.sh, after docker compose up and health checks pass:
touch /workspace/.demo-ready
```

`test-cloud.sh` polls for this file (up to 10 minutes) before running `test.sh`.

### GitHub Actions trigger

The `.github/workflows/test-cloud.yml` workflow accepts manual dispatch with `demo`, `platform`, and `gpu` inputs. It can also be called from per-demo `package-<demo>.yml` via `action: cloud-test`.

## Secrets required (CI/CD)

| Secret | Used by | Tier |
|---|---|---|
| `RUNPOD_API_KEY` | RunPod deploy + cloud-test scripts | ollama · vllm · api |
| `VAST_AI_API_KEY` | Vast.ai deploy + cloud-test scripts | ollama · vllm · api |
| `GHCR_TOKEN` | Push images to GitHub Container Registry | all |
| `MISTRAL_API_KEY` | Inference API tier (`INFERENCE_BACKEND=api`) | api only |
| `TOGETHER_API_KEY` | Together AI inference API (optional alternative) | api only |

Configure via GitHub repository secrets (environment: `cloud-gpu`) or `.env.local` (never committed).

For local development, store inference API keys with:
```bash
./scripts/manage-credentials.sh access set <demo> cloud.mistral_api_key YOUR_KEY
```

---

## Credential management

Each demo has a dedicated `packages/<demo>/secrets/` directory:

```
packages/<demo>/secrets/
├── .gitignore                      # excludes logical-access.json and plaintext scratch
├── logical-access.json.template    # committed: empty template for cloud API keys
├── logical-access.json             # GITIGNORED: filled-in construction keys (cleartext)
├── passwords-noprod.enc            # committed: AES-256-CBC encrypted non-prod passwords
└── passwords-prod.enc              # committed: AES-256-CBC encrypted prod passwords
```

### File purposes

| File | Committed | Encrypted | Contains |
|---|---|---|---|
| `logical-access.json` | **No** | No | Cloud API keys, SSH key path — temporary construction access |
| `passwords-noprod.enc` | Yes | Yes (AES-256) | Service passwords for non-production (dev, test, staging) |
| `passwords-prod.enc` | Yes | Yes (AES-256) | Service passwords for production deployments |

### Workflow: initialize a new demo's credentials

```bash
# 1. Create construction-key file (cleartext, gitignored)
make access-init DEMO=private-rag
make access-show DEMO=private-rag    # verify
./scripts/manage-credentials.sh access set private-rag cloud.runpod_api_key YOUR_KEY

# 2. Initialize encrypted password files (you choose the passphrase)
make creds-init DEMO=private-rag ENV=noprod
make creds-init DEMO=private-rag ENV=prod

# 3. Set individual service passwords
make creds-set DEMO=private-rag ENV=noprod KEY=POSTGRES_PASSWORD VALUE=dev_pw
make creds-set DEMO=private-rag ENV=noprod KEY=QDRANT_API_KEY   VALUE=qdrant_dev
make creds-show DEMO=private-rag ENV=noprod   # verify (requires passphrase)

# 4. Rotate passphrase (e.g. after staff change)
make creds-rotate DEMO=private-rag ENV=prod
```

### Security notes

- **Passphrases** for `.enc` files are **never stored** — the operator keeps them.
- `logical-access.json` is in `.gitignore`; verify with `git status` before committing.
- `.enc` files are safe to commit; decryption requires the passphrase.
- Rotate after any team change or after demo run in a shared environment.
- `passwords-prod.enc` should have a **different passphrase** from `passwords-noprod.enc`.
