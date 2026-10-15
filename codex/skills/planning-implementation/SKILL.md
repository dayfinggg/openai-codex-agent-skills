---
name: planning-implementation
description: Studies a coding task in a larger codebase before any edit, settles open decisions with the user, agrees on a short plan, then implements and verifies it. Invoked with $planning-implementation followed by the task.
---

# Planning before implementation

The task is the user's message that invoked this skill. The goal is a shared understanding of what to build before code changes, without turning planning into an interrogation. Ask only about decisions that change the work, decide routine matters yourself, and then deliver the whole task.

## Scale the planning to the task

If the change fits in one sentence and touches one or two files, say that no plan is needed, ask at most one question if something is truly ambiguous, and implement it. Use the full process below for work that spans several files or modules, has an unclear approach, touches unfamiliar code, or is costly to undo.

## 1. Understand before asking

- Restate the goal and the expected outcome in two or three sentences.
- Explore the relevant code first. Find the entry points, existing patterns to reuse, conventions, tests, and the commands that build, lint, and test the project. For a broad search across many folders, the explorer agent keeps file contents out of the main context.
- Never ask the user what the code, the docs, or the git history can answer. Look it up instead.

## 2. Map the open decisions

List every decision the task depends on, and note which decisions depend on others. Sort each one into a group.

- **Settled.** The code, conventions, or the request already answer it. Follow that answer.
- **Routine.** A careful engineer on the team would just decide it and nobody would mind. Decide it and record it as an assumption.
- **Material.** Different answers lead to materially different work, the choice is hard to reverse, it depends on business rules or user preferences only the user knows, or it affects security, data, or public interfaces. Ask about these.

When the project does not dictate the language of a new component, recommend a memory-safe language, as the CISA and NSA guidance urges, and never propose rewriting existing C or C++ code unless the user asks.

## 3. Ask in short rounds

- Ask with the request_user_input tool when it is available, otherwise in one short message. One round holds up to four independent questions, each with two to four options. Put the recommended option first and mark it "(Recommended)", and say in each option what it costs or risks.
- Ask only questions whose prerequisites are already settled. Questions that depend on an answer wait for the next round.
- After each round, update the decision map and ask the next set. Most tasks need one to three rounds.
- Stop asking when the remaining open points would not change the plan. If the user says to decide yourself, take the recommended answers and record them as assumptions.

## 4. Compare approaches when there is a real choice

When two or three approaches are viable, present them briefly with their trade-offs in fit with the existing code, complexity, risk, reversibility, and effort, recommend one, and let the user choose. Do not invent alternatives when one approach is clearly right.

## 5. Agree on the plan

Present a short plan in this shape.

```markdown
## Goal
What will be true when this is done.

## Decisions
- Decision, with the chosen option and a short reason
- Assumption, decided without asking

## Approach
How it works, in a few sentences.

## Changes
- path/to/file: what changes and why
- New interfaces, schemas, or migrations

## Out of scope
What will not be done.

## Risks
What might break and how it is handled.
For changes touching authentication, permissions, external input, or money, the threats and their mitigations.

## Steps
1. A small step that leaves the code working and can be checked
2. ...

## Verification
The commands and end-to-end check that prove the whole task works.
```

Keep it as short as the task allows. Threats belong in the plan because the OWASP Top 10 2025 lists insecure design as a risk of its own (A06), separate from implementation bugs. When the plan contains an architecturally significant decision, add a step to record it with the recording-architecture-decisions skill, and when it adds a service, endpoint, or job, add a step for its telemetry with the adding-observability skill. For large work spanning several sessions, offer to save the plan as a file in the repository, so a fresh session can implement it with clean context. Wait for the user's approval or corrections before editing any file.

## 6. Implement and verify

- Follow the plan step by step and run the relevant checks after each step. Apply the other skills that fit, such as clean code, tests, architecture, design patterns, databases, APIs, UI, secure code, LLM features, dependencies and CI, observability, resilience, decision records, documentation, and releases.
- If the code contradicts the plan or a new material decision appears, pause, explain what changed, and ask before going a different way. Make routine adjustments yourself and mention them at the end.
- Do not quietly narrow, widen, or reshape the task. If a better approach appears, say so in one sentence and continue as agreed unless the user changes course.
- Finish the whole plan. Report done only when the verification passes, show the evidence, and list anything left undone with the reason.

## What to avoid

- Asking what can be looked up, or asking without a recommended answer.
- Asking about trivia, style already set by the codebase, or several dependent questions at once.
- Endless rounds after the plan is already clear.
- A plan that restates the request without decisions, files, or verification.
- Editing files before the plan is approved.

Read [examples.md](examples.md) before the first question round, for an illustrative question round and plan.
