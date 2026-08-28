---
name: plan
description: Create evidence-based implementation plans when the user asks for a plan, approach, migration sequence, or decomposition deliverable. Use for plan-only and plan-then-implement requests; do not invoke solely because an implementation task is complex, since internal planning belongs to the base agent workflow.
---

# Plan

Produce a decision-ready implementation plan grounded in the actual system. The plan must reduce uncertainty, expose dependencies, define observable completion, and remain concise enough to guide execution.

## Boundaries

- Preserve the requested outcome, scope, technology choices, and authorization limits.
- Treat planning and execution as separate states. If the user asks only for a plan, perform read-only discovery and stop after the plan. If the user also asks for implementation, create the plan and proceed without adding an approval gate unless one is requested or required.
- Do not present internal chain-of-thought. Present verified findings, decisions, assumptions, risks, and actionable steps.
- Do not use planning for a trivial change whose implementation path is already clear.
- Do not mistake a long list for a good plan. Add detail only when it changes execution, sequencing, validation, or risk.

## Ground the plan

Research before decomposing the work.

1. Identify the exact deliverable, user-visible behavior, constraints, non-goals, compatibility requirements, and completion evidence.
2. Read applicable repository instructions, manifests, configuration, relevant source, tests, documentation, and recent history when it affects the change.
3. Trace the current behavior end to end across callers, interfaces, state, data, side effects, errors, and existing validation. Do not infer architecture from filenames alone.
4. Verify changeable external facts against current primary documentation, including language, framework, library, API, platform, and migration requirements for the versions in use.
5. Separate verified facts from assumptions. Ask only questions whose answers would materially change scope, architecture, safety, or acceptance. Record safe assumptions instead of blocking on minor preferences.

Do not invent existing files, symbols, commands, APIs, or infrastructure. For greenfield work, mark proposed paths and components as new.

## Decompose by outcomes

Build a deliverable-oriented sequence rather than a chronology of generic activity.

- Give each step one primary outcome that can be implemented and checked independently.
- Name the exact existing or proposed files, modules, interfaces, data stores, routes, commands, or user flows affected when known.
- State the behavior or contract that changes, not merely the action to take.
- Order steps by real dependencies. Place schema, interface, compatibility, and enabling work before consumers; place cleanup after successful migration and verification.
- Prefer small vertical slices that leave the system coherent and reviewable. Separate unrelated refactors, generated changes, migrations, and behavior changes when separation lowers review or rollback risk.
- Include a bounded investigation step only when discovery cannot resolve a material unknown. State the decision it must enable and its stopping condition.
- Avoid premature implementation detail. Specify responsibilities, contracts, invariants, and evidence; do not write pseudocode unless the user asks for it or an algorithm is otherwise ambiguous.

Each implementation step must make these points clear in complete sentences:

1. What changes and where.
2. Why the change is necessary for the requested outcome.
3. What depends on it or what it depends on.
4. How completion will be verified, including the expected signal.

## Design verification before coding

Map every material requirement to evidence before finalizing the plan.

- Define acceptance criteria in observable terms. Replace vague phrases such as "works correctly" or "test thoroughly" with behavior, command, assertion, metric, or inspection evidence.
- Select validation that matches the change, such as focused unit tests, contract tests, integration tests, end-to-end flows, static checks, builds, migration dry runs, visual comparison, performance measurements, or operational telemetry.
- Cover expected behavior, important failure paths, boundary conditions, and regression risk. Do not enumerate impossible combinations without evidence that they matter.
- Distinguish verification of the implementation from validation of the user's intended outcome.
- Use existing project commands and quality gates when available. Do not propose a new framework for a single change unless the task requires it.
- Include final integration validation only for interactions not already proven by narrower checks.

## Apply conditional engineering checks

Inspect these concerns only when the task can affect them. Omit irrelevant sections and boilerplate.

- Public interfaces, compatibility, versioning, consumers, and rollout order.
- Data shape, migration, backfill, consistency, idempotency, backup, and rollback.
- Authentication, authorization, secrets, privacy, trust boundaries, abuse cases, and dependency risk.
- Concurrency, retries, failure recovery, rate limits, resource use, latency, caching, and capacity.
- Configuration, environments, deployment, feature flags, observability, alerts, support, and documentation.
- Accessibility, responsive behavior, interaction states, content, and visual acceptance for user interfaces.

For consequential changes, perform a short pre-mortem. Identify the most plausible high-impact failures, the evidence that would reveal them, and the mitigation or rollback action. Do not create a generic risk register.

## Write the plan

Use a short scope paragraph followed by a numbered sequence. Use headings only when the plan is too complex to understand without phases. Do not use a table unless it makes a genuine many-item comparison clearer.

Write steps as executable work packages, not labels. A reader should be able to implement a step without rediscovering its purpose, affected area, dependencies, or proof of completion. Put verification beside the change it verifies rather than collecting every test in a vague final step.

Include assumptions, open questions, risks, rollout, rollback, or acceptance criteria only when they contain material information not already present in the steps. Never add empty sections.

## Audit before delivery

Reject or revise the plan if any answer is no.

1. Does every requested behavior and constraint map to at least one step and one completion signal?
2. Is every step supported by repository evidence or clearly marked as a proposal or assumption?
3. Are dependencies, interfaces, migrations, and rollout order feasible and explicit?
4. Can each step be reviewed, validated, and, where risk warrants it, reversed without relying on unspecified future work?
5. Does the plan cover the smallest sufficient change without unrelated cleanup or speculative architecture?
6. Would removing any sentence make the plan no less useful? If so, remove it.
7. Does the plan guide execution without claiming that planning itself completed the work?
