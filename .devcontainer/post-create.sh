#!/usr/bin/env bash
# Provision issue-tracking tooling (beads). Runs as the devcontainer postCreateCommand,
# and is safe to run by hand on a host: every step is idempotent.
set -euo pipefail

# bd shells out to the dolt CLI as the transport for git-protocol remotes, which is how
# issue history reaches refs/dolt/data on GitHub. bd alone is not enough.
if ! command -v dolt >/dev/null 2>&1; then
	curl -fsSL https://github.com/dolthub/dolt/releases/latest/download/install.sh | sudo bash
fi

if ! command -v bd >/dev/null 2>&1; then
	curl -fsSL https://raw.githubusercontent.com/gastownhall/beads/main/scripts/install.sh | bash
fi

# The bd installer falls back to ~/.local/bin when /usr/local/bin is not writable, which is
# not on PATH in every shell.
if ! command -v bd >/dev/null 2>&1 && [ -x "$HOME/.local/bin/bd" ]; then
	export PATH="$HOME/.local/bin:$PATH"
	grep -qs '\.local/bin' "$HOME/.bashrc" || echo 'export PATH="$HOME/.local/bin:$PATH"' >>"$HOME/.bashrc"
fi

# dolt authenticates to a git+https remote through the git credential helper.
if command -v gh >/dev/null 2>&1; then
	gh auth setup-git || true
fi

# Materialize the issue database from refs/dolt/data. No-op until the first bd dolt push.
bd bootstrap || true
