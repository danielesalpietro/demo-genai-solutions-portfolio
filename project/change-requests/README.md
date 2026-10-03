# Change Requests

One file per strategic deviation from the plan.

Created by: `/project-manager` session  
Decided by: human maintainer  
Implemented by: Supervisor (if approved)

## Naming

`CR-<NNN>-<slug>.md` — zero-padded, sequential across the project lifetime.

## Lifecycle

```
PM detects deviation
  └→ creates CR-NNN.md here
  └→ adds entry to project/wbs.yaml change_requests[]
  └→ opens GitHub Issue with label "change-request"
       └→ human reviews and fills Decision section
            └→ if approved: Supervisor picks up on next activation
            └→ if rejected/deferred: PM closes GitHub Issue and notes in logbook
```

## Index

| CR | Title | Status | Opened | GitHub Issue |
|---|---|---|---|---|
| [CR-001](CR-001-qdrant-cve-hold.md) | Security HOLD — qdrant CRITICAL CVEs, decision required | open | 2026-10-03 | [#7](https://github.com/danielesalpietro/demo-genai-solutions-portfolio/issues/7) |
