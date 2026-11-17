# Repeatable verification workflows

Read this file when creating or revising a project runbook, a CI gate, or a method for evaluating test or review quality. It does not add a mandatory check to ordinary changes.

## Record a runbook

- Store reusable project workflows as a focused skill under `.agents/skills/`, and link it from applicable project instructions when the workflow is hard to discover.
- Describe the environment, command, input, observable result, cleanup, and likely failure signals. Keep secrets in the project's credential store or environment, never in the skill.
- Run the workflow from a clean or isolated checkout and remove fixed sleeps. Preserve a reusable recipe only when it is stable and useful across tasks.

## Design a trustworthy gate

- Keep the rule that judges a change outside the candidate change when possible. A change should not silently weaken its own required check.
- A useful gate reports which rule failed and which changed input triggered it. Test a representative violation and a clean control before relying on it.
- Prefer a short, diff-triggered checklist to a large universal list. Each item should name the changed surface, the relevant check, and the failure it prevents.
- Measure a check or reviewer against known failures and clean controls. Separate raw findings, verified findings, and final reports so that missed problems and false positives remain visible.
- Add a durable rule after the same recognizable failure pattern repeats and the rule distinguishes real failures from clean cases. Remove rules that no longer improve the result.

Codex instructions do not enforce a gate mechanically. When the user requests automatic enforcement, use the repository's existing CI or check mechanism and keep its authorization and review boundary intact.
