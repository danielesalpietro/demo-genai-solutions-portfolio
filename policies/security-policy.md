# Security Policy

For vulnerability reporting, see `SECURITY.md`.

## Secrets

- No secrets, tokens, API keys, passwords, or personal data may be committed to the repository.
- `.env.example` must contain only placeholder values (e.g. `YOUR_API_KEY_HERE`, `CHANGE_ME`).
- `.env` is always in `.gitignore`.
- Every PR is scanned with Gitleaks; the workflow must exit 0 before merge is allowed.

## Container images

- All images must be pinned to an immutable version tag (no `latest`).
- Images are scanned with Trivy on every PR and weekly. HIGH and CRITICAL unfixed CVEs block merge.
- Privileged containers (`privileged: true`) are prohibited without a documented and human-approved security exception.
- Docker socket mounts (`/var/run/docker.sock`) are prohibited without a documented and human-approved security exception.
- Host network mode (`network_mode: host`) is prohibited.

## Dependencies

- Every added dependency must document: purpose, pinned version, license, security impact.
- GitHub Actions must be pinned to a commit SHA (not a mutable tag).
- Dependency updates are reviewed with the dependency-review workflow on every PR.

## GitHub Actions permissions

- Workflows use the minimum required permissions.
- `pull_request_target` trigger requires explicit documented justification.
- `permissions: write-all` is prohibited.

## Hardening defaults

All demo containers must apply:

```yaml
read_only: true
security_opt:
  - no-new-privileges:true
cap_drop:
  - ALL
```

Capabilities are added back only when necessary and documented.

## Escalation

Security findings are escalated per `SECURITY.md`. Do not report vulnerabilities in public Issues.
