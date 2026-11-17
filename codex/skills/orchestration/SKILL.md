---
name: orchestration
description: Plan or coordinate explicitly authorized multi-agent work, including worker briefs, model selection, independent workstreams, integration, and review rounds.
license: MIT
---

# Multi-agent orchestration

Create no workers, agent teams, or external model calls unless the user or an applicable instruction explicitly authorizes delegation and the runtime permits it. Read [Delegation briefs](references/delegation-brief.md) before dispatching a worker or selecting a different model.

Keep workstreams independent. Give each worker a defined goal, file ownership, limits, and a verifiable finish condition. Agree on shared interfaces before parallel implementation. If the runtime shares one working copy, assign disjoint files and tell workers not to revert changes they did not make. Coordinate heavyweight work that competes for the same machine, database, or service.

Read [External worker runtimes](references/other-agents.md) when the user chooses a non-native worker or CLI. Read [Implementation and review loops](references/review-loop.md) when coordinating multiple implementation tickets or follow-up review rounds.

Treat worker reports as claims. Check the changes and evidence that affect the requested outcome, resolve conflicts at the integration point, and run the appropriate combined check. Do not accept commits, messages, deployments, database writes, or other external actions from a worker as authorized unless the user's request covers those actions.
