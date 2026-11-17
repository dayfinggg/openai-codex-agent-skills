# Claude Code plugins and output styles

This Claude Code-only reference was tested with Claude Code 2.1.325. Check the [current plugin documentation](https://code.claude.com/docs/en/plugins-reference) and [output style documentation](https://code.claude.com/docs/en/output-styles) before relying on a manifest key, lifecycle event, path, or limit.

Claude plugins can package skills, commands, agents, hooks, MCP servers, and output styles. These component scans, manifest paths, environment substitutions, and reload rules are Claude-specific. A plugin's hooks or manifest do not become Codex hooks or config when files are copied. Choose a supported Codex surface for each required behavior.

The source snapshot says Claude plugin roots do not load `CLAUDE.md` as project context, and describes manifest component keys, plugin skill namespaces, bundled resource variables, plugin agent field limits, and plugin validation. Confirm all details against the installed Claude release. Keep durable instructions in the supported Claude skill or instruction mechanism and use a hook only when runtime enforcement is required.

Claude output styles configure response behavior across a session and have their own frontmatter. They are instructions, not enforcement. Their effects on built-in coding instructions, subagents, settings precedence, startup reload, and plugin overrides are Claude-specific. Preserve the user's existing style and do not transfer these fields into Codex skill metadata.

For Claude plugin validation and behavioral evaluations, check current `claude plugin --help` and official docs. A manifest or frontmatter validator does not prove that a skill triggers usefully or improves task results.
