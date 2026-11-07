<skill_mechanics>
This file is the skill-specific branch of [SKILL.md](../SKILL.md). It covers what changes for a skill, meaning frontmatter, the invocation choice, the skill listing, and router skills. Everything else about writing a skill is the general reference in `../SKILL.md`. The facts follow the [Claude Code skills documentation](https://code.claude.com/docs/en/skills).
</skill_mechanics>

<invocation>
Two frontmatter fields set who can invoke a skill, and each choice trades the two loads. This table shows the three settings.

| Frontmatter | User can invoke | Claude can invoke | Context load |
| :- | :- | :- | :- |
| (default) | Yes | Yes | Description always in context |
| `disable-model-invocation: true` | Yes | No | Description not in context |
| `user-invocable: false` | No | Yes | Description always in context |

<model_invoked>
A model-invoked skill is the default. It keeps a description in the listing, so the agent can fire it on its own. Other skills can reach it too. The user can still type its name. The description is the skill's top-level context pointer and stays loaded every turn. That is permanent context load in exchange for discovery. A model-invoked skill whose content is all reference is one home for shared reference. Another skill can tell the agent to invoke it, so reference that several skills need lives in one place. Write a model-facing description that carries the trigger branches, and apply the pointer rules in `../SKILL.md` in full.
</model_invoked>

<user_invoked>
A user-invoked skill sets `disable-model-invocation: true`. Its description leaves the agent's context, so only the human typing its name can invoke it. If the agent calls it through the Skill tool anyway, Claude Code blocks the call. So no other skill can fire it, and subagents cannot preload it. It costs no context load but spends cognitive load, because you are the index that must remember it exists. Its description becomes human-facing, a one-line summary without trigger lists. The docs recommend it for workflows with side effects or timing the user controls, such as deploy or commit.
</user_invoked>

<model_only>
A model-only skill sets `user-invocable: false`. Claude Code hides it from the `/` menu, so only the agent can invoke it. Use it for background knowledge that makes no sense as a command for the user. Its description costs the same context load as the default.
</model_only>

Pick model invocation only when the agent must reach the skill on its own, or another skill must. A skill that only ever fires by hand, with side effects or timing that matters, can be user-invoked. It then costs no context load.

Shared reference that two user-invoked skills both need can live in neither. Neither has a description in context, so neither can fire the other. Put that reference in a plain file outside the skill system, as external reference any skill can point at.
</invocation>

<the_listing>
Claude Code loads a listing of every skill's name and description into context on every turn. Three facts shape how a description should read.
- The `description` field, plus the optional `when_to_use` field appended to it, is cut at 1,536 characters in the listing. Put the key use case first.
- The whole listing has a budget of 1% of the model's context window by default. On overflow, Claude Code drops descriptions from the least invoked skills first. Those skills then list by name only.
- If the frontmatter YAML is malformed, the skill loads with empty metadata. The user can still type its name, but the agent cannot match its description.
</the_listing>

<the_body>
Invoking a skill adds its rendered `../SKILL.md` content to the conversation as one message. It stays there on later turns. Claude Code does not re-read the file. So write guidance that applies to the whole task as standing instructions, not one-time steps.

After auto-compaction, Claude Code re-attaches the most recent invocation of each skill but keeps only its first 5,000 tokens. All re-attached skills share a budget of 25,000 tokens, filled from the most recently invoked skill. So put the most important instructions near the top of `../SKILL.md`.

The docs ask for a `../SKILL.md` under 500 lines. Move detailed reference to separate files in the skill folder. Link each one from `../SKILL.md` with the condition for reading it.
</the_body>

<splitting_by_invocation>
The invocation cut is the skill-specific way to split, while the sequence cut lives in `../SKILL.md`. Split off a model-invoked skill in two cases. One is a distinct leading word that should trigger it on its own. That word is one you actually use in your prompts. The other is another skill that must reach it. The new description costs context load on every turn, so that independent reach has to be worth it.
</splitting_by_invocation>

<router_skills>
User-invoked skills can multiply past what you can remember. A router skill cures that cognitive load. It is one user-invoked skill that names the others and when to reach for each. The human then remembers one skill instead of many. It can only hint and never fire them. The others have no description in context, and Claude Code blocks the agent's calls to them. So only the human can invoke them.
</router_skills>
