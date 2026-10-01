# context-fabric — Industrial Context Fabric

## Description

Import heterogeneous industrial tags from PLC, SCADA, and historian data sources in different formats and naming conventions. A multi-agent pipeline normalises them semantically, scores data quality, maps tags to a unified operational ontology, builds a structured context document, and makes it queryable via a local LLM copilot.

## Use case / Scenario

An operator imports a CSV export of 500 historian tags from two different DCS systems with inconsistent naming. The demo normalises the tags, identifies duplicates and quality issues, maps each tag to a semantic category (temperature, pressure, flow, status), scores data completeness, and enables natural-language queries such as "Which pressure tags in reactor loop 3 have more than 5% missing data in the last month?"

## Provenance

| Field | Value |
|---|---|
| Category | enterprise-ai / industrial-ai |
| Primary repository | [shubhamdusane/context-fabric](https://github.com/shubhamdusane/context-fabric) |
| LLM serving | [ollama/ollama](https://github.com/ollama/ollama) |
| Memory / storage | SQLite (embedded) |
| License | To be verified on current repo state |
| Last verified | 2026-10-01 |

## Key capabilities

- Ingestion of heterogeneous industrial tag formats (CSV, JSON, OPC-UA tag list)
- Semantic normalisation via LLM with structured output
- Data-quality scoring: completeness, consistency, freshness
- Human-in-the-loop validation of normalisation results
- Unified operational context queryable via natural language
- Ollama-compatible: works with Llama 3, Mistral, or any quantised model

## Related demos

- `private-rag` — same Ollama backend; context-fabric feeds a RAG knowledge base
- `visual-inspection` — quality events from visual inspection can enrich the operational context
