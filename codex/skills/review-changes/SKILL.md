---
name: review-changes
description: Review a concrete diff, pull request, patch, or completed change for material defects and unmet requirements. Use only when a changed artifact exists and review is requested; skip greenfield assessment and remain read-only unless fixes are requested.
---

# Review Changes

1. Confirm the review artifact: a concrete diff, patch, pull request, or completed implementation of a change. Establish its intended behavior from the request, specification, issue, and repository rules. If no changed artifact is available, ask for one rather than reviewing a proposal or inventing findings.
2. Classify the change and its risk before looking for defects. Record the relevant change categories, such as behavior, interface, data, build or release, security, performance or reliability, and tests or documentation. Use the changed boundary, blast radius, reversibility, and confidence in existing evidence to focus the review.
3. Inspect the diff and enough surrounding code, contracts, callers, tests, and configuration to understand the classified risks. Examine correctness, missing cases, data integrity, security, error handling, compatibility, concurrency, performance, accessibility, migrations, and tests only where the changed artifact makes them relevant.
4. Prove each potential defect with a concrete execution path, violated invariant, authoritative requirement, or reproducible check. Do not report speculative defects without a plausible triggering condition. A style preference or alternative design is not a defect unless it violates a stated convention or creates a material consequence.
5. Report only material findings, ordered by severity and confidence. Each finding needs a concrete location, trigger or cause, consequence, bounded remediation direction, and a confidence label grounded in evidence. Do not add optional improvements, architectural preferences, style observations, or speculative hardening unless the user explicitly requests them. Record a validation limit or residual test gap only when it materially constrains confidence in the changed behavior.
6. Check acceptance criteria and validation results separately from defect discovery. When no material finding is supported, state that result and identify only the reviewed scope and validation limits that materially constrain confidence.

Finish when every changed behavior and affected boundary has been considered and every reported issue is actionable and evidence-backed.
