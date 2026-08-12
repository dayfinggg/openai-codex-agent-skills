---
name: review-code-quality
description: Review pull requests, diffs, files, or repositories and report evidence-backed defects. Use for read-only findings, not fixes, debugging, refactoring, or architecture. Route dedicated security analysis to secure-code.
---

# Review Code Quality

## Establish the Review Basis

- Treat the review as read-only unless the user explicitly asks for fixes.
- Read the applicable instructions, request, diff, and enough surrounding code to understand intent and existing conventions.
- Inspect affected callers, contracts, tests, configuration, migrations, and dependency boundaries when they can change the outcome.
- Separate defects introduced by the reviewed change from pre-existing or unrelated issues. Report an existing issue only when the user requested a broader audit.
- Use existing tests and static checks when they materially improve confidence. Do not install dependencies, run formatters that rewrite files, or modify tracked files solely for a review.

## Evaluate Material Risks

- Verify behavior against stated requirements, public contracts, invariants, and supported environments.
- Trace normal, boundary, error, concurrent, and cleanup paths where relevant.
- Check regressions across call sites, persisted data, schemas, configuration, compatibility, and failure handling.
- Inspect trust boundaries for authorization errors, injection, unsafe parsing, secret exposure, insecure defaults, and insufficient validation.
- Flag maintainability problems only when they create a concrete defect risk or make a likely change unsafe.
- Flag complexity when a simpler existing pattern would preserve behavior and materially reduce risk.
- Flag duplication when copies can diverge, encode the same policy inconsistently, or already behave differently.
- Flag missing tests only for a specific unverified behavior or regression path. Name the case the test should cover.
- Do not report subjective preferences, speculative concerns without a plausible failure mode, or style differences that no enforced project rule rejects.

## Validate Each Finding

1. Identify the exact changed or audited behavior.
2. Confirm the issue from repository evidence or a focused check.
3. State the conditions that trigger it and the user-visible, operational, security, or maintenance impact.
4. Point to the smallest file and line span that demonstrates the issue.
5. Give a concise correction direction without implementing it unless requested.

If evidence is incomplete, label the concern as unverified and state what evidence is missing. Do not present an assumption as a finding.

## Report Findings

- Put actionable findings first and order them by severity, then confidence.
- Give each finding a specific title, severity, tight file-and-line reference, evidence, impact, and concise correction direction.
- Use the platform's inline review mechanism when available. Otherwise, use clickable absolute file references with one-based line numbers.
- Keep one defect per finding. Combine locations only when they share the same cause and correction.
- Do not bury findings in a general summary. If no actionable finding is supported, say so directly and state only material validation gaps or residual risks.

Do not edit code during a read-only review. If the user later asks for fixes, preserve the reviewed evidence and switch to an implementation workflow. Use a debugging workflow for reproducing a known failure, an architecture workflow for system design, and a refactoring workflow for behavior-preserving structural change.
