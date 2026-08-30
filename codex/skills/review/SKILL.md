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

Validate suspected defects against code, tests, or documentation. Do not report style preferences as defects. Consolidate findings that share one cause.

## Findings contract

For each finding, provide severity, precise location, triggering scenario, user or system impact, supporting evidence, and the smallest correction direction. Prioritize defects over summaries.

## Boundaries

Do not modify files for a review-only request. Do not claim no issues when required context or validation was unavailable. If there are no actionable findings, say so and name the checks performed and residual risk.
