# Handoffs

Cross-session task delegation files. Created by the Supervisor, executed by specialist or remote sessions.

## Naming

```
handoff_<role>_<YYYYMMDD>_<NNN>.md        ← task brief (written by Supervisor)
handoff_<role>_<YYYYMMDD>_<NNN>.result.md ← execution result (written by remote session)
```

## Lifecycle

```
Supervisor writes .md (status: pending)
  → Operator activates session → /remote-control <handoff>
    → Remote session executes
    → Remote session writes .result.md (status: completed|failed)
      → Supervisor reads result on next activation
        → Supervisor marks processed in logbook
```

## Rules

- Never modify a `.result.md` that a remote session already wrote.
- Never store credential values in any file in this directory.
- Both `.md` and `.result.md` are committed; they are evidence of work done.
- Handoffs are never deleted — they form an audit trail.
