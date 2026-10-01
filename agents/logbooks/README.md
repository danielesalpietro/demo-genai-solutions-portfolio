# Logbooks

Persistent, append-only memory for each agent role. A new Claude Code session for a given role reads its logbook to recover context from prior sessions.

## Files

```
logbook_supervisor.md
logbook_compose-engineer.md
logbook_script-engineer.md
logbook_test-engineer.md
logbook_security-reviewer.md
logbook_docs-writer.md
logbook_demo-designer.md
logbook_repository-architect.md
logbook_linux-agent.md
logbook_windows-agent.md
logbook_firewall-agent.md
logbook_network-agent.md
```

Create a file on first use from `agents/logbook.template.md`.

## Entry format

```markdown
## 2026-10-01T10:23Z — execute: set up vllm service on private-rag
**Handoff**: agents/handoffs/handoff_script-engineer_20261001_001.md
**Branch**: feat/issue-42-vllm-backend
**System**: local
**Actions taken**:
- Updated packages/private-rag/setup.sh — added INFERENCE_BACKEND branching
- Updated packages/private-rag/docker-compose.cloud.yaml — added vllm profile
**Files changed**: 2 files, +47 -3 lines
**Issues encountered**: none
**Open items**: test-engineer should run cloud-test after merge
---
```

## Rules

- Entries are append-only — never edit or delete prior entries.
- Commit the logbook after each session on the working branch.
- Reading the logbook is mandatory at session start for any role.
