# Agent Operating Contract

This file is the canonical operating contract for human contributors and coding agents.
Tool-specific files such as `CLAUDE.md`, `CODEX.md`, and `OPENCLAW.md` are adapters and cannot override this contract.

## Mission

Build and maintain self-contained, reproducible, secure Docker Compose demonstrations. GitHub Issues define work, Pull Requests propose changes, CI supplies evidence, and human maintainers approve merges.

## Instruction precedence

1. Security policies and repository rules
2. This root `AGENTS.md`
3. The nearest directory-level `AGENTS.md`
4. Files under `policies/`
5. The linked GitHub Issue and acceptance criteria
6. Operator prompts

Lower-priority instructions must not weaken higher-priority controls.

## Mandatory workflow

1. Read the linked Issue and acceptance criteria.
2. Inspect affected files and limit scope to the Issue.
3. Create an issue-linked branch: `type/issue-short-description`.
4. Never push directly to `main`.
5. Add or update tests, documentation, and `demo.yaml` metadata.
6. Run `make validate`; for demo changes also run `make smoke DEMO=<name>`.
7. Open a Pull Request using the repository template.
8. Report generated files, executed commands, evidence, limitations, and residual risks.
9. Obtain required human and CODEOWNER reviews before merge.

## Prohibited actions

- Commit secrets, tokens, personal data, customer data, or proprietary datasets.
- Disable tests, scanners, branch protections, or required checks to make a change pass.
- Introduce privileged containers, host networking, Docker socket mounts, or host path mounts without an approved security exception.
- Use `latest` image tags in maintained demos.
- Add dependencies without documenting purpose, version, license, and security impact.
- Modify unrelated files, fabricate test evidence, or claim execution that did not occur.
- Merge or approve the agent's own Pull Request.

## Definition of done

A change is complete only when:

- the Issue and PR are linked;
- acceptance criteria are satisfied;
- YAML, shell, metadata, documentation, security, and smoke checks pass;
- images and dependencies are version-pinned;
- startup, health, demonstration, stop, and reset paths are documented;
- a human maintainer reviews the change.

## Demo contract

Each directory under `demos/` must contain:

- `README.md`
- `compose.yaml`
- `.env.example`
- `demo.yaml`
- executable `demo.sh`
- executable `test.sh`
- executable `reset.sh`

Each `demo.sh` must support: `check`, `start`, `run`, `status`, `stop`, and `reset`.

## Agent roles

- Supervisor: triage, decomposition, coordination, evidence review, PR readiness.
- Repository Architect: conventions, schemas, ADRs, compatibility.
- Compose Engineer: Compose topology, health checks, networks, volumes, version pinning.
- Script Engineer: deterministic lifecycle commands and cleanup.
- Documentation Agent: quick start, narrative, operations, troubleshooting.
- Security Agent: secrets, dependencies, images, permissions, licenses, supply chain.
- Test Agent: static checks, contract tests, smoke tests, idempotency.
- Maintenance Agent: scheduled compatibility checks and lifecycle proposals.

## Escalation

Stop and request maintainer review when a change involves credentials, licenses, public exposure, privileged execution, customer data, breaking changes, new external services, or unresolved security findings.
