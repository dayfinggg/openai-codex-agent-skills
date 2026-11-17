# Spec Kit, Kiro and OpenSpec

Use the format already adopted by the repository. Do not add another spec system for one task. Check the installed CLI version and official docs before using version-sensitive commands.

## Detect the format

- `.specify/` with `specs/NNN-name/` identifies Spec Kit.
- `.kiro/specs/<feature>/` with `.kiro/steering/` identifies Kiro.
- `openspec/specs/` with `openspec/changes/` identifies OpenSpec.

## Spec Kit

Spec Kit's Codex integration installs skills under `.agents/skills/speckit-<command>/SKILL.md`. Invoke a workflow from Codex with its dollar-prefixed skill name, such as `$speckit-specify` or `$speckit-plan`. The integration guide documents the current setup at [Spec Kit Codex integration](https://github.com/github/spec-kit/blob/main/docs/integrations/codex.md).

- To initialize a project when the user asked for setup, use the current documented Codex integration, such as `specify init <project> --integration codex`. For an existing project, inspect `specify integration install codex` and the local CLI help.
- Setup writes project files and may register native Codex events. Read the plan and exact integration behavior before invoking a mutating setup command.
- The common flow is constitution once, then specify, plan, tasks, implement, and converge for each bounded change. Use the installed skills as the source for their exact names and current instructions.
- Optional clarification, checklist, and analysis stages depend on the project workflow. Check their current skills before using them.
- Keep `spec.md` about observable behavior and its motivation. Put stack choices and implementation details in the plan or design artifact.
- Record only principles supported by current repository evidence or accepted team decisions in a constitution. Do not make a new convention load into every later task unless the team wants it.
- For an existing project, specify one bounded change rather than restating the whole system.

## Kiro

- A feature spec normally contains `requirements.md` (or `bugfix.md`), `design.md`, and `tasks.md`.
- Express requirements as observable behavior, for example, `WHEN <condition> THE SYSTEM SHALL <behavior>`.
- When requirements change, update the requirements first, then the design and tasks so they stay aligned.
- Steering files live in `.kiro/steering/`. Read their front matter and inclusion rules before assuming when they load.
- A `#[[file:relative/path]]` directive refers to a live file. Check the installed Kiro documentation before editing inclusion or linkage syntax.

## OpenSpec 2.0

OpenSpec 2.0 installs its Codex skills in `.agents/skills/openspec-*/SKILL.md` and removes the old `/opsx:*` command files. Invoke workflows in Codex with skill names such as `$openspec-propose`. See the [OpenSpec supported tools](https://github.com/Fission-AI/OpenSpec/blob/main/docs/supported-tools.md) and [OpenSpec 2.0 changelog](https://github.com/Fission-AI/OpenSpec/blob/main/CHANGELOG.md).

- Current specs live in `openspec/specs/<capability>/spec.md`. A change normally includes `proposal.md`, `design.md`, `tasks.md`, `.openspec.yaml`, and delta specs under `specs/`.
- Requirements use `### Requirement: <name>` and scenario blocks. Validate with the installed CLI and check `openspec validate --help` for current strict and JSON options.
- A modified requirement replaces its old text, so include the complete new requirement and every scenario. Use ADDED, MODIFIED, or REMOVED delta headings as documented.
- A change with no spec delta may need `skip_specs: true`, for example for a refactor or docs change. Removing a capability's last requirement may need `retire_capabilities: true`.
- OpenSpec initialization and updates rewrite managed project files. Read the migration guide and inspect `git diff` before accepting a change. Do not overwrite managed skills or run an upgrade unless the user's task includes it.
- Give each change one clear intent that fits in one sentence.
