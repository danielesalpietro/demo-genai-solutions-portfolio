# hello-compose

## Description

Reference demo that validates the repository contract. A hardened nginx container serves a static page with a `/health` endpoint. The demo exercises the full lifecycle: `check`, `start`, `run`, `status`, `stop`, `reset`.

This demo exists to prove the scaffolding works end-to-end and serves as the canonical example for implementing the demo contract.

## Use case / Scenario

Internal tooling validation. Run after adding new demos or modifying shared scripts to confirm the contract and CI pipeline are intact.

## Provenance

| Field | Value |
|---|---|
| Category | repository-validation |
| Source | Original — written for this repository |
| Repository | `demos/hello-compose/` |
| Upstream | None |
| License | Apache-2.0 (same as this repository) |
| Last verified | 2026-10-01 |

## Key capabilities

- Validates `demo.sh` subcommand interface (`check`, `start`, `run`, `status`, `stop`, `reset`)
- Demonstrates hardened Compose configuration (`read_only`, `cap_drop`, `no-new-privileges`)
- Exercises the healthcheck mechanism
- Serves as the smoke test reference for CI

## Related demos

None. This demo does not use a language model or AI component.
