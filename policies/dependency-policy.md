# Dependency Policy

## Scope

This policy applies to:
- Container images referenced in `compose.yaml` files
- Shell script dependencies
- Python or other scripting packages used in CI
- GitHub Actions

## Pinning requirement

All dependencies must be pinned to an exact, immutable reference:

| Dependency type | Required format |
|---|---|
| Container image | `name:major.minor.patch[-variant]` — no `latest`, no floating tags |
| GitHub Action | `uses: owner/action@<commit-sha>` with a version comment |
| Python package | `package==x.y.z` in `requirements.txt` |

## Adding a dependency

When proposing a new dependency, the PR must document:

1. **Purpose** — why this dependency is needed
2. **Version** — exact version and the rationale for choosing it
3. **License** — SPDX identifier; must be compatible with the repository license (Apache-2.0)
4. **Security impact** — Trivy or equivalent scan result; no HIGH/CRITICAL unfixed CVEs

## Updating dependencies

- Dependabot opens PRs for image and Action updates weekly.
- The Maintenance Agent opens Issues for images with no Dependabot coverage.
- Updates require CI to pass; no manual override of failing checks.

## Removal

When a dependency is removed, ensure:
- It is not referenced anywhere in the repository.
- No demo relies on it at runtime.
- The removal is documented in the PR description.

## Incompatible licenses

Licenses that are incompatible with Apache-2.0 and must not be introduced:
- GPL-2.0-only, GPL-3.0-only (copyleft, viral)
- AGPL-3.0 (copyleft, server-side)
- SSPL (source-available, not open source)
- Proprietary licenses that restrict redistribution

When uncertain, escalate to a human maintainer.
