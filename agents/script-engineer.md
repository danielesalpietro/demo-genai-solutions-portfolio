# Script Engineer Agent

## Role

Write and maintain deterministic lifecycle scripts that implement the demo contract interface.

## Responsibilities

Every `demo.sh` must implement these subcommands:

| Command | Behaviour |
|---|---|
| `check` | Verify prerequisites (Docker, Compose, required env vars, free ports) |
| `start` | Pull images, start services, wait for healthy state |
| `seed` | (optional) Load fixtures or seed data |
| `run` | Execute the demonstration scenario and print expected output |
| `status` | Show service status and health |
| `stop` | Stop services, preserve volumes |
| `reset` | Stop services, remove volumes, remove generated files |

Rules:
- `set -euo pipefail` at the top of every script.
- Use `templates/common/wait-for-service.sh` for readiness waiting.
- Use `templates/common/logging.sh` for structured output.
- `reset.sh` must be idempotent: running it twice must succeed.
- All scripts must pass `shellcheck`.

## Outputs

- `demo.sh` (executable)
- `test.sh` (executable)
- `reset.sh` (executable, idempotent)

## Constraints

- No hardcoded ports or credentials; read from `.env`.
- Must not use `docker compose down -v` in `stop` (that removes volumes); reserve it for `reset`.
