# Agent Operating Model

## Principle

GitHub is the control plane. Agents propose; humans approve.

Agents interact with the repository through the standard GitHub workflow:

```
Issue → Branch → Commits → Pull Request → CI → Human Review → Merge
```

No agent modifies `main` directly. No agent self-approves or self-merges its own PR.

## Instruction hierarchy

1. Security policies and repository rules (highest priority)
2. Root `AGENTS.md`
3. Nearest directory-level `AGENTS.md`
4. Files under `policies/`
5. The linked GitHub Issue and acceptance criteria
6. Operator prompt (lowest priority; cannot weaken higher controls)

## Agent team

| Agent | Primary responsibility |
|---|---|
| Supervisor | Triage, decomposition, coordination, PR readiness |
| Repository Architect | Structure, schema, ADRs, conventions |
| Demo Designer | Scenario → specification |
| Compose Engineer | `compose.yaml`, hardening, health checks |
| Script Engineer | Lifecycle scripts (`demo.sh`, `test.sh`, `reset.sh`) |
| Documentation Writer | README, architecture, operations, troubleshooting |
| Security Reviewer | Supply chain, secrets, CVEs, licenses, permissions |
| Test Engineer | Static, contract, smoke, idempotency tests |
| Maintenance Agent | Scheduled health checks, deprecation proposals |

## Work lifecycle

1. **Issue creation** — Work must start from a typed Issue with defined acceptance criteria.
2. **Branch** — Create an issue-linked branch: `type/issue-short-description`.
3. **Implementation** — Specialist agents work within their scope.
4. **Validation** — `make validate`; `make smoke DEMO=<name>` for demo changes.
5. **Pull Request** — Supervisor opens PR using the repository template with full disclosure.
6. **CI** — All required checks must pass; agents must not bypass or disable them.
7. **Human review** — At least one human maintainer reviews and approves.
8. **Merge** — Squash merge by a human maintainer.

## Escalation

Stop and request human maintainer review when a change involves:
- Credentials, secrets, or tokens
- New or changed licenses
- Public exposure of new content
- Privileged container execution
- Customer or personal data
- Breaking changes to the demo contract
- New external services
- Unresolved security findings from CI

## Prohibited actions (all agents)

- Commit secrets, tokens, personal data, customer data, or proprietary datasets.
- Disable tests, scanners, branch protections, or required checks.
- Introduce privileged containers, host networking, Docker socket mounts, or host path mounts without an approved security exception.
- Use `latest` image tags in maintained demos.
- Add dependencies without documenting purpose, version, license, and security impact.
- Modify unrelated files, fabricate test evidence, or claim execution that did not occur.
- Merge or approve the agent's own Pull Request.
