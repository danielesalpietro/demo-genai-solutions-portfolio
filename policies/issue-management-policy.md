# Issue Management Policy

## Issue types

| Label | Purpose |
|---|---|
| `demo:new` | Propose a new demonstration |
| `demo:update` | Modify an existing demonstration |
| `bug` | Defect in a demo or repository script |
| `security` | Vulnerability, secret exposure, or supply-chain risk |
| `dependency` | Image, package, or Action version update |
| `documentation` | Documentation gap or error |
| `maintenance` | Scheduled health, compatibility, or lifecycle task |
| `architecture-decision` | Structural or schema change requiring an ADR |
| `breaking-change` | Change that breaks the demo contract or public interface |

## Required fields for `demo:new` Issues

All of the following must be present before implementation begins:

1. Business scenario — problem, audience, desired outcome
2. Target audience
3. Demo narrative — steps and expected output
4. Required components — services, images, external dependencies
5. Hardware requirements — CPU, RAM, disk, GPU, ports, supported platforms
6. Security and licensing considerations
7. Expected execution time
8. Expected output (sample)
9. Acceptance criteria (verifiable checklist)
10. Responsible maintainer

## Acceptance criteria requirement

Agents must not begin implementation on any Issue that lacks acceptance criteria.  
The Supervisor may draft a proposal and add it to the Issue, but a human maintainer must confirm the criteria before work proceeds.

## Issue states

| State | Meaning |
|---|---|
| `triage` | Received; not yet reviewed |
| `accepted` | Acceptance criteria confirmed; ready for implementation |
| `in-progress` | Branch exists; work is active |
| `blocked` | Waiting for external input or decision |
| `review-ready` | PR open; awaiting CI and human review |
| `done` | Merged and closed |

## Closing Issues

Issues are closed only when the linked PR is merged and acceptance criteria are confirmed satisfied by the evidence in the PR.
