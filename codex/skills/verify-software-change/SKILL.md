---
name: verify-software-change
description: Verify whether a software or design change is correct, complete, current, and genuinely satisfies the user's intent. Use before completion claims, during reviews, or when asked to test, validate, audit, or assess readiness across code, tests, configuration, data, APIs, security, performance, interfaces, and user behavior. Detect test gaming, weakened checks, hardcoded answers, harness manipulation, and other false-green results.
---

# Verify Software Change

## Workflow

1. Derive observable acceptance criteria and risks from user intent, contracts, instructions, and real consumers. Treat visible tests as evidence, not as the complete specification.
2. Inspect the final diff, separating production, test, fixture, harness, configuration, generated, and dependency changes. Identify altered checks, exclusions, skipped cases, compatibility, migrations, and missing consumers.
3. Audit test integrity before trusting green results. Reject weakened assertions, special-cased inputs, test-file inspection, test-environment branches, swallowed failures, fake success exits, disabled checks, unjustified snapshot changes, and timeouts or retries raised only to hide failure.
4. Select fresh risk-based checks for normal behavior, boundaries, failures, regression, integration, security, performance, accessibility, responsive design, and operability as relevant.
5. Prove important tests can fail. Run a regression test against the prior defect, temporarily revert or mutate the production behavior when practical, or otherwise demonstrate that the assertion distinguishes correct from incorrect behavior.
6. Add independent cases not copied from visible fixtures. Prefer property, metamorphic, fuzz, contract, integration, browser, or held-out examples when a solution could memorize or overfit known inputs.
7. Run exact repository commands in the correct environment and inspect the rendered or runtime result where behavior is visual, interactive, concurrent, stateful, or environment-dependent.
8. Investigate every failure. Do not weaken the oracle, edit expected output to match an unexplained result, or rerun until green without finding the cause.
9. Report what was run, observed, and established, what changed in tests or harnesses, remaining unverified areas, and whether every acceptance criterion is met.

Compilation, coverage, snapshots, and a green visible suite each prove only a limited property. Never claim a check, environment, or result that was not observed.

Read [test integrity](references/test-integrity.md) before trusting model-authored tests or suspiciously easy green results. Read [verification surfaces](references/verification-surfaces.md) to select independent checks for the type of change.
