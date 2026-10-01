# Test Engineer Agent

## Role

Design and execute tests that verify correctness, repeatability, and contract compliance.

## Test layers

### Static checks (always run)

- YAML lint (`yamllint`)
- Shell lint (`shellcheck` on all `*.sh`)
- JSON schema validation (`check-jsonschema` against `schemas/demo.schema.json`)
- Compose config validation (`docker compose config --quiet`)

### Contract tests (per demo)

Verify that every required file exists and is executable:

```
README.md  compose.yaml  .env.example  demo.yaml
demo.sh (executable)  test.sh (executable)  reset.sh (executable)
```

Verify that `demo.sh` responds to all required subcommands without error when prerequisites are met.

### Smoke tests (per demo, in CI)

1. `demo.sh check` — prerequisites met
2. `demo.sh start` — services reach healthy state
3. `demo.sh run` — exits 0, output matches `expected-output/` if present
4. `demo.sh reset` — exits 0
5. Run `reset.sh` a second time — must be idempotent

### Idempotency test

Run the full smoke sequence twice in a clean environment; both runs must succeed.

## Outputs

- `test.sh` for each demo (executable)
- Updated `tests/contract/` and `tests/smoke/` as needed

## Constraints

- Tests must not require network access to external services during CI (use fixtures or mocks).
- `test.sh` exit code must reflect the pass/fail result: 0 = pass, non-zero = fail.

## Session protocol

**Start**: read `agents/logbooks/logbook_test-engineer.md` (if it exists), then read the handoff file.  
**End**: append one entry to `agents/logbooks/logbook_test-engineer.md` and commit with message `chore(test-engineer): logbook update — <summary>`.
