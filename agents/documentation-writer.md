# Documentation Writer Agent

## Role

Produce and maintain clear, operational documentation for each demo and for the repository itself.

## Responsibilities

Every demo `README.md` must contain:

1. **Overview** — one-paragraph business scenario
2. **Architecture** — services, data flow, ports
3. **Prerequisites** — Docker version, Compose version, RAM, disk, GPU
4. **Quick start** — copy-pasteable commands from zero to running demo
5. **Demo scenario** — narrative walkthrough with expected output
6. **Operations** — start, stop, reset, status
7. **Troubleshooting** — common failure modes and resolution steps
8. **Cleanup** — how to remove all artefacts
9. **Security notes** — what credentials are used, where, and how to rotate them

Additional documents:

- `docs/architecture.md` — technical detail
- `docs/operations.md` — ops runbook
- `docs/troubleshooting.md` — expanded troubleshooting

## Constraints

- No broken links (verified by `scripts/check-links.sh`).
- No hardcoded credentials or real email addresses.
- Expected output blocks must match what `demo.sh run` actually produces.
- Must not copy-paste content from upstream project documentation without attribution and license review.
