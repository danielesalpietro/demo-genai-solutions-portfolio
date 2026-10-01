# agentic-dev — Agentic Software Engineering

## Description

An intentionally broken local repository (failing test + described bug) is the input. A LangGraph-orchestrated agent reads the GitHub Issue, analyses the codebase, proposes a fix plan, implements a targeted change, runs the tests, and opens a draft Pull Request. The full Software Development Lifecycle is demonstrated end-to-end inside a sandboxed Docker environment.

## Use case / Scenario

A developer opens an Issue: "The price calculation ignores VAT for EU customers." The agent reads the Issue, inspects the relevant source file, generates a fix, runs the test suite to confirm the regression is resolved, and opens a draft PR with the diff, test results, and agent disclosure. The developer reviews and merges.

## Provenance

| Field | Value |
|---|---|
| Category | agentic-ai |
| Compose orchestration | [docker/compose-for-agents](https://github.com/docker/compose-for-agents) |
| Agent orchestration | [langchain-ai/langgraph](https://github.com/langchain-ai/langgraph) |
| LLM serving | [ollama/ollama](https://github.com/ollama/ollama) |
| Alternative | [crewAIInc/crewAI](https://github.com/crewAIInc/crewAI) |
| License (compose-for-agents) | Apache-2.0 |
| License (LangGraph) | MIT |
| Last verified | 2026-10-01 |

## Key capabilities

- Issue-to-PR in a fully sandboxed, reproducible environment
- LangGraph stateful workflow: read issue → inspect code → plan → implement → test → PR
- Human-in-the-loop review step before PR creation
- Sandboxed execution: agent cannot affect host filesystem
- docker/compose-for-agents: Compose-native agent topology with MCP integration
- Synthetic target repository included as fixture (Python; isolated)

## Meta note

This demo is itself built using the same governance model it demonstrates (issue-linked branches, agent disclosure in PRs, human review). It can serve as a self-referential illustration of the repository's operating model.

## Related demos

- `supply-chain-agent` — same LangGraph pattern applied to finance document analysis
- `software-modernisation` — extension to legacy codebase refactoring
