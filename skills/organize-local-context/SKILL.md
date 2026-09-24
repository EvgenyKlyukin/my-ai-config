---
name: organize-local-context
description: Audit uncommitted repository files and organize clear local-only plans, notes, project context, infrastructure records, and external-source material into the ignored .context/ structure. Use when the user asks to review or clean up uncommitted files according to the repository-context convention; do not use for ordinary code formatting or commit preparation.
---

# organize-local-context

Organize local-only artifacts without hiding or relocating legitimate product
changes. Follow the `repository-context` convention for the destination
structure, language, source records, and tracked-file boundaries.

Use one shared context store for the entire Git repository. Resolve the primary
worktree from the first `worktree` entry in `git worktree list --porcelain` and
treat `<primary-worktree>/.context/` as the only destination. In a linked
worktree, `.context` must be a symlink to that shared directory; never create,
populate, or preserve a separate branch-specific context as the active store.

## Safety Boundary

- Never run `git clean`, `git reset`, `git restore`, `git checkout`, or another
  command that discards working-tree content.
- Never move or rewrite staged files automatically.
- Never move modifications to tracked files automatically, including tracked
  `AGENTS.md`, `CLAUDE.md`, `docs/`, `plans/`, source code, configuration, or
  tests. Report them as product changes unless the user explicitly confirms
  that specific content is personal local context.
- Move an untracked file automatically only when its contents and purpose make
  the local-only classification unambiguous. Ask before moving an ambiguous
  file, a generated artifact that might belong to the project, or anything
  whose relocation could break references.
- Never copy credentials, tokens, cookies, private keys, or secret values into
  `.context/`. Stop and report the path if suspected secrets are found.
- Never replace, delete, or silently merge a real `.context/` directory found
  inside a linked worktree. Stop, report it as a context conflict, and ask how
  its unique content should be preserved or merged into the primary shared
  context.
- Preserve every unrelated working-tree change.

## Workflow

1. Resolve the current worktree root and the primary worktree root. Set the
   shared destination to `<primary-worktree>/.context/`.
2. If running in a linked worktree, verify that its `.context` is a symlink
   resolving exactly to the shared destination. If it is missing, use the
   `repository-context` workflow to create the link. If it is a real directory
   or points elsewhere, stop and report the conflict instead of organizing
   files into it.
3. Read repository-tracked instructions, then read the shared
   `.context/AGENTS.md` and only the local files needed to classify the current
   changes. If the primary scaffold is missing or incomplete, use the
   `repository-context` workflow to create it first.
4. Inspect all working-tree states with:

   ```bash
   git status --short --untracked-files=all
   git diff --name-status
   git diff --cached --name-status
   ```

5. Inspect the content of untracked candidate files. Do not classify from the
   filename alone. Separate files into:

   - safe local-context moves;
   - legitimate product or repository changes that remain untouched;
   - ambiguous files requiring one concise confirmation;
   - suspected secrets requiring an immediate stop for those files.

6. Move safe local-only artifacts to the matching destination under the shared
   `<primary-worktree>/.context/`. Paths beginning with `.context/` below refer
   to that shared directory even when the skill runs from a linked worktree:

   | Content | Destination |
   | --- | --- |
   | scoped project knowledge | `.context/contexts/<topic>.md` |
   | reusable personal documentation or notes | `.context/docs/<slug>.md` |
   | implementation plan | `.context/plans/YYYY-MM-DD-<slug>.md` |
   | repository-specific local automation | `.context/scripts/<script-name>` |
   | environment and access procedures without secrets | `.context/INFRASTRUCTURE.md` |
   | Jira material | `.context/sources/jira/<stable-resource-slug>.md` |
   | Slack material | `.context/sources/slack/<channel-slug>.md` |
   | Vimeo material | `.context/sources/vimeo/<video-id-or-stable-slug>.md` |
   | Meet material | `.context/sources/meet/<meeting-id-or-date-slug>.md` |
   | Figma material | `.context/sources/figma/<file-key-or-stable-slug>.md` |

7. Keep scripts under the shared `.context/scripts/` and out of remote Git
   history. Store their environment values in adjacent `.env` files, using
   `.env.<script-name>` for separate environments. Never embed credentials,
   tokens, cookies, or private keys in script source. Keep secret-bearing
   environment files at mode `600`, populate them through secure secret
   handoff, and never inspect or display their values while organizing files.
8. Preserve content and useful provenance while normalizing it to the target
   document convention. Context documents are English. Source records may use
   English or the source's original language.
9. For Slack, maintain exactly one document per channel. Identify the channel
   by stable channel ID when available and merge new material into the existing
   channel document instead of creating another file. Do not discard existing
   valid content during a merge.
10. For Figma, maintain exactly one document per file. Identify it by stable file
   key when available and merge inspected pages, frames, components, variables,
   design decisions, and relevant node links into the existing file document.
11. Update the shared `.context/AGENTS.md` only when a moved document or script
   is broadly useful and should be discoverable from the canonical map. Do not
   list every source record individually.
12. Verify the result:

   ```bash
   git check-ignore -q .context
   git status --short --untracked-files=all
   git diff --check
   ```

   Confirm that `.context` resolves to the primary shared directory in a linked
   worktree, every moved artifact exists in that shared destination before
   removing its original untracked path, and no tracked content changed as a
   side effect.

## Report

Summarize:

- files moved and their destinations;
- files deliberately left as product changes;
- ambiguous files awaiting a decision;
- suspected-secret paths without exposing their contents;
- scaffold or map updates performed;
- the primary shared context path and whether the current worktree symlink was
  verified or repaired.

Do not commit the result unless the user separately requests a commit and then
confirms the exact proposed commit title and tracked file list.
