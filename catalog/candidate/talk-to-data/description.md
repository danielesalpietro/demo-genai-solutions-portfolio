# talk-to-data — Natural Language to Data

## Description

Upload a CSV file or point to a local PostgreSQL database and ask questions in plain language. The demo generates a controlled SQL plan, executes the query, returns a result table, and auto-generates a chart or summary visualisation. All processing runs locally.

## Use case / Scenario

A user asks: "Show me the top 10 products by revenue for Q3 and highlight the ones below margin target." The demo translates the question into SQL using schema-aware RAG, executes the query against a local database, and renders a table and bar chart with an explanatory summary.

## Provenance

| Field | Value |
|---|---|
| Category | enterprise-ai / generative-ai |
| Text-to-SQL | [vanna-ai/vanna](https://github.com/vanna-ai/vanna) |
| Visualisation | [microsoft/lida](https://github.com/microsoft/lida) |
| LLM serving | [ollama/ollama](https://github.com/ollama/ollama) |
| Database | PostgreSQL 16 (local, synthetic fixtures) |
| License (Vanna) | MIT |
| License (LIDA) | MIT |
| Last verified | 2026-10-01 |

## Key capabilities

- Schema-aware text-to-SQL via RAG over database schema and example queries
- Controlled query plan visible to the user before execution
- Result table + auto-generated chart (bar, line, scatter, pie)
- LIDA: automatic data summary, goal suggestion, and infographic generation
- Synthetic dataset included as fixtures (no real business data)

## Related demos

- `private-rag` — same Ollama backend; unstructured document retrieval
- `finance-agent` — structured financial data analysis with agent reasoning
