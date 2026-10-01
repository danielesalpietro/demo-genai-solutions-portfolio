---
name: remote-control
description: Activate Remote Operative mode — reads the specified handoff file, loads role logbook for context, requests credentials from operator, executes tasks on the local or target system, writes result and logbook entry. Usage: /remote-control <path-to-handoff>
---

## Activation

The argument `args` is the path to a handoff file (e.g. `agents/handoffs/handoff_linux-agent_20261001_001.md`).

If `args` is empty, ask the operator: "Which handoff file should I load? (path relative to repo root)"

## Steps (execute in order, do not skip)

0. **Prepare working directory**:
   - **Local session** (execution context `local`): run `git pull origin <branch>` to ensure the handoff file exists locally.
   - **Remote session on z8g4** (execution context `remote:z8g4`): the repo is cloned fresh to a temporary directory on the server by the operator before starting `claude`. The `CLONE_DIR` variable holds this path and is set in the session by the operator. If not set, ask: "What is the path to the cloned repo on this server?"

1. **Read handoff file** at the path given in `args`. Parse all sections.
2. **Read role logbook** at `agents/logbooks/logbook_<role>.md` if it exists (role is from the handoff's "Assigned To" section). This provides memory of prior sessions.
3. **Confirm access**: Display the "Credentials / Access" section from the handoff and ask the operator to confirm or provide the missing values. Wait for confirmation before proceeding to step 4.
4. **Execute** the "Task Instructions" section exactly. For each sub-task, announce what you are about to do before doing it.
   - **On z8g4**: do NOT install packages permanently (`apt install` only if strictly required and noted in result), do NOT create systemd units, cron entries, or modify `/etc/` files, do NOT alter Docker daemon config or existing named volumes. Work only inside `$CLONE_DIR` and inside named Docker containers/volumes you explicitly create for this task.
5. **Verify** against "Success Criteria" in the handoff. If criteria are not met, document what is missing in the result.
6. **Write result file**: create `agents/handoffs/<handoff-basename>.result.md` using the template in `agents/handoff.template.md` (Result section). Set status to `completed` or `failed`. **REQUIRED**: fill the "Command log" section with every command you ran, in order, numbered — source for `setup_buildin.md`. Include: validation commands, docker calls, file creation steps, test runs. If a command failed and you ran a workaround, document both. Add a **Cleanup log** sub-section listing every artifact created on the remote system (directories, containers, volumes, images) and whether each was removed.
7. **Append logbook entry** to `agents/logbooks/logbook_<role>.md` using the format in `agents/logbook.template.md`.
8. **Commit and push** the result file and logbook entry on branch `feat/issue-2-private-rag` (or as specified in the handoff). Push before cleanup — once the remote repo is removed you cannot push.
9. **Cleanup** (z8g4 sessions only — skip for local sessions):
   - Remove any Docker containers and volumes created during this task: `docker compose down -v` inside `$CLONE_DIR` if applicable.
   - Remove any Docker images pulled exclusively for this task if they are large (>2 GB) and not needed by other running workloads. Check `docker ps` before removing anything.
   - Remove the cloned repo: `rm -rf $CLONE_DIR`.
   - Do NOT remove images or volumes that existed before this session started.
   - Verify: `ls $CLONE_DIR` must return "No such file or directory".
10. **Inform operator**: print a one-line summary, confirm cleanup status, and the exact message to relay back to the Supervisor session.

## Security rules (override nothing)

- Never store credentials in any committed file.
- Passphrases, tokens, and private keys are accepted from the operator in-session and never written to disk.
- If a task requires a destructive operation on a production system, stop and ask the operator for explicit confirmation even if the handoff says to proceed.
