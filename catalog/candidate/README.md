# Candidates

Demos in this directory have an identified upstream repository and confirmed feasibility, but no active development branch yet.

To promote a candidate to `develop`:

1. Open a GitHub Issue of type `demo:new` with all 10 required fields (see `policies/issue-management-policy.md`).
2. Confirm acceptance criteria with a maintainer.
3. Move the demo folder to `catalog/develop/` in the same PR that creates the development branch.

Each candidate contains:
- `description.md` — scenario, capabilities, upstream provenance, license status
- `release_notes.md` — version history (starts at `v0.1.0-candidate`) and hardware/software prerequisites
