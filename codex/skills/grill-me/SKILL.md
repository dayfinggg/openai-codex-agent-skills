---
name: grill-me
description: Resolve high-impact ambiguity before implementation when repository evidence cannot settle the decision.
---

Use this skill only when a request is materially underspecified and proceeding would commit to a product behavior, public contract, data model, security or privacy rule, compatibility promise, resource limit, or architectural choice that repository evidence cannot settle. It may start by turning a vague request into a small decision tree; it does not require the user to provide a finished plan first.

Do not use it for routine fixes with a clear reproduction, explicit acceptance criteria, low-risk reversible edits, explanations, reviews, or decisions already settled by the user or project guidance. Use `align-requirements` for ordinary ambiguity that does not need a decision interview.

Inspect the repository, tests, configuration, and authoritative documentation before asking about facts. Start with one concrete hypothesis about the user's intended behavior and expected result, then ask the user to confirm or correct it. Do not begin with a questionnaire. If confirmation reveals further high-impact choices, build a compact decision tree and resolve dependent decisions in order. The facts are the agent's responsibility. The decisions are the user's responsibility.

Ask one focused question at a time. Use the host's structured question tool when available, with two or three mutually exclusive choices when the decision is bounded and the first choice as the recommended answer. If the question tool is unavailable or fails, ask one concise plain-text question and stop; never replace it with a questionnaire or a table of open questions. Wait for the user's answer before asking a dependent question. Treat vague or contradictory answers as unresolved.

Do not edit files, implement the plan, create documentation, or make external changes during the interview. Stop after the confirmation when no material branch remains. Continue with one question at a time only while a decision affecting the requested scope remains unresolved. Do not explore hypothetical future branches. Confirm the shared understanding before handing control back to the normal implementation workflow.

Read [references/examples.md](references/examples.md) when deciding whether to trigger the interview or how to phrase its first question.
