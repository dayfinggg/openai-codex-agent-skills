# Sources

These sources were inspected on 2026-08-17. Apply their transferable principles, but follow the current host's tools, permissions, and instruction hierarchy.

1. [OpenAI GPT-5.6 model guidance](https://developers.openai.com/api/docs/guides/latest-model) supports lean prompts, explicit autonomy and approval boundaries, outcome-focused instructions, defined response content, and evaluation on representative tasks.
2. [OpenAI Multi-agent guide](https://developers.openai.com/api/docs/guides/responses-multi-agent) supports delegation for concrete independent workstreams and focused contexts, while warning about token cost, ordered reasoning, shared mutable state, and slow external bottlenecks.
3. [OpenAI agent orchestration and handoffs](https://developers.openai.com/api/docs/guides/agents/orchestration) describes orchestration patterns and handoffs for agent workflows.
4. [OpenAI agent evaluations](https://developers.openai.com/api/docs/guides/agent-evals) supports trace grading to diagnose workflow-level failures across model calls, tools, guardrails, and handoffs.
5. [OpenAI skill authoring guide](https://learn.chatgpt.com/docs/build-skills) defines progressive disclosure, focused skills, imperative steps, explicit inputs and outputs, trigger testing, and optional references, scripts, and metadata.
6. [Open Agent Skills specification](https://agentskills.io) defines the portable `SKILL.md` format and naming and metadata constraints.
7. [Cursor agent best practices](https://cursor.com/blog/agent-best-practices) recommends concise rules, pointers to canonical examples, specific prompts, verifiable goals, careful review, and isolated worktrees for parallel work.
8. [Cursor rules documentation](https://docs.cursor.com/context/rules-for-ai) recommends focused, actionable, scoped rules, concrete examples, and composable files.
9. [OpenCode agents documentation](https://opencode.ai/docs/agents) demonstrates task-specific primary and subagents with explicit model, tool, and permission boundaries.
10. [OpenCode skills documentation](https://opencode.ai/docs/skills) documents on-demand skills, strict naming, descriptive triggering, and per-agent skill permissions.
11. [OpenAI skills repository](https://github.com/openai/skills) provides current official examples and the skill creator used to initialize and validate this skill.
12. [Community agents-best-practices skill](https://github.com/DenisSergeevitch/agents-best-practices/blob/main/SKILL.md) was reviewed as a broad community synthesis. This skill keeps only recommendations consistent with stronger primary sources and the local Codex runtime.
