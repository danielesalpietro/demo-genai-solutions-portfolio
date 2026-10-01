---
applyTo: "**/*.md"
---

# Documentation instructions

## Every demo README.md must include

1. Overview — one-paragraph business scenario
2. Architecture — services, data flow, ports
3. Prerequisites — Docker version, Compose version, RAM, disk, GPU
4. Quick start — copy-pasteable commands
5. Demo scenario — narrative walkthrough with expected output
6. Operations — start, stop, reset, status
7. Troubleshooting — common failures and resolution
8. Cleanup — remove all artefacts

## Style

- Write in the second person ("Run the following command…").
- Use fenced code blocks for all commands.
- Expected output blocks must match what `demo.sh run` actually produces.
- No hardcoded credentials or real email addresses.
- Verify all relative file links resolve: `./scripts/check-links.sh`.

## Prohibited

- Copy-pasting upstream documentation without attribution and license review.
- Speculative or unverified expected output.
- TODO comments without a linked Issue.
