# my-ai-config

Personal configuration for Claude Code and Codex. The repository contains
shared rules, reusable skills, commands, hooks, and installer scripts.

## Included

- 33 reusable skills covering software engineering, architecture, DevOps,
  security, data, frontend, testing, GitHub CLI, and diagrams;
- shared coding, commit, browser, GitLab-language, and local-context rules;
- Claude Code commands, agents, and lifecycle hooks;
- Archify for architecture and workflow diagrams;
- browser automation defaults for Playwright and Chrome DevTools;
- the repository-local `.context/` convention for plans and source records.

Work-specific Jira, Neo4j, SQLMesh, Slack-update, demo-reporting, Service Desk,
Datadog, and Wiz configuration has been removed from this personal fork.

## Requirements

- Git;
- Bash on macOS, Linux, or WSL for the shell installers;
- Claude Code and/or Codex;
- Node.js 20+ for Archify and Node-based tools;
- `jq` for Claude hook registration.

## Installation

```bash
git clone https://github.com/EvgenyKlyukin/my-ai-config.git
cd my-ai-config
```

For Claude Code:

```bash
bash install.sh
```

For Codex on Unix-like systems:

```bash
bash install-codex.sh
```

On Windows, copy the directories under `skills/` to
`%USERPROFILE%\\.codex\\skills` and copy `AGENTS.md` to
`%USERPROFILE%\\.codex\\AGENTS.md`, preserving a backup of any existing
`AGENTS.md` first.

Both installers are intended to be safe to re-run and preserve unrelated client
configuration. Review the scripts before running them on a new machine.

## Verification

```bash
test -f ~/.claude/skills/grill-me/SKILL.md
test -f ~/.agents/skills/grill-me/SKILL.md
claude mcp list
codex mcp list
git diff --check
```

## Repository structure

```text
.
├── AGENTS.md          # repository-wide AI instructions
├── CLAUDE.md          # Claude compatibility entry point
├── rules/             # shared behavioral rules
├── skills/            # reusable skills
├── agents/            # Claude subagent definitions
├── commands/          # Claude commands
├── docs/              # remaining general documentation
├── hooks/             # lifecycle hooks
├── install.sh         # Claude installer
├── install-codex.sh   # Codex installer for Unix-like systems
└── uninstall.sh       # removes managed Claude symlinks
```

## Git policy

Use title-only commits in the form `<type>[optional scope]: description`.
Never commit credentials, tokens, cookies, private keys, or machine-local
context.
