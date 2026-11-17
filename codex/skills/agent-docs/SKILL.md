---
name: agent-docs
description: Write, review, or troubleshoot agent instructions and skills. Use for global rules, AGENTS.md, skill entrypoints and references, configuration, plugins, or hooks. Read Claude-specific references only when editing Claude Code files.
license: MIT
---

# Agent instruction surfaces

Choose the narrowest surface that matches who needs the instruction and when it applies. Keep reusable prose separate from mechanisms that enforce permissions or run code.

Read [Codex instruction discovery](references/codex-instructions.md) when placing global or repository guidance, diagnosing precedence, or checking which instructions loaded. Read [Codex skills](references/codex-skills.md) when creating, installing, enabling, or troubleshooting a Codex skill. For Claude Code work, read [Claude instruction loading](references/claude-loading.md) for `CLAUDE.md`, `AGENTS.md`, rules, imports, and memory, [Claude skills](references/claude-skills.md) for skill format and discovery, [Claude subagents](references/claude-subagents.md) for agent definitions, or [Claude plugins and output styles](references/claude-plugins.md) for bundle and style behavior.

Use these boundaries.

- Put durable, repository-specific conventions and commands in `AGENTS.md`.
- Use a skill for a reusable workflow that applies only to some tasks. Keep its description a concise trigger and place conditional detail behind linked references.
- Use Codex configuration for runtime settings. A `model_instructions_file` replaces Codex's built-in instructions. It is not the same as project `AGENTS.md` guidance.
- Use hooks or permission controls only when a behavior needs runtime enforcement. Instruction text alone does not enforce a permission or a command rule.
- Keep one-off requirements in the current request rather than saving them globally.

Read [Instruction writing](references/instruction-writing.md) before writing or reviewing an agent instruction file, skill description, or reference. For Codex metadata or discovery, use the Codex skills reference above.

When an instruction appears missing, inspect the active Codex home and configuration, check for `AGENTS.override.md` and nearer repository files, and verify the current session's prompt input with `codex debug prompt-input` when the installed CLI provides it. Start a new session after changing instruction discovery settings. Read only the relevant configuration keys and do not print credentials or unrelated user data.
