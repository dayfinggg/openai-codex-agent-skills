---
name: review-changes
description: Find and rank actionable defects introduced by a concrete diff, patch, pull request, commit, or completed change. Use for requested review of changed artifacts, including review-and-fix when explicitly requested. Skip greenfield design, project-wide audits without a change target, and skill-package trust audits. Remain read-only unless fixes are requested.
---

# Review Changes

1. Resolve the exact changed artifact and review mode. Recover the intended contract from the request, acceptance criteria, applicable repository rules, and observable prior behavior. If no concrete change is available, stop and request the target instead of reviewing a proposal or sampling a project.
2. Inspect the complete diff before narrowing the review. Classify only risks the change can affect, such as correctness, data integrity, security, compatibility, concurrency, performance, accessibility, migration, operations, or verification. Do not run a universal checklist for untouched qualities.
3. Read enough definitions, callers, tests, schemas, configuration, versions, and generated boundaries to understand each changed path. Follow semantic references or builds when available. If coverage relies only on lexical search, bound the coverage claim.
4. Check whether each hunk belongs to the smallest complete change. Trace it to requested behavior, a necessary test, compatibility, migration, or an existing document made false by the change. Treat added abstractions, dependencies, configuration, public surface, duplicated logic, broad formatting, and unrelated cleanup as defects only when they create a material consequence. Do not demand a redesign merely because another form is preferable.
5. Prove every candidate finding with a reachable scenario, violated invariant, authoritative requirement, or reproducible check. Confirm that the reviewed change introduced it and that a bounded correction exists. Separate defects from pre-existing problems, style preferences, unsupported hardening, and intentional contract changes.
6. Rank findings by consequence: `P0` for a universal release blocker or critical failure, `P1` for an urgent severe defect, `P2` for an ordinary material defect, and `P3` for a low-impact but still actionable defect. Report confidence separately and omit low-confidence speculation. Read [the review evidence reference](references/review-evidence.md) only when local policy does not settle review evidence, change size, or compatibility treatment.
7. Put findings first. Give each one a narrow changed location, triggering condition, consequence, evidence, and smallest remediation direction. Continue through the entire target after finding the first issue. If no finding qualifies, state that directly and report only material validation limits or residual risks.
8. For review-and-fix, complete the review before editing. Fix only supported findings, preserve compatible behavior, keep the correction diff bounded, and run the narrow checks that demonstrate each correction. Do not use the fix request to absorb unrelated improvements.

Finish when every changed behavior and affected boundary has been considered, every reported issue is introduced, reachable, material, and actionable, and the result distinguishes observed checks from unavailable or inconclusive coverage.
