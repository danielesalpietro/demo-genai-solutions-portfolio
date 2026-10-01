---
name: remote-control
description: Activate Remote Operative mode — reads the specified handoff file, loads role logbook for context, requests credentials from operator, executes tasks on the local or target system, writes result and logbook entry. Usage: /remote-control <path-to-handoff>
---

## Activation

The argument `args` is the path to a handoff file (e.g. `agents/handoffs/handoff_linux-agent_20261001_001.md`).

If `args` is empty, ask the operator: "Which handoff file should I load? (path relative to repo root)"

## Steps (execute in order, do not skip)

1. **Read handoff file** at the path given in `args`. Parse all sections.
2. **Read role logbook** at `agents/logbooks/logbook_<role>.md` if it exists (role is from the handoff's "Assigned To" section). This provides memory of prior sessions.
3. **Confirm access**: Display the "Credentials / Access" section from the handoff and ask the operator to confirm or provide the missing values. Wait for confirmation before proceeding to step 4.
4. **Execute** the "Task Instructions" section exactly. For each sub-task, announce what you are about to do before doing it.
5. **Verify** against "Success Criteria" in the handoff. If criteria are not met, document what is missing in the result.
6. **Write result file**: create `agents/handoffs/<handoff-basename>.result.md` using the template in `agents/handoff.template.md` (Result section). Set status to `completed` or `failed`. **REQUIRED**: fill the "Command log" section with every command you ran, in order, numbered. This is the source for the manual reproduction guide (`setup_buildin.md`). Include: validation commands, docker calls, file creation steps, test runs. If a command failed and you ran a workaround, document both.
7. **Append logbook entry** to `agents/logbooks/logbook_<role>.md` using the format in `agents/logbook.template.md`.
8. **Commit and push** the result file and logbook entry on a branch named `remote/<role>/<date>` if the repo is writable; otherwise print the diff for the operator to commit manually.
9. **Inform operator**: print a one-line summary and the exact message to relay back to the Supervisor session.

## Security rules (override nothing)

- Never store credentials in any committed file.
- Passphrases, tokens, and private keys are accepted from the operator in-session and never written to disk.
- If a task requires a destructive operation on a production system, stop and ask the operator for explicit confirmation even if the handoff says to proceed.
