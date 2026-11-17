# Claude Code subagent definitions

This Claude Code-only reference was tested with Claude Code 2.1.325. Check `claude --version` and the [current subagent documentation](https://code.claude.com/docs/en/sub-agents) before using version-sensitive fields.

Claude subagent definitions use their own frontmatter, tool names, model aliases, isolation behavior, skills preload, memory, and inheritance rules. Those fields do not configure Codex native agents. In particular, a Claude tool allowlist or `model` field is not an authorization or model selection for a Codex worker.

When writing a Claude subagent, confirm the current schema for required metadata, allowed and denied tools, nested delegation, model choice, context isolation, memory, and permission mode. Write its body as a complete brief for one task only when the runtime treats that body as the worker's prompt. State the job, relevant input, scope, check, and return contract in terms that worker can access. Rules that a worker must follow should be passed explicitly if its runtime omits parent instructions.

Before dispatching multiple Claude agents, check current concurrent-task and nesting limits, isolation behavior, background tool availability, and how completion is signaled. Give editing workers non-overlapping ownership or independent worktrees. A worker's report is a claim; verify the actual diff and relevant check results before accepting it.
