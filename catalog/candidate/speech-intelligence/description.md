# speech-intelligence — Meeting and Speech Intelligence

## Description

Drop an audio or video file (MP3, WAV, MP4). The demo transcribes it locally, detects the language, generates a structured meeting summary with topics and key decisions, extracts action items with owners, and produces a formatted output document. All audio data remains on the host.

## Use case / Scenario

A user uploads a 45-minute meeting recording. The demo produces: a timestamped transcript, automatic language identification, a bullet-point summary by topic, a table of action items with assigned owner and due date, and an exportable markdown document.

## Provenance

| Field | Value |
|---|---|
| Category | enterprise-ai / generative-ai |
| Transcription | [SYSTRAN/faster-whisper](https://github.com/SYSTRAN/faster-whisper) |
| Real-time variant | [collabora/WhisperLive](https://github.com/collabora/WhisperLive) |
| Original model | [openai/whisper](https://github.com/openai/whisper) |
| LLM (summary + actions) | [ollama/ollama](https://github.com/ollama/ollama) |
| License (faster-whisper) | MIT |
| License (Whisper weights) | MIT |
| Last verified | 2026-10-01 |

## Key capabilities

- Transcription in 99 languages with word-level timestamps
- Language auto-detection
- Multiple model sizes: tiny (39 M params) → large-v3 (1.55 B params)
- GPU and CPU inference via CTranslate2
- Structured output: summary, decisions, action items with owner/due date
- Optional: real-time streaming transcription via WhisperLive WebSocket

## Related demos

- `private-rag` — same Ollama backend; post-transcription RAG over the meeting corpus
- `agentic-dev` — similar agent pipeline for code-related workflows
