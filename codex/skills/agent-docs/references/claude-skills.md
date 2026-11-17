# Claude Code skill files

This Claude Code-only reference was tested with Claude Code 2.1.325. Skill mechanics and release gates may have changed; check the installed `claude --version` and the [current skill documentation](https://code.claude.com/docs/en/skills) before use. For Codex skill mechanics, use the Codex-specific instructions linked from `SKILL.md`.

## Format and discovery

Claude Code skills use a `SKILL.md` with a skill-specific frontmatter schema. The source gives limits and fields for `name`, `description`, `disable-model-invocation`, `user-invocable`, `allowed-tools`, `disallowed-tools`, `paths`, `context`, `model`, and `effort`. Do not copy those Claude-only fields into Codex metadata. Check the current Claude docs for supported values and behavior.

In Claude Code, the description drives implicit skill discovery. Write a concise, specific trigger and keep workflow instructions in the body. Claude's loading budget, description trimming, invocation options, and the behavior of `paths:` and `context: fork` are version-sensitive. A reference should be linked from the entrypoint with the condition for reading it, and a skill should not be forked when it only contains general guidance.

Claude Code's project, personal, managed, and plugin skill locations differ from Codex locations. Same-name precedence and collisions also vary by scope. Confirm the current documented location and collision behavior before installing or replacing a skill. Check for existing same-named skills and inspect their contents first. Use Codex's own skill reference when working on Codex metadata.

## Body and references

Keep task instructions in the skill entrypoint and load branch-specific technical detail only when needed. Use current runtime conventions for paths to bundled resources. Avoid embedding shell commands that execute before the skill body is read unless the current tool mechanism and failure behavior are intentional. Keep any tool allowlist narrow and confirm it does not silently grant a side effect.

## Testing

Test skill routing with realistic requests and near misses in fresh sessions, because the authoring context can make selection look more reliable than it is. For Claude plugins, use only the currently documented plugin validator and evaluation mechanism. Verify both task results and the tool/workflow behavior when that mechanism supports it. A parser check alone does not validate the skill's trigger description or workflow.
