# Workers outside the native Codex agent tool

Use this reference only when the user or an applicable instruction selects an external CLI, another provider, or a host delegation tool. Check the installed command's current `--help` and official documentation before using version-dependent options. The examples do not replace the installed CLI documentation.

## Shared rules

- An external worker does not receive this conversation, Codex skills, or local context unless its brief or command supplies them. Give it the applicable instructions, exact paths, allowed files, check commands, and finish conditions.
- Keep credentials out of prompts, process arguments, temporary prompt files, and logs. Use the CLI's existing login or the credential channel that its official documentation recommends.
- Use an isolated checkout for edits when the selected runtime supports it. Otherwise give concurrent workers disjoint file ownership and preserve all existing changes.
- A worker's report is not verification. Check its exit state, changed files, diff, and relevant test evidence before integrating its work.
- Find out whether an external worker charges a different account or uses different permissions before launching it.

## Codex CLI

The source release's example uses `codex exec` with `-C`, `-o`, a workspace sandbox, and optionally `--worktree`. Check the current `codex exec --help` before applying it. Do not use an approval-bypass or unrestricted-sandbox flag merely to make a headless worker run. The user must authorize any external action, and a worker must not exceed that scope.

## Other provider CLIs

The source release included examples for Gemini CLI, Cursor CLI, and Claude Code. Their flags, trust modes, approval modes, and output formats change independently. Read the installed CLI help and official docs before using them. Do not assume that a short option has the same meaning across tools.

## Host and MCP delegation tools

Read the selected tool description before dispatch. Confirm its provider, model options, isolation behavior, permission model, completion signal, and whether it runs synchronously or asynchronously. Do not poll an asynchronous task when the runtime provides a completion notification. Pass only the minimum context needed for the assigned work.
