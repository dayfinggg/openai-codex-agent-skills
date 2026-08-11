---
name: spec-to-tasks
description: Create an evidence-backed execution-ready implementation plan or decompose an approved specification. Use only when the user explicitly asks for planning, a roadmap, milestones, a task breakdown, or decomposition. Do not trigger merely because implementation is large or multi-stage, and do not use task detail to settle unresolved product or architecture decisions.
---

# Spec to Tasks

1. Keep planning read-only. Inspect the applicable instructions, approved specification, repository structure, relevant execution paths, tests, configuration, versions, and current behavior only far enough to ground the plan. If required repository evidence is unavailable, state the limitation and create a bounded discovery task instead of fabricating precision.
2. Establish the plan contract: intended outcome, evidenced current state, scope, non-goals, constraints, acceptance criteria, failure behavior, affected quality attributes, approved decisions, and remaining assumptions. Separate assumptions from decisions. Stop decomposition when an unresolved product, domain, interface, migration, or architecture choice would materially change the tasks.
3. Choose the smallest sufficient approach. Compare alternatives only when they materially differ in contract, risk, reversibility, dependency, or architecture. Exclude hypothetical features, generic platforms, extension points, new dependencies, broad cleanup, and ceremony that adds neither a decision nor evidence.
4. Ground project placement before naming files or symbols. Find the relevant package or application root, mechanically significant paths, configured generators and discovery rules, and nearby precedent. Name an exact file only when evidence supports it. Otherwise name the capability or boundary and make path discovery part of the task. Do not impose one layout, suffix grammar, or test location across languages and frameworks.
5. Decompose into the fewest vertical tasks that leave a buildable, testable, demonstrable, or explicitly isolated intermediate state. Keep a behavior change with its necessary test, contract, compatibility, or migration work. Create a horizontal enabling task only when it produces a verified prerequisite consumed by later tasks. Use [planning principles](references/planning-principles.md) when the plan has multiple dependencies, owners, or release states.
6. Give each task a bounded outcome, traced requirements and risks, affected ownership surface, implementation intent, true prerequisites, concrete evidence, and completion condition. Assign one owner to overlapping files or contracts. Keep independent ownership surfaces parallelizable and make the integration order explicit.
7. Add compatibility, migration, rollout, recovery, documentation, security, performance, or observability work only when an approved criterion or affected risk requires it. Do not invent dates, effort, staffing, files, APIs, tools, or external actions. Write to a tracker only when explicitly authorized.
8. Review traceability in both directions. Every criterion and material risk must map to a task and evidence. Every task must map to an approved requirement, necessary prerequisite, or verification need. Remove orphan work, duplicates, speculative generality, vague phases, and tasks whose only outcome is activity.
9. Return the smallest useful plan in execution order. Do not create a retained plan artifact unless requested. Planning does not revoke existing implementation authorization or add an approval gate to already approved work.

Read the dated [source ledger](references/sources.md) only when refreshing or justifying the planning method, not for routine decomposition.

Finish when another capable executor can act without rediscovering intent, every material decision and dependency is visible, intermediate states are viable, ownership is unambiguous where work overlaps, and completion is provable from named evidence.
