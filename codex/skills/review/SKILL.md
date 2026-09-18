---
name: review
description: Review a diff, branch, or PR for actionable defects and requirement fit. Use when the user asks for a review. Edit files only when fixes are also requested.
---

# Review

Find actionable defects that could change the decision to accept the work.

## Establish the comparison

Identify the exact base and changed state. Read the originating requirement or specification and the repository rules that govern the touched area. Inspect the diff before expanding into surrounding code.

## Review independently

Check requirement compliance, behavioral correctness, state and error handling, compatibility, security boundaries, concurrency, tests, and maintainability. Trace beyond the diff only where a changed contract or shared state creates risk.

Report avoidable complexity introduced by the change, such as a dependency for a small operation, an interface with one implementation, a pass-through wrapper, or a hand-written substitute for a standard library capability, only when removing it preserves required behavior and materially reduces ownership or change cost.

When delivery, security, or structure changes, include lockfiles, build and deployment configuration, provenance and signing, authorization and bypass paths, rollback limits, dependency direction, and framework or persistence types leaking across boundaries. Report these only when they create a concrete correctness, compatibility, ownership, or future-change cost, not because they differ from a preferred architecture.

Validate suspected defects against code, tests, or documentation. Do not report style preferences as defects. Consolidate findings that share one cause.

## Findings contract

For each finding, provide severity, precise location, triggering scenario, user or system impact, supporting evidence, and the smallest correction direction. Prioritize defects over summaries.

## Boundaries

Do not modify files for a review-only request. Do not claim no issues when required context or validation was unavailable. If there are no actionable findings, say so and name the checks performed and residual risk.
