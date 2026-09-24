#!/usr/bin/env bash
# SessionStart hook: detect the local-only .context/ context scaffold and tell
# Claude what to load or bootstrap. The hook is read-only and fail-open.

set -u

input="$(cat)"
cwd="$(printf '%s' "$input" | /usr/bin/python3 -c 'import sys,json;print(json.load(sys.stdin).get("cwd",""))' 2>/dev/null)"
[ -z "$cwd" ] && cwd="$PWD"

repo_root="$(git -C "$cwd" rev-parse --show-toplevel 2>/dev/null)"
[ -z "$repo_root" ] && exit 0

primary_root="$(git -C "$repo_root" worktree list --porcelain 2>/dev/null | sed -n 's/^worktree //p' | head -1)"
[ -z "$primary_root" ] && primary_root="$repo_root"
shared_root="${primary_root}/.context"
local_root="${repo_root}/.context"
missing=()

[ -d "${primary_root}/.worktrees" ] || missing+=("${primary_root}/.worktrees/")
if [ "$repo_root" != "$primary_root" ]; then
  resolved_local_root="$(/usr/bin/python3 -c 'import os,sys; print(os.path.realpath(sys.argv[1]))' "$local_root" 2>/dev/null)"
  [ -L "$local_root" ] && [ "$resolved_local_root" = "$shared_root" ] || missing+=(".context -> ${shared_root}")
fi
[ -f "${local_root}/AGENTS.md" ] || missing+=(".context/AGENTS.md")
[ -L "${local_root}/CLAUDE.md" ] && [ "$(readlink "${local_root}/CLAUDE.md")" = "AGENTS.md" ] || missing+=(".context/CLAUDE.md -> AGENTS.md")
[ -f "${local_root}/CHANGELOG.md" ] || missing+=(".context/CHANGELOG.md")
[ -d "${local_root}/contexts" ] || missing+=(".context/contexts/")
[ -d "${local_root}/docs" ] || missing+=(".context/docs/")
[ -d "${local_root}/plans" ] || missing+=(".context/plans/")
[ -d "${local_root}/scripts" ] || missing+=(".context/scripts/")
for provider in jira slack vimeo meet figma; do
  [ -d "${local_root}/sources/${provider}" ] || missing+=(".context/sources/${provider}/")
done

if [ "${#missing[@]}" -eq 0 ]; then
  context="Read ${local_root}/AGENTS.md as supplementary local context after repository-tracked instructions. This repository has one shared context at ${shared_root}; linked worktrees access it through their .context symlink and must never create branch-specific context. Load only task-relevant files linked from it. Write context documents in English regardless of the conversation language; source records may use English or the source's original language. When external Jira, Slack, Vimeo, Meet, or Figma data is inspected or mutated, persist useful retrieved or resulting information under .context/sources/ during the same task; do not merely offer to save it. Every successfully created, read, or updated Jira issue, including an Epic, must create or refresh .context/sources/jira/<ISSUE-KEY>.md even after direct Atlassian MCP use. Maintain one document per Slack channel and one per Figma file. At the planning-to-implementation boundary, check whether the active plan has a Jira issue; if not, remind the user once and offer jira-worklog, but never write to Jira without a preview and explicit confirmation. Start its non-blocking background remote synchronization for .context/CHANGELOG.md when delegation is available; never change the working tree or tracked files."
else
  list="$(printf '%s, ' "${missing[@]}")"
  list="${list%, }"
  context="This repo is missing part of the local repository-context scaffold: ${list}. Use the repository-context skill to bootstrap the single shared context at ${shared_root}, create ${primary_root}/.worktrees/, and link .context in every linked worktree to the shared directory. Never create context per branch. Write context documents in English regardless of the conversation language; source records may use English or the source's original language. Add both /.context and /.worktrees/ to the shared .git/info/exclude, never modify remote/tracked CLAUDE.md, AGENTS.md, docs/, plans/, or .gitignore, and ask before creating INFRASTRUCTURE.md content that would require guessing."
fi

python3 -c '
import json, sys
print(json.dumps({
    "hookSpecificOutput": {
        "hookEventName": "SessionStart",
        "additionalContext": sys.argv[1],
    }
}))
' "$context"
