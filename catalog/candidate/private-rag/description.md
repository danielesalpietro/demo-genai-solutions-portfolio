# private-rag — Enterprise Knowledge Assistant

## Description

Upload internal documents (PDF, DOCX, HTML, Markdown) and interrogate them via a chat interface. Answers are grounded in the source material with inline citations. All processing — model inference, vector indexing, and retrieval — runs on the local host; no data leaves the machine.

## Use case / Scenario

A user uploads a set of technical specifications, policy documents, or operational procedures. They ask natural-language questions and receive cited answers. Follow-up questions maintain conversation context. The demo illustrates Retrieval-Augmented Generation (RAG) with permission-filtered retrieval, observability, and zero external API dependency.

## Provenance

| Field | Value |
|---|---|
| Category | enterprise-ai / generative-ai |
| Primary repository | [open-webui/open-webui](https://github.com/open-webui/open-webui) |
| LLM serving | [ollama/ollama](https://github.com/ollama/ollama) |
| Vector store | [qdrant/qdrant](https://github.com/qdrant/qdrant) |
| Document ingestion | [Unstructured](https://github.com/Unstructured-IO/unstructured) or [Apache Tika](https://github.com/apache/tika) |
| Alternative | [infiniflow/ragflow](https://github.com/infiniflow/ragflow) · [langgenius/dify](https://github.com/langgenius/dify) |
| Cloud-target alternative | [Azure-Samples/azure-search-openai-demo](https://github.com/Azure-Samples/azure-search-openai-demo) |
| License (Open WebUI) | MIT |
| License (Ollama) | MIT |
| License (Qdrant) | Apache-2.0 |
| Last verified | 2026-10-01 |

## Key capabilities

- Document ingestion: PDF, DOCX, HTML, Markdown, plain text
- Multi-turn chat with source citations
- Vector-based semantic retrieval (Qdrant)
- Local LLM serving (Ollama): Llama 3.1 8B, Mistral 7B, Gemma 3
- Offline-capable after initial model pull
- Open WebUI: user management, model selection, conversation history

## Related demos

- `talk-to-data` — extends RAG to structured data and SQL
- `context-fabric` — applies the same RAG pattern to industrial operational data
