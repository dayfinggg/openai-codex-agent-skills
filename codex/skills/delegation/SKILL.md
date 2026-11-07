---
name: delegation
description: Decides when to hand work to another agent, picks the provider, model, and effort from what the runtime offers, and writes a complete brief. Use before spawning any subagent, child task, or parallel agent, before delegating to a model of another provider, and when the user asks to delegate, parallelize, or run agents. Covers native subagents and child tasks in T3 Code, an app that runs agents from several providers.
---

<when_to_delegate>
A subagent starts without your conversation, re-explores, and reports back, so each one costs time and tokens. Delegate when the payoff clearly exceeds that cost. A fork is the exception, because it inherits your context and model. Use a fork only when the task needs this conversation.
- Delegate large reading or search work whose raw output you will not need again.
- Delegate independent, sizeable tracks that can run in parallel, such as unrelated modules or a wide audit.
- Delegate work the user asked to run on a specific provider, model, or agent.
- Delegate a fresh-context check of a risky change, as the `review` skill describes.

Do the work yourself when a few tool calls finish it, or when phases share context. The same holds when the task needs back-and-forth with the user. Also keep it when you do not yet know what is broken, or when agents would edit the same files.
</when_to_delegate>

<runtime>
Find out what the runtime offers before you choose a model. Never pick from memory or from a list in this skill.
- In T3 Code, the T3 orchestration instructions and tools are in your context. Follow them. Call the capabilities tool once per thread, and choose only from the providers, models, and options it returns.
- Outside T3 Code, use only the native subagent tool, such as `Agent` in Claude Code or `spawn_agent` in Codex. Choose only among the models its schema or the session lists.
- When the user names a provider or model that the runtime does not offer, say so. Do not switch to another one unasked.
</runtime>

<model_and_effort>
Match the model tier and effort to the task, and set the model explicitly. An omitted model inherits the parent's, which is usually the most expensive one. Set effort where the runtime offers it, by each tool's own rules.
- Lookups, search, and summaries go to the fastest, cheapest tier. A misread search result sends the parent after the wrong file, so ask for exact paths and quotes.
- Work with a clear spec and a check that proves it goes to the middle tier. Use medium or high effort there.
- Judgement-heavy, long-horizon, or ambiguous work goes to the strongest tier at high effort or above.
- Raise effort when edge cases matter. Switch to a stronger model when the same approach fails twice, because effort does not fix a wrong approach.
- Use the user's named model and settings when the user gives them.

Before you brief a model family for the first time in a session, read its current prompting guidance. For Claude models, invoke the `claude-api` skill, or read the prompting best practices at https://platform.claude.com/docs when it is unavailable. For GPT models, read OpenAI's current prompt guidance at https://developers.openai.com. For other providers, read their official prompting docs. Apply what you read to the brief.
</model_and_effort>

<brief>
The agent sees only the brief, so give the whole task once and precisely. Write it in English unless the task needs another language. Every brief covers these parts.
1. Goal and finish line. State what is wrong or wanted. Say what done looks like, such as "the suite passes 30 runs in a row".
2. Context. Give exact paths, the relevant facts you already know, and what you ruled out. Pass long material as file paths, not pasted text.
3. Scope. Name the files or modules the agent owns, and what it must not touch.
4. Rules. Point to the user's standing rules, because a subagent may not apply them unless the brief names them. Name the base instructions at `../../base_instructions.md` relative to this skill, as an absolute path. Ask the agent to follow its `output_style`, `code_rules`, and `verification` blocks. Name the skills that fit the task.
5. Proof. Say which check proves the work, such as a command, a test, or a screenshot. Ask the agent to report any check it could not run.
6. Stop conditions. The agent asks only when it cannot continue, or before a destructive or external action. It reports a blocker instead of working around it.
7. Return contract. Ask for a short report that opens with the outcome. It gives evidence with file and line, and it marks unverified claims.

Keep the brief at the level of goals and checks. Overly specific steps or "stop for review" lines make current models end early or over-ask.
</brief>

<parallel_work>
Run parallel agents only on independent tracks, and split them along file boundaries. Send all parallel spawns in one message so they run together. Give each agent that writes code its own checkout, such as a worktree, when the runtime offers one. Keep spawn counts low, and use one agent when one is enough.
</parallel_work>

<waiting>
Do not poll an agent, sleep, or re-brief it while it runs. Keep working on what does not depend on it, and follow the runtime's instructions for completion notices. Send a follow-up to a running agent only to correct its course. Cancel an agent you no longer need with the runtime's cancel tool.
</waiting>

<results>
Check each report's evidence before you accept it, such as the command, its output, and the cited lines. Do not redo the agent's work or re-derive its findings when the evidence holds. When several agents changed code, check for conflicts. Then run the project's checks on the combined result, as the `verification` block of the base instructions requires. Relay findings to the user in the output style, and name each agent or thread as the runtime shows it.
</results>
