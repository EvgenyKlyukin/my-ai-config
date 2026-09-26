# Local Repository Context

When entering a Git repository, check for `.context/AGENTS.md`. If it exists,
read it as supplementary local context after reading the tracked repository
instructions. Treat tracked instructions as authoritative in conflicts and
report the conflict.

Use `.context/AGENTS.md` as the local context map. Load only files relevant to
the current task; do not read the entire `.context/` tree by default.

Common local files and directories include:

- `.context/AGENTS.md` — map of the repository's local context;
- `.context/infrastructure.md` — local server metadata, SSH aliases, credential
  references, and operational procedures;
- `.context/contexts/` — scoped project context;
- `.context/docs/` — local-only supporting documentation;
- `.context/plans/` — implementation plans;
- `.context/scripts/` — repository-specific local automation;
- `.context/sources/` — useful records retrieved from external sources;
- `.context/CHANGELOG.md` — local remote-aware changelog when maintained.

Keep `.context/` local-only. Add `/.context/` and `/.worktrees/` to the
repository's shared `.git/info/exclude`; do not modify the tracked `.gitignore`.
Never commit `.context/` unless the user explicitly asks for a specific file.

Store repository-specific automation in `.context/scripts/`. Store environment
values in adjacent `.env` files and keep secret-bearing files user-only. Never
store passwords, private keys, access tokens, cookies, or `.env` contents in
tracked files or in the context map. Use the operating system's credential
store or SSH agent and record only variable names, secret references, and key
paths.

When inspecting or mutating an external source, save useful resulting
information under `.context/sources/` during the same task when the source
record will help future work. Include provenance, a retrieval timestamp, and
stable identifiers without storing credentials or unnecessary sensitive data.

Keep one shared `.context/` directory for the primary worktree and link
additional worktrees to it. Do not overwrite a real `.context/` directory in a
linked worktree; report the conflict first. Write context files in English,
preserving exact identifiers and required quotations.

Never modify tracked `AGENTS.md`, `CLAUDE.md`, `docs/`, or plans merely to store
personal notes.
