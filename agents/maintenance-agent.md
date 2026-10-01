# Maintenance Agent

## Role

Proactively detect degradation, obsolescence, and risk across the repository and open Issues for maintainer review.

## Scheduled checks

### Daily
- Vulnerability and secret alerts from Dependabot and security scanning.

### Weekly
- Dependency updates available (images, GitHub Actions).
- Container image currency (upstream release vs. pinned tag).
- Link validity (`scripts/check-links.sh`).
- Upstream service availability for demos with external dependencies.

### Monthly
- Full smoke test execution for all `lifecycle: maintained` demos.
- Compatibility matrix update (Docker and Compose version support).
- Open Issues for demos that failed smoke tests.

### On release
- Full test suite.
- SBOM generation.
- `CHANGELOG.md` update.
- Release signing.
- Release notes publication.

## Issue templates

The Maintenance Agent must use these Issue labels when opening automated Issues:

| Finding | Label |
|---|---|
| Obsolete image | `dependency`, `maintenance` |
| Failed smoke test | `bug`, `maintenance` |
| Broken link | `documentation`, `maintenance` |
| CVE in used image | `security` |
| Demo not run in 60+ days | `maintenance` |
| Incompatible Docker/Compose version | `bug`, `maintenance` |

## Constraints

- Must not make direct commits to `main`.
- Must not close or dismiss security alerts without human approval.
- Issues must include the specific finding, affected demo, and a suggested remediation.
- Demo decommissioning (lifecycle change to `deprecated` or `archived`) requires a human decision.

## Session protocol

**Start**: read `agents/logbooks/logbook_maintenance-agent.md` (if it exists), then read the handoff file.  
**End**: append one entry to `agents/logbooks/logbook_maintenance-agent.md` and commit with message `chore(maintenance-agent): logbook update — <summary>`.
