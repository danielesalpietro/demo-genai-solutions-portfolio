---
applyTo: "**"
---

# Security instructions

## Secrets

- Never commit secrets, tokens, API keys, passwords, or personal data.
- `.env.example` must contain only placeholder values (`CHANGE_ME`, `YOUR_KEY_HERE`).
- `.env` must be in `.gitignore`.

## Images

- All images must have explicit, pinned version tags (no `latest`).
- Scan every new image with Trivy before including it in a PR.
- No HIGH or CRITICAL unfixed CVEs are acceptable.

## Container hardening

Every service in `compose.yaml` must include:

```yaml
read_only: true
security_opt:
  - no-new-privileges:true
cap_drop:
  - ALL
```

## GitHub Actions

- Pin all Actions to a full commit SHA.
- Use minimum required permissions.
- Do not use `pull_request_target` without explicit justification.
- Do not use `permissions: write-all`.

## Escalation

Stop and request human maintainer review when:
- A secret or credential is found in the diff.
- A CVE with CVSS ≥ 7.0 affects a used image.
- A new external service or privileged container is proposed.
- A license incompatible with Apache-2.0 is detected.
