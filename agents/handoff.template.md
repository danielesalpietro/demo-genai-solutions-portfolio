# Handoff: <role> — <task_id>

<!--
  SUPERVISOR: fill all fields before sharing with the operator.
  OPERATOR: fill "Credentials / Access" section before activating the remote session.
  REMOTE SESSION: fill "Result" section after completing the task.
-->

## Header

| Field | Value |
|---|---|
| Handoff file | `agents/handoffs/handoff_<role>_<YYYYMMDD>_<NNN>.md` |
| Role | `<role>` |
| Issue | `#<NNN>` |
| Branch | `<type/issue-NNN-description>` |
| Follows | _(none, or previous handoff filename)_ |
| Status | `pending` |
| Requested | `<ISO datetime>` |
| Completed | _(filled by remote session)_ |

## Assigned To

- **Role**: `<role>` (e.g. linux-agent, compose-engineer, firewall-agent)
- **Execution context**: `local` or `remote:<target-hostname>`
- **OS**: `<ubuntu-22.04 | windows-server-2022 | ...>`
- **Session**: _(filled by operator when activating)_

## Context

<!-- Brief description of WHY this task exists. Link to the Issue. -->

This task is part of the work for Issue #NNN: <issue title>.

<what the overall goal is, 2-3 sentences>

## Prerequisites

Before executing:
- [ ] Read `agents/logbooks/logbook_<role>.md` if it exists (prior session context)
- [ ] Verify access to `<system or service>`
- [ ] Confirm all required credentials are available (see section below)
- [ ] Pull latest `<branch>` from origin

## Task Instructions

<!-- Step-by-step, specific, unambiguous. Number each step. -->

1. ...
2. ...
3. ...

## Expected Outputs

For each output, specify path and description:

| Path | Description |
|---|---|
| `<file path>` | <what it is> |
| `agents/logbooks/logbook_<role>.md` | Updated logbook entry (required) |
| `agents/handoffs/<this-file>.result.md` | Result file (required) |

## Success Criteria

The task is complete when ALL of these are true:

- [ ] <criterion 1>
- [ ] <criterion 2>
- [ ] Logbook entry written and committed
- [ ] Result file written with `status: completed`

## Credentials / Access

<!--
  SUPERVISOR: list what is needed, not the values.
  OPERATOR: fill in the actual values or paths before activating the remote session.
  These fields must NEVER be committed to git.
-->

| What | Source | Operator-provided value |
|---|---|---|
| SSH key | `~/.ssh/<keyname>` | _(operator fills)_ |
| Sudo access | local sudoer or `NOPASSWD` | _(operator confirms)_ |
| API key env var | `<VAR_NAME>` | _(operator sets in session)_ |
| Certificate path | `<hint>` | _(operator fills)_ |

## Result

<!--
  REMOTE SESSION: fill this section after task completion.
  Do not modify any field above this line.
-->

| Field | Value |
|---|---|
| Status | `pending` → `completed` \| `failed` |
| Completed | _(ISO datetime)_ |
| Exit code | _(0 = success)_ |
| Session | _(operator ID or hostname)_ |

### Summary

<one paragraph describing what was done, what was verified, and any deviations from the instructions>

### Artifacts produced

| Path | Status |
|---|---|
| `<path>` | created \| modified \| unchanged |

### Command log

<!-- REQUIRED — fill with the exact sequence of commands run during this task.
     Number each step. Include expected outputs where relevant.
     This section is the source for setup_buildin.md (manual reproduction guide).
     Format: step number, command, one-line description of what it does/verifies. -->

```bash
# Step 1 — <description>
<exact command>

# Step 2 — <description>
<exact command>
```

### Issues encountered

<any problems, workarounds, or open items for the Supervisor>

### Supervisor action needed

- [ ] None — task complete as specified
- [ ] Follow-up handoff needed: <description>
- [ ] Escalate to human: <reason>
