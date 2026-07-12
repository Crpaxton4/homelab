# homelab

## Issue tracking

Work is tracked with [beads](https://github.com/gastownhall/beads) (`bd`), a dependency-aware
issue tracker built for coding agents. Issue history is version-controlled **inside this repo**
under the `refs/dolt/data` git ref — not in the working tree — so it travels with the repo and
a session can be picked up on any machine. Only `.beads/config.yaml` is committed; the local
Dolt database is machine-local and gitignored.

### Setting up a machine

Open the repo in the devcontainer — `.devcontainer/post-create.sh` installs `bd` and `dolt` and
runs `bd bootstrap`, which materializes the issue database from `refs/dolt/data`. To do it by
hand on a host:

```bash
bash .devcontainer/post-create.sh
bd ready
```

### Day to day

Sync is automatic. Claude Code pulls at session start and pushes at session end, and writes
auto-push on a 5-minute debounce. Explicitly, if needed:

```bash
bd dolt pull     # take the other machine's work
bd dolt push     # publish yours
bd doctor        # health check
```

### Recovering the issue database

GitHub cannot protect custom refs — rulesets cover branches and tags only — so
`.github/workflows/beads-snapshot.yaml` takes a dated snapshot of `refs/dolt/data` every day and
keeps 30 days of them. To roll back to one:

```bash
git ls-remote origin 'refs/dolt/snapshots/*'                     # pick a date
git fetch origin +refs/dolt/snapshots/YYYY-MM-DD:refs/dolt/restore
git push --force origin refs/dolt/restore:refs/dolt/data
bd bootstrap                                                     # or: bd dolt pull
```

A full local Dolt backup is also kept in `.beads/backup/` on a 15-minute interval; restore from
it with `bd backup restore`.
