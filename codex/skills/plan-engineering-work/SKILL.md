---
name: plan-engineering-work
description: Create and maintain evidence-based delivery plans for multi-step repository changes, covering dependencies, validation, risk, rollback, and live state. Use for generic execution planning. Domain skills own mechanics.
---

# Plan Engineering Work

Deliver plans through the available task-tracking interface or the final response. Do not create a plan, report, summary, notes, or other Markdown file unless the user explicitly requests that file.

## Establish the basis

1. Inspect applicable instructions, repository state, relevant code, contracts, configuration, tests, tooling, and available execution evidence before choosing a path.
2. Separate verified facts from assumptions and unknowns. Resolve an unknown before planning past it when its answer can materially change correctness, scope, or sequencing.
3. Define the observable outcome and acceptance conditions. State constraints and non-goals only when they prevent plausible scope drift.
4. Use the smallest path consistent with the verified requirements and existing project conventions. Do not invent components, interfaces, dependencies, migrations, or follow-up work.

## Build the plan

1. Decompose the work into outcome-based steps that each leave the system in a coherent, verifiable state.
2. Order steps by real dependencies. Identify independent work without assigning it to agents or prescribing delegation.
3. Give each step a concrete action, affected surface, expected result, and proportionate verification. Avoid restating the request, listing tools, or expanding routine mechanics into separate steps.
4. Add an investigation step only when its result determines later implementation. Name the evidence or decision it must produce.
5. Attach risks and unresolved assumptions to the step they affect. Include a mitigation or decision point only when the risk can change execution.
6. Plan focused validation first and broader checks only when the affected surface warrants them. Include baseline checks when existing behavior or failures must be distinguished from regressions.
7. Define a rollback, recovery, or compatibility path before destructive, stateful, externally visible, or difficult-to-reverse changes. Omit ceremonial rollback text for harmless reversible edits.

Keep the plan concise. Use one meaningful step for atomic work and finer granularity only where dependencies, uncertainty, or validation boundaries require it.

## Maintain the plan during execution

1. Update the plan when evidence changes scope, ordering, dependencies, risk, or validation. Remove obsolete unfinished work and add newly required work before starting it.
2. Mark a step complete only when its expected result is present and its required verification has run. Keep validation work visible until it is finished.
3. Replan before continuing when a core assumption fails, a dependency is unavailable, or implementation reveals a materially different change surface.
4. Keep execution state accurate. Distinguish pending, active, complete, and genuinely blocked work according to the available task-tracking interface.
5. Report uncertainty and validation limits directly. Do not convert speculation into tasks or claim completion from intended work.

## Check plan quality

Before using the plan, confirm that:

1. Every step advances a verified outcome and has an observable completion condition.
2. Dependencies and ordering reflect the actual system rather than a generic development lifecycle.
3. The plan covers material boundary cases, compatibility concerns, validation, and recovery without adding unrelated improvements.
4. Another engineer could execute the plan from the cited repository evidence without guessing missing requirements.
5. Agent ownership and delegation remain in `delegate-agent-work`, while persistent goals and product prioritization remain outside this skill.
