# video-intelligence — Video Intelligence Agent

## Description

Upload a video file (MP4, AVI, MKV). An agentic pipeline transcribes the audio track, analyses the visual content at keyframes, segments the video into chapters with titles, enables semantic question answering over the full video content, and generates a structured summary. Suitable for surveillance, training, maintenance, and meeting recordings.

## Use case / Scenario

A safety manager uploads a 20-minute maintenance procedure recording. The demo produces: auto-generated chapters ("Safety checks", "Assembly step 1–4", "Verification"), a searchable transcript, answers to questions like "At what point is the torque wrench used?", and a summary document. All processing runs locally with no video data sent externally.

## Provenance

| Field | Value |
|---|---|
| Category | generative-ai / video |
| Agent framework | [YueLu0116/VideoAgent](https://github.com/YueLu0116/VideoAgent) |
| Transcription | [SYSTRAN/faster-whisper](https://github.com/SYSTRAN/faster-whisper) |
| Vision model | LLaVA 1.6 or Llama 3.2-Vision via Ollama |
| LLM | [ollama/ollama](https://github.com/ollama/ollama) |
| License (VideoAgent) | To be verified |
| License (faster-whisper) | MIT |
| Last verified | 2026-10-01 |

## Key capabilities

- Audio transcription with timestamps (faster-whisper)
- Keyframe extraction and visual description (LLaVA or Llama Vision)
- Automatic chapter segmentation with semantic titles
- Natural language Q&A over the full video content
- Structured summary output (JSON + Markdown)
- Gradio-based video player with chapter navigation

## Related demos

- `speech-intelligence` — transcription component is shared
- `private-rag` — video transcripts can feed a RAG knowledge base
