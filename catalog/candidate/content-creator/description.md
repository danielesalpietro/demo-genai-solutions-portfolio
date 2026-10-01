# content-creator — Automated Content Creator

## Description

Input a product brief, document, or script. The demo generates a multi-step content pipeline: screenplay/storyboard, voiceover narration (TTS), scene description, and a short video with captions. The output is a downloadable MP4 suitable for product promotion, training material, or internal communication.

## Use case / Scenario

A marketing team provides a two-paragraph product description. The demo produces: a structured screenplay with scene descriptions, a text-to-speech narration track, a rendered video with auto-generated scenes, and subtitles. The demo illustrates a complete, agentic content production pipeline running locally.

## Provenance

| Field | Value |
|---|---|
| Category | generative-ai / content |
| Video generation | [gyoridavid/short-video-maker](https://github.com/gyoridavid/short-video-maker) |
| Storyboard + animation | [HBAI-Ltd/Toonflow-app](https://github.com/HBAI-Ltd/Toonflow-app) |
| LLM (screenplay) | [ollama/ollama](https://github.com/ollama/ollama) |
| TTS | [coqui-ai/TTS](https://github.com/coqui-ai/TTS) or [piper-tts/piper](https://github.com/rhasspy/piper) |
| License (short-video-maker) | To be verified |
| License (Piper TTS) | MIT |
| Last verified | 2026-10-01 |

## Key capabilities

- LLM-generated screenplay from a brief or document
- Text-to-speech narration (offline, Piper or Coqui TTS)
- Short video assembly (FFmpeg-based pipeline)
- Optional: animated storyboard via Toonflow-app
- MCP-compatible API endpoint for agentic integration

## Related demos

- `private-rag` — input documents can feed the content generation pipeline
- `virtual-human` — avatar delivery of the generated content
