# Pull Request Policy

## Requirements

Every Pull Request must:

- Be linked to a GitHub Issue with confirmed acceptance criteria.
- Contain narrowly scoped commits (one logical change per commit).
- Pass all required CI checks (validate, smoke, security).
- Have all review conversations resolved.
- Receive CODEOWNER review where applicable.
- Receive at least one human maintainer approval.

Agents may author Pull Requests but must not self-approve or self-merge them.

## PR template compliance

The PR description must fully complete `.github/pull_request_template.md`, including:

- Linked Issue (`Closes #N`)
- Change type checklist
- Validation checklist (all applicable items checked)
- Evidence section (sanitised commands and output)
- Agent disclosure section (tool, operator, generated files, reviewed files, residual risks)

## Merge rules

- Merge strategy: squash merge.
- Branch must be up to date with `main` before merge.
- No force push to `main`.
- No deletion of `main`.
- Bypass limited to repository maintainers in exceptional, documented cases.

## Scope discipline

- Modify only files related to the Issue.
- Do not include unrelated refactors, cleanups, or improvements.
- Split unrelated changes into separate PRs.
