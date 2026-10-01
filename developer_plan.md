# Developer Plan — GenAI Demo Portfolio

_Last updated: 2026-10-01_

---

## 1. Scope and principles

This document is the authoritative development plan for building the demo portfolio.  
Each demo is a self-contained, reproducible, secure Docker Compose demonstration that illustrates a GenAI or Agentic AI capability.

**Governing principles:**

- Every demo must satisfy the demo contract in `AGENTS.md`.
- Every demo starts from a typed GitHub Issue with confirmed acceptance criteria.
- Agents propose via Pull Request; humans approve and merge.
- On-premise and air-gapped deployment is the default target: no demo should require an external API call during a live presentation.
- Before including any upstream repository, verify: source license, model/weight license, external API dependencies, GPU requirements, and active maintenance status.

---

## 2. Repository baseline

The repository scaffold, governance, CI pipeline, and `hello-compose` contract demo are complete.  
The following are available and validated:

- `make validate` — repository contract checks (YAML lint, ShellCheck, schema validation, Compose config)
- `make smoke DEMO=<name>` — end-to-end smoke test
- `scripts/create-demo.sh <name>` — bootstrap a new demo from the template
- `schemas/demo.schema.json` — manifest schema with `requirements`, `ports`, and `validation` sections
- `agents/` — 9 agent specifications (Supervisor, Architect, Designer, Compose, Script, Docs, Security, Test, Maintenance)
- `templates/common/` — shared helpers: `healthcheck.sh`, `wait-for-service.sh`, `logging.sh`

---

## 3. Demo roadmap

### Priority tier 1 — High commercial impact, low/medium complexity, fully on-premise

| # | Demo name | Capability | Base repository | Est. effort |
|---|---|---|---|---|
| 1 | `private-rag` | Enterprise Knowledge Assistant | [Open WebUI + Ollama](https://github.com/open-webui/open-webui) + [RAGapp](https://github.com/ragapp/ragapp) | M |
| 2 | `talk-to-data` | Natural language → SQL + visualisation | [GenAI Data Chat](https://github.com/Azure-Samples/azure-search-openai-demo) / [LIDA](https://github.com/microsoft/lida) | S |
| 3 | `speech-intelligence` | Transcription, language detection, action generation | [Whisper](https://github.com/openai/whisper) + [WhisperLive](https://github.com/collabora/WhisperLive) | S |
| 4 | `supply-chain-agent` | Multi-agent supply chain finance analysis | [Multi-Agent Supply Chain Finance Platform](https://github.com/ranfysvalle02/mlt-agnt-supply-chain-fin) | M |

### Priority tier 2 — High commercial impact, medium complexity

| # | Demo name | Capability | Base repository | Est. effort |
|---|---|---|---|---|
| 5 | `visual-inspection` | Computer vision quality audit | [VIO](https://github.com/octo-technology/VIO) / [visual_inspection](https://github.com/karakurai/visual_inspection) | M |
| 6 | `agentic-dev` | Agentic software engineering lifecycle | [docker/compose-for-agents](https://github.com/docker/compose-for-agents) + [LangGraph](https://github.com/langchain-ai/langgraph) | M |
| 7 | `context-fabric` | Industrial operational context + semantic normalisation | [ContextFabric AI](https://github.com/shubhamdusane/context-fabric) + Ollama | M |

### Priority tier 3 — High impact, higher complexity or partial GPU requirement

| # | Demo name | Capability | Base repository | Est. effort |
|---|---|---|---|---|
| 8 | `embodied-ai` | Robot manipulation in simulation | [ManiSkill](https://github.com/haosulab/ManiSkill) / [LeRobot](https://github.com/huggingface/lerobot) | L |
| 9 | `content-creator` | Script → storyboard → short video | [short-video-maker](https://github.com/gyoridavid/short-video-maker) | M |
| 10 | `virtual-human` | 3D conversational avatar with lip-sync | [IAcine-3D-Avatar](https://github.com/Yacine-Mekideche/IAcine-3D-Avatar) | L |

### Priority tier 4 — Vertical / research-oriented

| # | Demo name | Capability | Base repository | Est. effort |
|---|---|---|---|---|
| 11 | `drug-discovery` | Molecular property prediction and QSAR | [AI for Drug Discovery](https://github.com/mayk-it/AI-drug-discovery) / [DeepChem](https://github.com/deepchem/deepchem) | L |
| 12 | `software-modernisation` | Legacy codebase assessment and incremental refactoring | [OpenRewrite](https://github.com/openrewrite/rewrite) + LangGraph | L |
| 13 | `video-intelligence` | Video Q&A, chapter generation, semantic search | [VideoAgent](https://github.com/YueLu0116/VideoAgent) | M |
| 14 | `agents-4-everything` | Multi-agent collaboration showcase | [AutoGen](https://github.com/microsoft/autogen) / [CrewAI](https://github.com/crewAIInc/crewAI) | S |
| 15 | `finance-agent` | Financial research assistant on public data | [FinanceAgent](https://github.com/finance-agent/FinanceAgent) | M |

_Effort scale: S = 1–3 days · M = 3–7 days · L = 7–14 days (single developer, assuming upstream repo is functional)_

---

## 4. Per-demo specification

### 4.1 `private-rag` — Enterprise Knowledge Assistant

**Scenario:** Upload internal documentation (PDF, DOCX, HTML). Chat against it with cited answers, permission-filtered retrieval, and full observability. No data leaves the host.

**Stack:**
- [Open WebUI](https://github.com/open-webui/open-webui) (114k+ stars, Docker-first, built-in RAG pipeline)
- [Ollama](https://github.com/ollama/ollama) — local model serving (Llama 3, Mistral, Gemma 3)
- [Qdrant](https://github.com/qdrant/qdrant) — vector store
- [Tika](https://github.com/apache/tika) or Unstructured — document ingestion

**Alternatives:**
- [Dify](https://github.com/langgenius/dify) — full LLM platform with visual workflow; heavier but more enterprise-complete
- [RAGFlow](https://github.com/infiniflow/ragflow) — RAG + Agent, full-stack, Docker microservices
- [Azure Search OpenAI Demo](https://github.com/Azure-Samples/azure-search-openai-demo) — for Azure-target demos only; requires Azure services

**Pre-flight checks:**
- [ ] Ollama image license: MIT ✓
- [ ] Open WebUI license: MIT ✓
- [ ] Qdrant license: Apache-2.0 ✓
- [ ] No external API call required at demo time: confirm with `--offline` model pull pre-seeded
- [ ] GPU: optional (CPU inference with small models is demo-viable; Llama 3.2 3B on CPU)

**Hardware baseline:** 8 GB RAM, 20 GB disk, no GPU required for a 3B model

---

### 4.2 `talk-to-data` — Natural Language to Data

**Scenario:** Upload a CSV or connect to a local PostgreSQL database. Ask "Show me sales by region for Q3 and highlight outliers." Receive SQL, result table, and an auto-generated chart.

**Stack:**
- [Vanna.AI](https://github.com/vanna-ai/vanna) — text-to-SQL with RAG over schema; self-hostable, Flask UI included
- [LIDA](https://github.com/microsoft/lida) (Microsoft) — LLM-driven visualisation and infographic generation
- PostgreSQL + sample dataset (included as fixture)
- Ollama — local LLM backend

**Alternative:**
- [GenAI Data Chat](https://github.com/Azure-Samples/azure-search-openai-demo) variant for text-to-SQL

**Pre-flight checks:**
- [ ] Vanna license: MIT ✓
- [ ] LIDA license: MIT ✓
- [ ] Dataset: synthetic, included in fixtures/

---

### 4.3 `speech-intelligence` — Meeting and Speech Intelligence

**Scenario:** Drop an MP3/WAV recording. The demo transcribes it locally, detects language, generates a structured summary, extracts action items and owners, and produces a formatted output.

**Stack:**
- [faster-whisper](https://github.com/SYSTRAN/faster-whisper) — optimised Whisper inference (CTranslate2), CPU and GPU
- [WhisperLive](https://github.com/collabora/WhisperLive) — real-time streaming variant if live microphone demo is needed
- Ollama (Llama 3 / Mistral) — summary and action extraction
- FastAPI + Gradio — API and UI

**Pre-flight checks:**
- [ ] faster-whisper license: MIT ✓
- [ ] Whisper model weights: MIT ✓ (openai/whisper)
- [ ] No audio sent externally: confirm network policy
- [ ] GPU: optional (tiny/base model on CPU for demo)

---

### 4.4 `supply-chain-agent` — Supply Chain Multi-Agent

**Scenario:** Upload an invoice and a purchase order. Six specialised agents analyse the documents, detect anomalies, score supplier risk, calculate working capital impact, and produce a management summary with an approval or escalation recommendation.

**Stack:**
- [LangGraph](https://github.com/langchain-ai/langgraph) — stateful multi-agent orchestration (leads for production-grade stateful workflows in 2026)
- Ollama — local LLM
- Gradio — results interface
- PostgreSQL — agent memory and audit log

**Alternative orchestrators:**
- [CrewAI](https://github.com/crewAIInc/crewAI) — role-based, faster PoC setup
- [AutoGen / Microsoft Agent Framework](https://github.com/microsoft/autogen) — merged with Semantic Kernel; GA Q1 2026; preferred for Microsoft-aligned environments

**Pre-flight checks:**
- [ ] LangGraph license: MIT ✓
- [ ] CrewAI license: MIT ✓
- [ ] No financial data committed; demo uses synthetic fixtures

---

### 4.5 `visual-inspection` — Computer Vision Quality Audit

**Scenario:** Webcam or sample images of industrial parts. The demo detects surface defects, classifies the finding, scores confidence, and generates an automated quality event with image, label, and metadata.

**Stack option A — modular edge-to-hub:**
- [VIO](https://github.com/octo-technology/VIO) — containerised framework: edge component, model serving, orchestration, monitoring hub
- Custom anomaly detection model (Padim or PatchCore from [Anomalib](https://github.com/openvinotoolkit/anomalib))

**Stack option B — rapid convention demo:**
- [visual_inspection](https://github.com/karakurai/visual_inspection) — Python app, webcam-ready, CPU-only, no GPU required
- Gradio — live UI

**Pre-flight checks:**
- [ ] Anomalib license: Apache-2.0 ✓
- [ ] VIO license: Apache-2.0 ✓ (verify on current repo)
- [ ] Model weights: use a publicly available pre-trained checkpoint or retrain on synthetic data
- [ ] GPU: not required for VIO/visual_inspection demo at standard resolution

---

### 4.6 `agentic-dev` — Agentic Software Engineering

**Scenario:** Open an intentionally broken GitHub Issue (failing test + bug description). An agent reads the issue, analyses the codebase, proposes a fix plan, implements a targeted change, runs the tests, and opens a draft Pull Request.

**Stack:**
- [docker/compose-for-agents](https://github.com/docker/compose-for-agents) — Docker's official compose-native agent orchestration: LangGraph + CrewAI + MCP integrations, single Compose file
- [LangGraph](https://github.com/langchain-ai/langgraph) — workflow control for stateful code-analysis agent
- Local sandbox repository (fixtures included in demo)
- Ollama or configurable LLM endpoint

**Note:** This demo is directly applicable to any project that uses issue-based development and AGENTS.md-style governance, and serves as a meta-demonstration of the repository's own operating model.

---

### 4.7 `context-fabric` — Industrial Context Fabric

**Scenario:** Import heterogeneous industrial tags (PLC, SCADA historian format). The demo normalises them semantically, scores data quality, builds a structured operational context, and makes it queryable via a local LLM copilot.

**Stack:**
- [ContextFabric AI](https://github.com/shubhamdusane/context-fabric) — multi-agent prototype: semantic normalisation, data-quality scoring, SQLite memory, Ollama/OpenAI compatible
- Ollama — local LLM
- Sample PLC/historian tag dataset (synthetic fixtures)

**Pre-flight checks:**
- [ ] License: verify on current repo state
- [ ] No real OT data committed

---

### 4.8 `embodied-ai` — Embodied AI Lab (simulation)

**Scenario:** A simulated robot arm receives a natural-language instruction ("pick the red block and place it on the tray") and completes the manipulation task. The demo shows the sim environment, the agent's planning steps, and the execution result.

**Stack:**
- [ManiSkill](https://github.com/haosulab/ManiSkill) — GPU-parallelised robot manipulation benchmark; CPU mode available for small tasks; RSS 2025 paper
- [LeRobot](https://github.com/huggingface/lerobot) — imitation learning + RL; Docker publish pipeline; EnvHub for custom environments
- [Genesis](https://github.com/Genesis-Embodied-AI/Genesis) — alternative physics simulation platform

**Pre-flight checks:**
- [ ] ManiSkill license: MIT ✓
- [ ] LeRobot license: Apache-2.0 ✓
- [ ] GPU: recommended (NVIDIA); CPU fallback available with reduced task complexity
- [ ] Hardware: 16 GB RAM, 8 GB VRAM recommended; 8 GB RAM + CPU only for minimal demo

---

## 5. Technical stack decisions

### LLM serving — inference tiers

Five tiers are supported per demo, selected by `INFERENCE_BACKEND` + `GPU_TIER` at deploy time.  
Each tier is declared in `package.yaml → spec.inference`.

| Tier | `INFERENCE_BACKEND` | `GPU_TIER` | Backend | Default model | Hardware |
|---|---|---|---|---|---|
| Local CPU | `ollama` | `cpu` | [Ollama](https://github.com/ollama/ollama) | `mistral:7b-instruct-q4_K_M` | CPU, ~8 GB RAM |
| Local GPU 16 GB | `ollama` | `rtx5060ti` | Ollama | `mistral-nemo:12b-instruct-2407-q4_K_M` | RTX 5060 Ti |
| Local GPU 24 GB | `ollama` | `rtx3090` | Ollama | `mistral-small3.1:24b-instruct-2503-q4_K_M` | RTX 3090 |
| vLLM + CPU offload | `vllm` | `rtx5060ti` | [vLLM](https://github.com/vllm-project/vllm) `--cpu-offload-gb 8` | `mistralai/Mistral-Small-3.1-24B-Instruct-2503` | RTX 5060 Ti + 32 GB RAM |
| GPU-as-a-Service API | `api` | _(none)_ | OpenAI-compatible endpoint | `mistral-small-latest` (Mistral AI) | No GPU — API key only |

**vLLM CPU offload** enables running 24B models on a 16 GB GPU by paging model layers to system RAM (`--cpu-offload-gb`). Latency increases proportionally to offloaded layers; suitable for batch demos, not interactive streaming.

**GPU-as-a-Service API** tier uses an external OpenAI-compatible endpoint (Mistral AI, RunPod Serverless, Together AI). No local GPU required; cost model shifts from hourly rental to per-token billing. Preferred when demo traffic is low or GPU instances are unavailable.

Supported API providers (configured in `spec.inference.api.provider`):

| Provider | Base URL | Key secret |
|---|---|---|
| `mistral` | `https://api.mistral.ai/v1` | `MISTRAL_API_KEY` |
| `runpod-serverless` | `https://api.runpod.ai/v2/<endpoint-id>/openai/v1` | `RUNPOD_API_KEY` |
| `together` | `https://api.together.xyz/v1` | `TOGETHER_API_KEY` |
| `openai-compatible` | configured per `baseUrl` | configured per `keySecret` |

Demo-specific overrides (non-Mistral defaults):

| Demo | Ollama models (5060ti / 3090) | vLLM model | API model |
|---|---|---|---|
| agentic-dev, software-modernisation | `qwen2.5-coder:7b` / `14b` | `Qwen/Qwen2.5-Coder-14B-Instruct` | `codestral-latest` |
| video-intelligence | `llava:7b` / `13b-vicuna` | `llava-hf/llava-v1.6-vicuna-13b-hf` | `pixtral-large-latest` |

### Agent orchestration

| Use case | Choice | Rationale |
|---|---|---|
| Stateful, complex workflows | LangGraph | Leads for production in 2026; explicit graph control |
| Role-based, fast PoC | CrewAI | Minimal boilerplate; YAML-defined roles |
| Microsoft ecosystem | Microsoft Agent Framework (AutoGen + SK) | GA Q1 2026; C#/Python/Java |
| Docker-native agents | docker/compose-for-agents | Compose-first; MCP integration |

### Vector store (default)

[Qdrant](https://github.com/qdrant/qdrant) — Apache-2.0, Docker image, gRPC + REST, no external dependency.

### UI

[Gradio](https://github.com/gradio-app/gradio) for rapid demos; [Open WebUI](https://github.com/open-webui/open-webui) where a full chat interface is needed.

---

## 6. Development workflow per demo

```
1.  Open Issue (type: demo:new) with all 10 required fields
2.  Confirm acceptance criteria with a maintainer
3.  Create branch: feat/<issue-number>-<demo-name>
4.  Run: ./scripts/create-demo.sh <demo-name>
5.  Fill demos/<name>/demo.yaml
6.  Implement compose.yaml (Compose Engineer checklist)
7.  Implement demo.sh, test.sh, reset.sh (Script Engineer checklist)
8.  Seed fixtures under demos/<name>/fixtures/
9.  Write demos/<name>/README.md (Documentation checklist)
10. Run: make validate && make smoke DEMO=<name>
11. Open Pull Request with evidence and Agent disclosure
12. Human maintainer review and squash merge
```

---

## 7. Pre-inclusion checklist (per upstream repository)

Before building a demo on top of any upstream repository, confirm all of the following:

| Check | How |
|---|---|
| Source license is compatible with Apache-2.0 | Check LICENSE; escalate GPL/AGPL/SSPL/proprietary |
| Model/weight license permits commercial use | Check model card on Hugging Face or model repo |
| No mandatory external API call at demo runtime | Test with network blocked (`--network none`) |
| No real or sensitive data committed | Use synthetic fixtures only |
| GPU requirement documented in `demo.yaml` | Set `requirements.gpuRequired` accordingly |
| Upstream repo is actively maintained | Check last commit date; open issues/PRs ratio |
| Trivy scan: no HIGH/CRITICAL unfixed CVEs | Run before adding image to compose.yaml |

---

## 8. Quality gates (all demos)

| Gate | Tool | Threshold |
|---|---|---|
| YAML lint | yamllint | 0 errors |
| Shell lint | shellcheck | 0 warnings |
| Schema validation | check-jsonschema | 0 errors |
| Compose config | docker compose config | exit 0 |
| Secret scan | Gitleaks | 0 findings |
| Image CVE scan | Trivy | 0 HIGH/CRITICAL unfixed |
| Smoke test | make smoke | exit 0 |
| Idempotency | reset + re-run smoke | both exit 0 |
| Documentation | README present with all 9 sections | manual review |

---

## 9. Suggested build sequence

Given the effort/impact analysis, the recommended build sequence is:

```
Sprint 1   private-rag          (highest impact, foundational stack)
Sprint 2   speech-intelligence  (fast, standalone, zero GPU)
Sprint 2   talk-to-data         (fast, reuses Ollama from Sprint 1)
Sprint 3   supply-chain-agent   (multi-agent, builds on LangGraph)
Sprint 4   visual-inspection    (hardware-free with sample images)
Sprint 4   agentic-dev          (meta-demo; reuses repo conventions)
Sprint 5   context-fabric       (industrial vertical)
Sprint 6   embodied-ai          (GPU-dependent; schedule last)
```

Demos in Sprint 2 can be built in parallel by two independent contributors.

---

## 10. Open questions and decisions required

| # | Question | Owner | Status |
|---|---|---|---|
| 1 | Default LLM model family | Maintainer | **Resolved — see below** |
| 2 | GPU availability in CI smoke environment | Maintainer | **Resolved — see below** |
| 3 | ContextFabric AI license status (verify current repo) | Security Reviewer | Open |
| 4 | VIO repo maintenance status (last commit check needed) | Security Reviewer | Open |
| 5 | Synthetic dataset design for `supply-chain-agent` and `visual-inspection` | Demo Designer | Open |
| 6 | Azure-target variant of `private-rag` — separate demo or configuration flag? | Repository Architect | Open |

### Resolved decisions

**#1 — Default LLM model family: European models preferred**

European-origin models are the default for all demos. The primary family is **Mistral AI** (Paris, France), available on Ollama and under Apache-2.0 / Mistral Research License.

| Use case | Default model | vRAM | CPU fallback |
|---|---|---|---|
| RAG, Q&A, reasoning | Mistral Small 3.1 24B | 16 GB (Q4_K_M: ~13 GB) | Mistral 7B Q4_K_M (~4 GB) |
| Code reasoning | Mistral Small 3.1 24B | 16 GB | Mistral 7B Q4_K_M |
| Balanced (12 GB GPU) | Mistral NeMo 12B | ~7 GB (Q4_K_M) | Mistral 7B Q4_K_M |
| CPU-only demos | Mistral 7B Q4_K_M | N/A | Mistral 7B Q4_K_M |

Other European models available as alternatives:
- **EuroLLM** (EU-funded, multilingual European languages)
- **CroissantLLM** (French, CentraleSupélec)
- **LeoLM** (German, Hessian AI)

Non-European models (Llama, Qwen, Gemma) remain listed as alternatives for benchmarking and future use.

**#2 — GPU availability: remote runner with RTX 3090 and RTX 5060 Ti**

A remote GPU runner is available with two selectable GPUs:

| GPU | Architecture | vRAM | CUDA | Best for |
|---|---|---|---|---|
| NVIDIA RTX 3090 | Ampere (GA102) | 24 GB GDDR6X | 8.6 | Large models (Mistral Small 24B FP16, Mixtral 8x7B); multi-agent demos; ManiSkill parallel simulation |
| NVIDIA RTX 5060 Ti | Blackwell (GB206) | 16 GB GDDR7 | 12.8+ | Fast inference with Mistral NeMo 12B or Mistral 7B; high memory bandwidth for vision tasks |

**Model assignment by GPU:**

| Model | RTX 3090 (24 GB) | RTX 5060 Ti (16 GB) |
|---|---|---|
| Mistral Small 3.1 24B Q4_K_M (~13 GB) | ✓ optimal | ✓ |
| Mistral Small 3.1 24B FP16 (~46 GB) | ✗ (OOM) | ✗ (OOM) |
| Mistral NeMo 12B Q4_K_M (~7 GB) | ✓ | ✓ fast (GDDR7) |
| Mistral 7B Q4_K_M (~4 GB) | ✓ | ✓ very fast |
| LLaVA 7B Q4_K_M + context (~5 GB) | ✓ | ✓ |
| Mixtral 8x7B Q4_K_M (~26 GB) | ✗ (OOM) | ✗ (OOM) |
| ManiSkill GPU parallel (embodied-ai) | ✓ primary | ✓ (fewer envs) |

**GPU selection guidance:**
- Use **RTX 3090** for: `embodied-ai` (GPU-parallel simulation), `video-intelligence` (LLaVA large context), any demo requiring Mistral Small 24B
- Use **RTX 5060 Ti** for: standard RAG and agent demos (faster memory bandwidth improves token throughput); `visual-inspection` (GDDR7 benefits real-time inference)
