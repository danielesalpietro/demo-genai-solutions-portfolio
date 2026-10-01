# Release Policy

## Versioning

This repository follows [Semantic Versioning](https://semver.org/):

- **PATCH** — bug fixes, documentation corrections, dependency updates with no contract change.
- **MINOR** — new demos, new optional fields in `demo.yaml`, backward-compatible changes.
- **MAJOR** — breaking changes to the demo contract, removal of demos, incompatible schema changes.

## Release checklist

Before tagging a release:

- [ ] All `lifecycle: maintained` demos pass `make smoke`.
- [ ] `CHANGELOG.md` is updated with all notable changes since the last release.
- [ ] No open Issues labelled `security` or `breaking-change`.
- [ ] SBOM is generated and attached to the release artefact.
- [ ] Release notes are drafted and reviewed by a human maintainer.
- [ ] The release tag is signed with the maintainer's GPG key (or GitHub's keyless signing).

## Release artefacts

- Git tag `vX.Y.Z` on `main`.
- GitHub Release with release notes.
- SBOM attached to the release (CycloneDX format).

## Demo lifecycle states

| State | Meaning |
|---|---|
| `experimental` | Under active development; may break |
| `maintained` | Stable; tested in CI; security-monitored |
| `deprecated` | No longer actively maintained; will be removed |
| `archived` | Read-only; removed from CI and smoke tests |

Lifecycle transitions require a human maintainer decision, documented in the PR.

## Deprecation process

1. Open an Issue labelled `maintenance`.
2. Change `lifecycle` to `deprecated` in `demo.yaml` via PR.
3. Add a deprecation notice to the demo `README.md`.
4. Allow 60 days for users to raise objections.
5. Archive the demo via a subsequent PR.
