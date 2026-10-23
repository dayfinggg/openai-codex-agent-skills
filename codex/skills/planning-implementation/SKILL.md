---
name: planning-implementation
description: Plans a coding task in a larger codebase before editing, settles open decisions with the user, agrees on a short plan, then implements and verifies it. Invoked explicitly as $planning-implementation with the task.
---

# Planning before implementation

Use the task description supplied with the explicit $planning-implementation request.

When the change fits in one sentence and touches one or two files, say that no plan is needed, ask at most one question if something is truly ambiguous, and implement it. Use the process below for work across several files or modules, with an unclear approach, in unfamiliar code, or costly to undo.

## Decisions

Explore the code first, then list every decision the task depends on and sort each one.

- **Settled** by the code, the conventions, or the request. Follow that answer.
- **Routine**, meaning a careful engineer on the team would just decide it. Decide it and record it as an assumption.
- **Material**, meaning the answers lead to different work, the choice is hard to reverse, it rests on business rules or preferences only the user knows, or it touches security, data, or public interfaces. Ask about these.

When the project does not dictate the language of a new component, recommend a memory-safe one, as CISA and NSA guidance urges. Propose rewriting existing C or C++ code only when the user asks.

## Questions

Ask with request_user_input when available, using its actual schema. The current Codex tool accepts up to three independent questions, each with two or three options. Put the recommended option first, mark it in the user's language, and say what each option costs or risks. A question that depends on another answer waits for the next round. Stop asking when the remaining points would not change the plan, and when the user says to decide yourself, take the recommended answers as assumptions.

When two or three approaches are viable, compare them briefly on fit with the existing code, complexity, risk, reversibility, and effort, and recommend one.

## Plan

Use the global instruction's communication rules for a plan in chat. The template below applies only to a plan document the user explicitly asks to save, not to the chat reply.

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

Threats belong in the plan because OWASP Top 10 2025 lists insecure design (A06) as a risk separate from implementation bugs. Add a step to record an architecturally significant decision with the recording-architecture-decisions skill, and a telemetry step with the adding-observability skill for a new service, endpoint, or job. For work spanning several sessions, offer to save the plan as a file in the repository. Wait for the user's approval before editing any file.

## Implementation

Follow the steps and run the relevant checks after each one. When the code contradicts the plan or a new material decision appears, pause, explain what changed, and ask. Make routine adjustments yourself and list them at the end. Report done only when the verification passes, with the evidence.
