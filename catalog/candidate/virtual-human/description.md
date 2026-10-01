# virtual-human — 3D Conversational Avatar

## Description

A 3D animated avatar responds to user questions with synthesised voice and real-time lip-sync. The avatar is powered by a local LLM for conversation and a local TTS engine for speech. The demo illustrates a fully on-premise conversational interface suitable for customer-facing kiosks, training applications, or service desk scenarios.

## Use case / Scenario

A user approaches a kiosk or opens a browser tab. They ask a question about a product catalogue, an internal procedure, or a training scenario. The avatar listens (optional STT), responds via the LLM, and delivers the answer with lip-synced speech and natural facial animation. The entire pipeline runs in a browser via Three.js/React Three Fiber; no cloud service is involved.

## Provenance

| Field | Value |
|---|---|
| Category | generative-ai / virtual-humans |
| Primary repository | [Yacine-Mekideche/IAcine-3D-Avatar](https://github.com/Yacine-Mekideche/IAcine-3D-Avatar) |
| LLM | [ollama/ollama](https://github.com/ollama/ollama) |
| TTS | [rhasspy/piper](https://github.com/rhasspy/piper) or ElevenLabs (cloud, optional) |
| 3D rendering | Three.js / React Three Fiber (browser) |
| Lip-sync | ReadyPlayerMe avatar + Rhubarb Lip Sync |
| Reference collection | [Awesome Digital Human](https://github.com/nicehuster/awesome-digital-human) |
| License | To be verified on current IAcine repo state |
| Last verified | 2026-10-01 |

## Key capabilities

- Real-time 3D avatar rendering in the browser (WebGL)
- LLM-powered conversation via Ollama (local, no API key needed)
- Text-to-speech narration with lip-sync timing
- Optional: speech-to-text input via Whisper (microphone)
- ReadyPlayerMe avatar customisation support
- Knowledge base integration: the avatar can be grounded on a document corpus via the `private-rag` stack

## Related demos

- `private-rag` — knowledge base for domain-specific avatar answers
- `speech-intelligence` — Whisper input integration for voice interaction
- `content-creator` — avatar as delivery channel for generated content
