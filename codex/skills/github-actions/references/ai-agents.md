# AI agent actions in workflows

Technical reference snapshot dated 2026-11-17, originally matched to claude-code-action 1.0.276, codex-action v1.13, and gh-aw 1.2.3. Verify the exact action versions and their official input documentation before applying these examples. Size every agent job for prompt injection on events an outsider can trigger. This file discusses actions configured in GitHub workflows, not tools available in the current Codex session.

## Where attacker text reaches the agent

- Directly: `${{ github.event.* }}` inside `prompt`, `system-prompt`, `claude_args` or `codex-args`, or a `prompt-file` the PR can change.
- Through env vars the prompt names. The `env:` fix that stops shell injection does not help when the agent reads `$ISSUE_BODY` itself.
- At run time: `gh issue view`, `gh pr view`, `gh pr diff` and API calls the agent makes return attacker text even when the prompt interpolates only a number.
- From the checkout: code comments, READMEs, `AGENTS.md` and config files in a PR head.
- From CI output: compiler errors, test failures, job logs, step names and step outputs of a fork build passed to an "auto-fix" agent.

## Containment

- Grant the agent job only the scopes its output needs. Prefer a read-only agent whose proposals a separate job applies.
- An allowlisted shell command is not containment. Arguments such as `$(env)` expand before the command runs, `git rebase --exec` runs programs, and a file the agent may write can be executed by a later step.
- Pass agent output to later steps through `env:`, never through `${{ steps.agent.outputs.* }}` in `run:`, `eval` or unquoted `$()`. Validate structured output against a schema before using any field. In claude-code-action, `--json-schema` in `claude_args` fills the `structured_output` output.
- Use `GITHUB_TOKEN` in agent jobs, not a personal access token. Injection can leak a long-lived token piece by piece across runs.

## Claude Code action

This section applies only to the Claude Code GitHub Action. Do not transfer its input names, flags, or permission modes to another action.

- Use `anthropics/claude-code-action@v1` with `prompt` and `claude_args`. The v0 inputs `direct_prompt`, `override_prompt`, `custom_instructions`, `allowed_tools` and `disallowed_tools` became `prompt`, `--append-system-prompt`, `--allowedTools` and `--disallowedTools`. The v1 `action.yml` no longer declares the old names, so they configure nothing. Review the field names in the file, not the `@` ref, since old files pinned to `@v1` still carry them.
- Only users with write access trigger it by default. `allowed_non_write_users` lifts that check, works only with `github_token: ${{ secrets.GITHUB_TOKEN }}`, and belongs only in jobs with narrow permissions such as labeling.
- Bots in `allowed_bots` are not permission-checked. `allowed_bots: '*'` on a public repository lets any GitHub App start runs with a prompt it controls.
- For `workflow_run` events the action also checks the actor who started the upstream run and, for fork runs, the fork's owner.
- `restrict_untrusted_prs` (default `true`) denies package managers, test runners, interpreters and shells on PRs from authors without write access, and bots count as such authors. It is a command list, not a sandbox: a rule such as `Bash(./scripts/test.sh)` stays allowed, and runs on `workflow_run`, `workflow_dispatch`, `repository_dispatch` and `schedule` are not covered.
- The default auto permission mode is a safety review, not a boundary. Use `--permission-mode acceptEdits` or `default` in `claude_args` when only listed tools may run.
- `show_full_output: true` writes tool results, including secrets, to the run log, and debug mode (`ACTIONS_STEP_DEBUG`) turns it on automatically. Public repositories expose those logs to everyone.
- Turn off the tools that read PR-controlled job logs and run details with `--disallowedTools "mcp__github_ci__download_job_log,mcp__github_ci__get_workflow_run_details"` in `claude_args`. Allowed `gh` commands can still reach the logs.
- For `pull_request_target` or `workflow_run`, never check out the PR head into the workspace root before the action, because Claude runs there. Check out the base at the root and the PR head with `path: pr-head`, then pass `--add-dir pr-head`.
- On PRs the action restores `.claude/`, `.mcp.json`, `.claude.json`, `.gitmodules`, `.ripgreprc`, `CLAUDE.md`, `CLAUDE.local.md` and `.husky/` from the base branch. `package.json`, lockfiles and `Makefile` stay at the PR head, so a base hook that calls `npm run` or `make` executes PR code. Keep hooks self-contained, for example `bunx prettier@3.5.3 --no-config --write .` instead of `bun run format`.
- `claude-code-base-action` skips the actor checks, the command restrictions and the base-config restore.

## Other agent actions

- `openai/codex-action`: set `permission-profile: ":read-only"` or `":workspace"`. `sandbox: danger-full-access` or `safety-strategy: unsafe` removes containment, and Windows runners support only `unsafe`. `allow-users: '*'` lets anyone trigger it.
- `actions/ai-inference` has no tools, but its output is attacker-steerable and lands in the next step.
- `google-github-actions/run-gemini-cli` gets the same review: what text reaches the prompt, which tools the CLI may run, and which token the job holds.

## gh aw agentic workflows

- GA 2026-10-28, CLI `gh extension install github/gh-aw`. The source is `.github/workflows/<name>.md`, and `gh aw compile` writes `<name>.lock.yml`. Commit both and never edit the lock file by hand.
- Recompile after frontmatter changes. The Markdown body loads at run time, so instruction edits need no recompile.
- Keep `permissions:` read-only and declare writes under `safe-outputs:` (for example `create-issue:` or `add-comment:`). A separate job applies them after a threat-detection job.
- With the Copilot engine in an organization repository, `permissions: copilot-requests: write` uses the workflow token for inference, and `COPILOT_GITHUB_TOKEN` is then ignored.
