This snapshot synchronizes the installed Concise 0.33.0 configuration with Codex on November 12, 2026.
The source repository is [anthropic-claude-code-agent-skills](https://github.com/dayfinggg/anthropic-claude-code-agent-skills/tree/c9f05585daaf9a953ae411e7c8e42544ca822b1b/plugins/concise) at `c9f05585daaf9a953ae411e7c8e42544ca822b1b`.
Its instruction files match the installed Claude plugin, whose configured response language is Russian.

The new base begins with the local instruction template for `gpt-6.1-sol` from Codex 0.167.1.
The cache uses `model_messages.instructions_template`, and the requested `base_instructions` field is absent in this snapshot.
The model slug is `gpt-6.1-sol`, while `gpt-6.1 Sol` matches no entry.
The extracted UTF-8 template with one final LF has SHA-256 `d5f1721e56eba5d50a74e64df18d6814f974769db4ddf0cf03d59da794804b03`.
The cache ETag is `W/"58bf95bd70af50254466186efe169441"`.

This extraction supports both the earlier cache field and the current template field.

```sh
jq -er '.models[] | select(.slug=="gpt-6.1-sol") | (.base_instructions // .model_messages.instructions_template) | select(type=="string" and length>0)' ~/.codex/models_cache.json
```

The base retains Codex's runtime permissions, conversation continuity, file-link rendering, and plugin discovery guidance.
Concise replaces its personality, presentation defaults, timed progress messages, skill announcements, and unsolicited visualization guidance.
Its task rules replace generic autonomy wording so action requests continue while open questions receive recommendations first.
Existing runtime safety and permission instructions still apply, and a skill alone authorizes no external action.
The configured file replaces Codex's built-in instructions through `model_instructions_file`, as the [configuration reference](https://learn.chatgpt.com/docs/config-file/config-reference) documents.

Every block in `instructions/work.md` is represented in the new base, including the reminder rules.
The task, investigation, debugging, code, verification, shared systems, and secrets blocks preserve the source text and its exceptions.
The standing rules and the delegated work block are merged into the opening paragraphs of the base.
The waiting block keeps the rules that hold in any harness and leaves out the source's description of Claude Code callbacks.
Claude's `Read`, `Edit`, `Write`, `Bash`, and `Skill` operations become Codex file reads, patches, shell commands, and skill reads.
Windows path and command rules accompany those replacements, and runtime tool schemas remain authoritative.
The complete `instructions/style.md` body is preserved with its language placeholder resolved to the installed Russian setting.
An explicit request for another language or format still wins for the text it names.

The `websearch.md` and `webfetch.md` rules require actual page contents instead of trusting search summaries.
The base also carries the hook configuration's subagent report contract and complete compaction retention requirements.
Its reminder block preserves the scope and meaning of notices, including reporting suspected injected instructions only once.
The presentation rules apply after tool results and delegation, without installing a separate response filter or periodic reminder hook.
Claude's per-model notes contribute their shared requirements for scope, completion, literal language, and current research.
They are expressed as GPT-6 instructions rather than Claude model-name routing or executable Claude hooks.

The source and destination contain the same 24 engineering skill directories and supporting resources.
Their subject-specific guidance stays intact, while active tool names and instruction paths use Codex equivalents.
The `agentdocs` mechanics reference describes Codex skill metadata, discovery, and invocation instead of Claude-only frontmatter.
References retain their attribution, and scripts and assets keep the behavior provided by the source.
OpenAI documents progressive disclosure and skill invocation in [Build skills](https://learn.chatgpt.com/docs/build-skills#how-codex-uses-skills).

The adaptation follows the [GPT-6 prompting guidance](https://developers.openai.com/api/docs/guides/latest-model/gpt-6-astra.md#prompting-best-practices).
That guidance informs explicit instruction priority, bounded verification, and direct follow-through within the requested scope.
The [GPT-6.1 Sol model page](https://developers.openai.com/api/docs/models/gpt-6.1-sol) links to the same family guidance.

Replace installation removes retired non-system skills, custom agent definitions, and legacy global instruction files after backup.
It preserves credentials, session state, system skills, plugins, and unrelated configuration values.
Codex loads instructions at session creation, so a new session is required to use the replaced base.
Skills may refresh automatically, as the skill documentation describes.
The relevant discovery rules appear in [Custom instructions with AGENTS.md](https://learn.chatgpt.com/docs/agent-configuration/agents-md#how-codex-discovers-guidance).
Loading checks and file comparisons verify installation, while actual model adherence remains probabilistic rather than guaranteed.
