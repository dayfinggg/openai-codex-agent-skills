---
name: plan-engineering-work
description: Plan complex engineering work before implementation. Use for multi-file or cross-service changes, architecture decisions, ambiguous requirements, migrations, or changes with security, compatibility, performance, data, or release risk. Skip a full plan for small, isolated, obvious, reversible edits.
---

# Plan Engineering Work

Work read-only until the user approves implementation.

## Workflow

1. Inspect applicable instructions, repository state, configuration, manifests, source, tests, documentation, and current authoritative external documentation when needed.
2. Separate verified facts, assumptions, and unresolved questions. Ask only questions whose answers materially change the plan.
3. Define the objective, acceptance criteria, scope, exclusions, constraints, and current behavior.
4. Evaluate only meaningful alternatives. State the chosen approach and its tradeoffs.
5. Divide work into the smallest coherent, independently verifiable phases. Name exact files, symbols, dependencies, validation, and completion conditions when known.
6. Include tests, compatibility, migration, observability, rollout, and rollback only when relevant to the risk.
7. Check the plan for missing consumers, hidden state changes, unsupported claims, and unnecessary work. Stop for approval.

Use a compact plan for moderate work and a fuller design plan only when complexity warrants it. Do not invent paths, APIs, commands, results, or time estimates. Keep refactors separate unless required for the objective.

Read [planning practices](references/practices.md) when choosing plan depth or handling architecture and rollout risk.
