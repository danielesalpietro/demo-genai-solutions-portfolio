# supply-chain-agent — Supply Chain Multi-Agent

## Description

Upload an invoice and a purchase order. Six specialised agents collaborate in a LangGraph workflow: they parse the documents, detect anomalies, score supplier risk, calculate working capital impact, produce a management summary, and apply a governance validation layer. The final output is an approval or escalation recommendation with full audit trail.

## Use case / Scenario

A finance or procurement team uploads a supplier invoice that contains discrepancies against the corresponding PO. The agent pipeline detects the mismatch, flags the supplier's risk score, calculates the cash-flow impact, and escalates with a structured recommendation. The demo shows multi-agent reasoning, inter-agent handoff, and human-in-the-loop approval.

## Provenance

| Field | Value |
|---|---|
| Category | enterprise-ai / agentic-ai |
| Primary repository | [ranfysvalle02/mlt-agnt-supply-chain-fin](https://github.com/ranfysvalle02/mlt-agnt-supply-chain-fin) |
| Orchestration | [langchain-ai/langgraph](https://github.com/langchain-ai/langgraph) |
| LLM serving | [ollama/ollama](https://github.com/ollama/ollama) |
| UI | [gradio-app/gradio](https://github.com/gradio-app/gradio) |
| Alternative orchestrator | [crewAIInc/crewAI](https://github.com/crewAIInc/crewAI) |
| License (LangGraph) | MIT |
| License (CrewAI) | MIT |
| Last verified | 2026-10-01 |

## Key capabilities

- Six-agent pipeline: document parser, anomaly detector, supplier risk scorer, working capital analyser, summary writer, governance validator
- Stateful workflow with explicit human-in-the-loop approval step
- Audit log of all agent decisions and inter-agent handoffs
- Gradio interface: document upload, live agent status, final recommendation
- Synthetic invoice and PO fixtures included; no real financial data

## Related demos

- `finance-agent` — broader financial research on public data
- `agentic-dev` — same LangGraph orchestration pattern applied to software engineering
