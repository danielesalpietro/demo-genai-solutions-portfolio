# embodied-ai — Embodied AI Lab

## Description

A simulated robot arm receives a natural-language instruction ("pick the red block and place it on the tray") and completes the manipulation task in a physics simulation environment. The demo shows the simulation environment, the agent's reasoning steps, the policy execution, and the task outcome. No physical hardware is required.

## Use case / Scenario

An AI researcher or engineer launches the simulation environment. A user types a task instruction in natural language. The demo shows: (1) the language instruction being translated to a structured task plan, (2) the robot policy executing the plan in the simulated environment, (3) the task completion or failure with an explanation. An optional step shows sim-to-real transfer preparation.

## Provenance

| Field | Value |
|---|---|
| Category | physical-ai / embodied-ai |
| Primary framework | [haosulab/ManiSkill](https://github.com/haosulab/ManiSkill) |
| Alternative | [huggingface/lerobot](https://github.com/huggingface/lerobot) |
| Physics simulation | SAPIEN (ManiSkill) · MuJoCo (LeRobot / Gymnasium) |
| Additional | [Genesis-Embodied-AI/Genesis](https://github.com/Genesis-Embodied-AI/Genesis) |
| License (ManiSkill) | MIT |
| License (LeRobot) | Apache-2.0 |
| Last verified | 2026-10-01 |

## Key capabilities

**ManiSkill:**
- GPU-parallelised simulation: 30 000+ FPS on a single RTX 4090 for data collection
- Support for RL (PPO, SAC, TD-MPC2) and IL (Behaviour Cloning, Diffusion Policy) baselines
- Sim2real examples; RSS 2025 paper
- ICLR 2025: ManiSkill-HAB Home Assistant Benchmark

**LeRobot:**
- Teleop, imitation learning, and RL pipelines
- EnvHub: load custom simulation environments from Hugging Face Hub in one line
- Docker publish pipeline; active community; hardware robot kits available (SO-100, Koch)

## Related demos

- `virtual-human` — natural language instruction interface (shared LLM stack)
- `agentic-dev` — same LangGraph reasoning pattern for task decomposition
