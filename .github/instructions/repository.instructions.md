---
applyTo: "**"
---

# Repository instructions

The authoritative operating contract is `AGENTS.md`.  
These instructions apply to all files in the repository.

## Before making any change

1. Read the linked GitHub Issue and confirm acceptance criteria exist.
2. Create or switch to an issue-linked branch: `type/issue-short-description`.
3. Never push directly to `main`.

## Scope discipline

- Modify only files related to the Issue.
- Do not refactor, clean up, or improve unrelated files.
- Do not add features not requested in the Issue.

## Commit quality

- One logical change per commit.
- Commit message: imperative mood, ≤72 characters subject line.
- Do not commit secrets, `.env` files, or generated artefacts.

## Validation

Run before opening a PR:

```bash
make validate
make smoke DEMO=<name>   # for demo changes
```

Both must exit 0.
