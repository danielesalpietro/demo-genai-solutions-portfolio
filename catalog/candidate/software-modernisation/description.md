# software-modernisation — Software Modernisation Agent

## Description

A legacy application with outdated dependencies, deprecated APIs, and technical debt is the input. A human-in-the-loop agentic pipeline produces a structured assessment, a prioritised modernisation plan, targeted code transformations using OpenRewrite, a regression test run, and a Pull Request with the first increment of changes. The demo illustrates controlled, auditable modernisation rather than full autonomous rewriting.

## Use case / Scenario

A development team provides a Spring Boot 2.x Java application or a Python 3.8 Flask application. The demo produces: (1) a dependency and API deprecation report, (2) a prioritised modernisation plan, (3) a targeted automated refactoring via OpenRewrite (e.g., migrate to Spring Boot 3.x), (4) test execution confirming no regressions, (5) a draft PR with the diff and agent disclosure. The human reviews and approves before merge.

## Provenance

| Field | Value |
|---|---|
| Category | agentic-ai / developer-tools |
| Code transformation | [openrewrite/rewrite](https://github.com/openrewrite/rewrite) |
| Agent orchestration | [langchain-ai/langgraph](https://github.com/langchain-ai/langgraph) |
| LLM serving | [ollama/ollama](https://github.com/ollama/ollama) |
| License (OpenRewrite) | Apache-2.0 |
| License (LangGraph) | MIT |
| Last verified | 2026-10-01 |

## Key capabilities

- Automated dependency audit and CVE mapping
- OpenRewrite: recipes for Spring Boot 2→3, Java 8→17/21, dependency upgrades, API migration
- LLM-generated modernisation narrative and plan
- Human-in-the-loop: agent presents plan and awaits approval before executing transformations
- Test execution and regression report
- PR with diff, test results, and agent disclosure section

## Related demos

- `agentic-dev` — same LangGraph workflow pattern; complementary scope
- `supply-chain-agent` — multi-agent approval workflow pattern
