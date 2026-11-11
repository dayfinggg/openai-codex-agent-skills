---
name: delegation
description: Picks the provider, model, and effort for another agent and writes its complete brief. Use it before the first subagent, child task, or parallel agent of a task, whenever the user asks to delegate, parallelize, or run agents, and before handing work to a model of another provider.
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
Match the model tier and effort to the task, and set the model explicitly. An omitted model falls back to the runtime's default, often the parent's model, which can be the most expensive one. Set effort where the runtime offers it, by each tool's own rules.
- Lookups, search, log reading, and summaries go to the fastest, cheapest tier at its default effort, because a mistake there is cheap to spot. A misread search result still sends the parent after the wrong file, so ask for exact paths and quotes, and keep code edits and judgement calls off this tier.
- Work with a clear spec and a check that proves it goes to the middle tier, and so does a well-defined task you run often, such as a review. Use medium or high effort there.
- Judgement-heavy, long-horizon, or ambiguous work goes to the strongest tier, starting at medium effort and rising to high.
- When a result falls short, first make sure the agent has a check it can run, then raise effort one level, then move up one tier and start there at a lower effort than the smaller model used. Past high effort the next tier up can cost no more than another effort level, and effort does not fix a wrong approach.
- Use the user's named model and settings when the user gives them.

Before the first brief of a session to a model family, read that provider's current prompting guidance and apply it. For GPT-6 models, use [OpenAI's GPT-6 prompting guidance](https://developers.openai.com/api/docs/guides/latest-model/gpt-6-astra.md#prompting-best-practices). For Claude or another provider, read that provider's official guidance. Keep the user's requested provider, model, settings, and scope.
</model_and_effort>

<brief>
The agent sees only the brief, so give the whole task once and precisely. Write it in English unless the task needs another language. Every brief covers these parts.
1. Goal and finish line. State what is wrong or wanted. Say what done looks like, such as "the suite passes 30 runs in a row".
2. Context. Give exact paths, the relevant facts you already know, and what you ruled out. Pass long material as file paths, not pasted text. State the agent's own task in your words, because the user's message addresses you and can mislead the agent. Quote the user's wording only where the agent must judge against it, such as a spec, and then once, without a translation.
3. Scope. Name the files or modules the agent owns, and what it must not touch.
4. Rules. Follow the runtime's rules for inherited instructions, and pass any required rules the subagent does not receive, without repeating or rewording the rules it already has. For an agent of another provider, name the base instructions at `../../base_instructions.md`, relative to this skill, as an absolute path, and ask it to follow their `writing_style` block and coding instructions with its own tools. Name applicable project `AGENTS.md` files and the skills that fit the task, and add only the limits that this task sets, such as the hosts and data the agent may change.
5. Proof. Say which check proves the work, such as a command, a test, or a screenshot. Ask the agent to report any check it could not run.
6. Stop conditions and caps. The agent asks only when it cannot continue, or before a destructive or external action. It works through ordinary obstacles such as errors and timeouts, and it reports a deliberate barrier, such as denied access, instead of working around it. Give it a cap on turns or spend where the runtime offers one, and name who approves the result.
7. Return contract. The agent's own rules already ask for a plain report in the user's language that opens with the outcome, gives evidence with file and line, and marks unverified claims. Say only what the report must contain and the length you need, and name another language only when the report itself must be in it. Ask for long material as a file path, not as report text.

Keep the brief at the level of goals and checks. Overly specific steps or "stop for review" lines make current models end early or over-ask.
</brief>

<parallel_work>
Run parallel agents only on independent tracks, and split them along file boundaries. Send all parallel spawns in one message so they run together. Give each agent that writes code its own checkout, such as a worktree, when the runtime offers one. Keep spawn counts low, and use one agent when one is enough.

The `shared_systems` block of the coding instructions binds each agent, and a limit for each agent does not bound their sum. Before you choose how many agents to start on one machine, one database, or one live service, read what it can take. Give every brief the same facts about it and the one way the agents take turns at heavy work, such as a lock that each heavy job holds while it runs. When one agent finds a hazard that the others can meet, such as a trigger that multiplies a write or a scheduled job on the same rows, send it to each of them at once.
</parallel_work>

<waiting>
Do not poll an agent, sleep, or re-brief it while it runs. Keep working on what does not depend on it, and follow the runtime's instructions for completion notices. Send a follow-up to a running agent only to correct its course. Cancel an agent you no longer need with the runtime's cancel tool.

A completion notice says that the agent's turn ended, and the agent's last message says whether the work did. When that message reports a wait or a next step, the task is still open. Wait for the next notice where the runtime wakes the agent by itself, and tell the agent to continue where it does not.

When the user asks you to watch the agents on a schedule, set the check up with the runtime's scheduler. Read in each check only what changed since the last one, and correct an agent as soon as you see it leave its brief or these rules.
</waiting>

<results>
Check each report's evidence before you accept it, such as the command, its output, and the cited lines. Do not redo the agent's work or re-derive its findings when the evidence holds. When several agents changed code, check for conflicts. Then run the project's checks on the combined result, as the `verification` block of the coding instructions requires. Tell the user the verified findings in your own words under the `writing_style` rules, and name each agent or thread as the runtime shows it.
</results>
