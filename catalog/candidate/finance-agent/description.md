# finance-agent — Financial Research Assistant

## Description

A research agent that answers complex questions about publicly available financial data: annual reports, balance sheets, income statements, and public market indices. The agent retrieves the relevant documents, extracts key metrics, performs calculations, and presents a cited, structured answer. Positioned as a financial research tool, not an execution agent.

## Use case / Scenario

A user asks: "Compare the EBITDA margin and debt-to-equity ratio of three publicly listed companies in the industrial automation sector for FY2024." The agent retrieves the relevant public filings (or uses pre-loaded fixtures), extracts the figures, computes the ratios, generates a comparison table, and cites the source pages. The demo illustrates grounded financial reasoning with full auditability.

> **Important:** This demo is scoped as a research and analysis assistant. It does not execute, recommend, or simulate financial transactions. See `policies/security-policy.md` for relevant escalation criteria.

## Provenance

| Field | Value |
|---|---|
| Category | enterprise-ai / finance |
| Primary framework | [finance-agent/FinanceAgent](https://github.com/finance-agent/FinanceAgent) |
| Benchmark reference | [vals-ai/finance-bench](https://github.com/vals-ai/finance-bench) |
| LLM serving | [ollama/ollama](https://github.com/ollama/ollama) |
| Document retrieval | RAG over pre-loaded public filings (PDF fixtures) |
| License | To be verified on current FinanceAgent repo state |
| Last verified | 2026-10-01 |

## Key capabilities

- Document-grounded financial Q&A with inline citations
- Ratio computation: EBITDA, P/E, debt-to-equity, liquidity ratios
- Comparison tables across multiple companies and periods
- Pre-loaded public filing fixtures (annual reports, 10-K, public press releases)
- No real-time market data feed; no brokerage API integration
- Full answer audit trail: source document, page, extracted value

## Related demos

- `private-rag` — same RAG stack; domain-agnostic document Q&A
- `supply-chain-agent` — agent reasoning over financial documents in a procurement context
