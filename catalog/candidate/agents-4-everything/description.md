# agents-4-everything — Multi-Agent Collaboration Showcase

## Description

A supervisor agent decomposes a complex task (research, technical analysis, governance review) and delegates to three specialised sub-agents. Each agent operates independently, produces a structured output, and the supervisor consolidates the results into a final report. The demo illustrates multi-agent collaboration, role assignment, inter-agent communication, and human-in-the-loop oversight.

## Use case / Scenario

A user poses a complex question: "Assess the feasibility of deploying a private LLM for customer service." A supervisor assigns the task to three agents: a research agent (market landscape and open-source options), a technical agent (infrastructure requirements and cost model), and a governance agent (data privacy, compliance, and risk). The supervisor consolidates the three reports and presents a structured recommendation with an approval gate.

## Provenance

| Field | Value |
|---|---|
| Category | agentic-ai |
| Primary (stateful workflow) | [langchain-ai/langgraph](https://github.com/langchain-ai/langgraph) |
| Alternative (role-based) | [crewAIInc/crewAI](https://github.com/crewAIInc/crewAI) |
| Alternative (Microsoft) | [microsoft/autogen](https://github.com/microsoft/autogen) (merged with Semantic Kernel; GA Q1 2026) |
| LLM serving | [ollama/ollama](https://github.com/ollama/ollama) |
| License (LangGraph) | MIT |
| License (CrewAI) | MIT |
| Last verified | 2026-10-01 |

## Key capabilities

- Supervisor + 3 specialist agent topology
- Each agent has a distinct system prompt, tool set, and output schema
- Human-in-the-loop checkpoint: review consolidated report before finalisation
- Full execution trace: per-agent reasoning steps, inputs, and outputs are logged
- Configurable: LangGraph (explicit control), CrewAI (YAML-defined roles), or AutoGen (conversation-based)
- Gradio interface showing live agent status and inter-agent messages

## Framework selection guide

| Framework | Best for | Notes |
|---|---|---|
| LangGraph | Stateful, complex, production-grade workflows | Explicit graph; most control |
| CrewAI | Fast PoC, role-based | Minimal boilerplate; YAML roles |
| AutoGen / MS Agent Framework | Microsoft ecosystem; conversational agents | GA Q1 2026; C#/Python/Java |

## Related demos

- `supply-chain-agent` — same multi-agent pattern; domain-specific (finance)
- `agentic-dev` — same LangGraph topology; domain-specific (software engineering)
