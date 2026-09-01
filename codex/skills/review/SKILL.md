---
name: review
description: Review a diff, branch, pull request, or work-in-progress change for correctness, requirement fit, regressions, and maintainability. Use when the user asks for code review or assessment of completed changes. Report findings without editing unless a fix is also requested.
---

# Review

Find actionable defects that could change the decision to accept the work.

## Fix the comparison

Identify the exact base and changed state. Read the originating requirement or specification and the repository rules that govern the touched area. Inspect the diff before expanding into surrounding code.

## Review independently

Check requirement compliance, behavioral correctness, state and error handling, compatibility, security boundaries, concurrency, tests, and maintainability. Trace beyond the diff only where a changed contract or shared state creates risk.

Check for avoidable complexity introduced by the change, including a new dependency for a small operation, an interface with one implementation, a factory with one product, a pass-through wrapper, unused flexibility or configuration, and a hand-written substitute for the standard library or a native platform capability. Report it only when removing it preserves the required behavior and materially reduces ownership or change cost. Do not prefer fewer characters or files over correctness, readability, or a coherent boundary.

At code level, inspect input validation, side-effect-free assertions, initialization before use, variable scope and lifetime, numeric conversion and overflow, loop bounds and termination, resource ownership, hidden side effects, and whether tests can fail for the intended defect. Apply only the checks relevant to the language and changed path.

When delivery or security changes, include lockfiles, build scripts, generated artifacts, provenance and signing fields, deployment policies, bypass paths, break-glass controls, authorization matrices, fail semantics, rollback floors, and shared causes of failure among supposed backups.

For structural changes, check dependency cycles, framework or persistence types leaking across intended boundaries, hidden composition or service lookup, and accidental changes to build or deployment units. Report them only when they create a concrete correctness, compatibility, ownership, testing, or future-change cost, not merely because they differ from a preferred architecture.

Validate suspected defects against code, tests, or documentation. Do not report style preferences as defects. Consolidate findings that share one cause.

## Findings contract

For each finding, provide severity, precise location, triggering scenario, user or system impact, supporting evidence, and the smallest correction direction. Prioritize defects over summaries.

## Boundaries

Do not modify files for a review-only request. Do not claim no issues when required context or validation was unavailable. If there are no actionable findings, say so and name the checks performed and residual risk.
