<skill_mechanics>
This file is the skill-specific branch of [SKILL.md](../SKILL.md). It covers frontmatter, invocation, the skill listing, and router skills. Everything else about writing a skill is the general reference in `../SKILL.md`. The facts follow the [Codex skills documentation](https://learn.chatgpt.com/docs/build-skills) and the [Agent Skills specification](https://agentskills.io/specification). Check the current documentation before relying on version-dependent mechanics.
</skill_mechanics>

<frontmatter>
A skill is a directory with `SKILL.md`, which starts with YAML frontmatter containing `name` and `description`. The name matches the directory, uses lowercase letters, digits, and hyphens, and has at most 64 characters. The description states what the skill does and when to use it, with at most 1024 characters. Preserve applicable license and metadata fields. Scripts, references, and assets are optional resources, not required scaffolding.

Use Codex-supported invocation settings in `agents/openai.yaml`, rather than another harness's frontmatter. When you write a skill for Claude Code or another harness, check that harness's own documentation instead of transferring Codex fields or context budgets to it.
</frontmatter>

<invocation>
Codex offers explicit and implicit invocation. In the CLI or IDE extension, the user can type `$` to mention a skill or use `/skills`. Implicit invocation matches the task against the skill's description. Invocation policy lives in the skill's optional `agents/openai.yaml` file.

| Policy | User can invoke | Codex can select implicitly |
| :- | :- | :- |
| Default | Yes | Yes |
| `policy.allow_implicit_invocation: false` | Yes | No |

<model_invoked>
The default keeps the skill discoverable for automatic selection. Its description is the top-level context pointer. Write a model-facing description with the trigger branches, and apply the pointer rules in `../SKILL.md` in full. A reference-only skill can hold guidance that several workflows need when independent discovery earns the listing cost. Otherwise link those workflows to one plain reference file.
</model_invoked>

<user_invoked>
An explicit-only skill sets this policy in `agents/openai.yaml`.

```yaml
policy:
  allow_implicit_invocation: false
```

The user still invokes it with `$skill-name`, but Codex does not activate it implicitly from the prompt. This spends cognitive load because the human must know when to select it. Keep normal automatic discovery unless the user requests explicit-only invocation, and preserve an existing policy unless the user asks to change it. A workflow's side effects still need the authorization that the user and runtime require, regardless of invocation policy.

The documented policy controls implicit invocation. Do not assume that it removes metadata from the listing or prevents every file read. Codex documents no equivalent here for hiding a skill from users while leaving it model-invocable. Use the default for background reference that needs automatic discovery.
</user_invoked>

Choose independent discovery when the agent or another workflow needs to reach the skill without the user selecting it. For shared reference that explicit-only workflows need, link each workflow to one plain file instead of relying on implicit activation of another skill.
</invocation>

<the_listing>
Codex starts with skill names, descriptions, and file paths. The initial list defaults to at most 2 percent of the model's context window, or 8000 characters when the window is unknown. If the list grows too large, Codex shortens descriptions first and may omit skills with a warning. `skills.max_context_tokens` can set a different listing budget, up to 10000 tokens. This budget does not truncate a selected skill's full body.

Front-load the key use case and trigger words so a shortened description still routes correctly. Validate YAML and required fields before installation, because malformed metadata cannot provide a reliable discovery pointer.
</the_listing>

<the_body>
Codex reads the full `SKILL.md` when it selects the skill, then reaches supporting resources as the task needs them. Put shared constraints and routing in the entrypoint, and link branch-specific detail with the condition for reading it. The Agent Skills specification recommends an entrypoint under 500 lines.

Write instructions that remain useful across the task, with clear completion criteria for ordered steps. After compaction, reread each skill still in use as the base instructions require. Do not assume another harness's message retention, automatic reattachment, or token limits apply to Codex.
</the_body>

<splitting_by_invocation>
The invocation cut is the skill-specific way to split, while the sequence cut lives in `../SKILL.md`. Split off an automatically discoverable skill when a distinct leading word should trigger it on its own, or another workflow needs that independent entrypoint. The description spends listing space, so the independent reach must earn it. Reading another skill in the current conversation does not create a fresh context.
</splitting_by_invocation>

<router_skills>
Explicit-only skills can multiply past what a human remembers. A router gives the human one entrypoint that names those workflows and when to select each. For an explicit-only destination, have the user select the named skill rather than relying on implicit activation. Keep shared guidance in linked references when it needs no independent invocation. A router is useful only when it reduces the human's indexing work enough to earn another entrypoint.
</router_skills>
