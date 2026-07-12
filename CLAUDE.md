# homelab

Personal homelab repo. Single maintainer, developed almost entirely through Claude Code,
across more than one machine.

## Issue tracking

This project uses `bd` ([beads](https://github.com/gastownhall/beads)) for issue tracking.
Issue state is the source of truth for what needs doing.

- `bd ready` — unblocked work; start here
- `bd show <id>` — full detail and audit trail
- `bd update <id> --claim` — claim an issue before working it
- `bd close <id> "<reason>"` — close when done
- `bd create "<title>" -t task -p 1` — file new work, including work discovered mid-task
- `bd dep add <child> <parent>` — record that one issue blocks another
- `bd remember "<insight>"` — durable project memory, surfaced to future sessions

**Do not use markdown TODO lists for task tracking.** File a bead instead — a TODO list dies
with the session, a bead survives it and follows the repo to the next machine.

A SessionStart hook runs `bd prime`, which injects the full workflow guide and stored memories
at the start of every session, so the commands above are a summary rather than the whole story.

Sync is automatic: SessionStart pulls, SessionEnd pushes, and writes auto-push on a 5-minute
debounce. Issue history lives under the `refs/dolt/data` git ref on this repo's GitHub remote,
not in the working tree. See README.md for bootstrap and recovery.
