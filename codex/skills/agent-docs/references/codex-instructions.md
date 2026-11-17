# Codex instruction discovery

The following discovery behavior was checked against the Codex documentation on 2026-11-17. Confirm the installed CLI documentation when a version-specific detail changes the result.

Codex constructs an instruction chain at the start of a run or TUI session. In the Codex home directory, it reads the first non-empty file, choosing `AGENTS.override.md` before `AGENTS.md`. From the project root to the current directory, it selects at most one file per directory in this order: `AGENTS.override.md`, `AGENTS.md`, then configured fallback filenames. It concatenates the selected files from root to current directory, so nearer guidance comes later. The documented default combined byte limit is 32 KiB, controlled by `project_doc_max_bytes`. See the [Codex AGENTS.md guide](https://developers.openai.com/codex/guides/agents-md).

`model_instructions_file` is a separate configuration surface. It replaces the built-in instructions; it does not replace project `AGENTS.md` files. The [Codex configuration reference](https://developers.openai.com/codex/config-reference#model_instructions_file) documents this distinction.

When diagnosing an unexpected instruction chain, check the current working directory, repository root, active `CODEX_HOME`, global override, nested override files, configured fallbacks, and size limit. Verify the chain with the current CLI's prompt inspection command or a fresh session. Do not change a user's override or enlarge the limit before confirming which file was selected or truncated.

`AGENTS.md` and skills steer model behavior, but they do not technically enforce access controls. Use the Codex permission and sandbox settings for access boundaries, and hooks only for a required runtime action. Read the [Codex configuration reference](https://developers.openai.com/codex/config-reference) for the installed version before changing those mechanisms.
