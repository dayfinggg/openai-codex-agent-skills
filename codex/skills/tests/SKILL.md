---
name: tests
description: Design, write, review, and repair automated software tests using risk-based selection and behavior-focused assertions. Use for test strategy, regression coverage, flaky tests, fixtures, CI test selection, or choosing unit, integration, contract, end-to-end, property, fuzz, mutation, snapshot, or visual tests; do not invoke merely because a task runs an existing test command.
---

# Tests

Build the smallest test portfolio that gives credible evidence for the change. Optimize for defect detection, diagnostic value, determinism, execution time, and maintenance cost rather than test count or coverage percentage.

## Establish the risk

Inspect the change, its callers, existing tests, build configuration, and CI before adding tests.

1. Translate the requirement or defect into observable acceptance criteria. Identify the behavior that must remain stable and the evidence that would prove it.
2. Trace affected boundaries, data, state transitions, errors, concurrency, security, performance, compatibility, and user flows. Consider consequence, likelihood, uncertainty, reversibility, and how quickly production would reveal a failure.
3. Find the repository's test framework, conventions, fixtures, helpers, commands, environment assumptions, and current flaky or quarantined tests. Reuse them unless they cannot express a required check.
4. Identify what existing checks already prove. Add only evidence that closes a real gap.

Do not turn a preference or guess into a failing test. Ground expected behavior in requirements, public contracts, documented invariants, established project behavior, or a user-confirmed decision; ask when a material ambiguity cannot be resolved from those sources.

For a bug fix, reproduce the defect with the narrowest meaningful failing test before changing production behavior when feasible. Preserve the reproducer as a regression test after the fix.

## Choose the test boundary

Start at the lowest boundary that can observe the failure through a supported contract. Add a broader test only when it detects a distinct risk that narrower tests cannot.

- Use static analysis for type, schema, lint, and build-time invariants.
- Use focused unit tests for deterministic domain rules, algorithms, transformations, state transitions, error mapping, and boundary values that do not require real infrastructure.
- Use integration tests when confidence depends on real serialization, database behavior, filesystem semantics, framework configuration, adapters, queues, processes, or runtime wiring. Prefer disposable local dependencies over production systems or shared mutable environments.
- Use contract tests when independently deployed consumers and providers must agree on requests, responses, events, compatibility, or failure shapes. Assert only the fields and scenarios a real consumer relies on.
- Use end-to-end tests for a small set of critical user journeys, deployment wiring, or cross-system outcomes that lower layers cannot establish. Do not repeat lower-layer permutations through the UI.
- Use property-based tests for broad input spaces with stable invariants, round trips, equivalence to a reference implementation, algebraic properties, or state-machine rules.
- Use fuzz tests for parsers, protocols, untrusted or complex inputs, native-memory boundaries, crash resistance, hangs, and resource exhaustion. Keep targets narrow, fast, deterministic, and replay discovered inputs as regressions.
- Use mutation testing selectively on changed or high-risk logic when ordinary coverage cannot show whether assertions detect plausible faults.
- Use textual or structural snapshots only for stable, reviewable output whose complete shape is the contract. Keep snapshots small and inspect every update.
- Use visual regression tests when pixels, layout, typography, responsive behavior, or rendering are part of acceptance. Fix the browser, operating system, fonts, viewport, data, time, and animation state; review baseline changes rather than approving them mechanically.

Treat the test pyramid, trophy, diamond, and honeycomb as context-dependent heuristics, not target ratios. Let architecture and risk determine the shape. Fast logic-heavy libraries often justify many narrow tests; UI applications and boundary-heavy services often justify more integration checks; expensive end-to-end checks remain sparse.

## Test behavior, not construction

- Exercise public interfaces and assert externally observable results, persisted state, emitted messages, errors, or user-visible effects.
- Avoid assertions about private methods, internal call order, component trees, CSS structure, incidental logs, or exact collaborator counts unless that interaction is itself a documented contract.
- Mock only to control a true boundary, inject a failure, or replace nondeterministic or unavailable infrastructure. Prefer a simple fake or real disposable dependency when compatibility is the risk.
- Do not mock the subject under test, reproduce production logic inside the test, or assert a value that the test itself configured without exercising meaningful behavior.
- Use precise assertions that fail for the intended defect. Assert relevant fields and invariants instead of entire objects when unrelated changes are allowed.
- Name each test by the condition and observable outcome. Keep setup, action, and expected result easy to distinguish.

## Control state and time

- Make every test runnable alone, in any order, and in parallel unless the framework explicitly requires otherwise.
- Give each test the smallest explicit fixture it needs. Use builders with meaningful defaults rather than large shared object graphs or hidden setup.
- Create isolated data and clean resources even after failure. Avoid production data, credentials, live third-party services, and shared accounts.
- Control clocks, time zones, locales, random seeds, identifiers, network responses, and scheduler behavior when they affect the result. Record seeds and minimized counterexamples for replay.
- Wait for observable conditions or events instead of sleeping for guessed durations. Use tolerances only when the domain permits them, not to hide races.
- Keep visual and snapshot baselines deterministic. Mask only genuinely irrelevant volatility and keep thresholds narrow enough to detect the intended regression.

Treat a flaky test as a defect in the test, product, or environment. Diagnose uncontrolled state, ordering, time, concurrency, resource limits, external dependencies, and overly strict assertions. Retries may collect evidence but must not redefine an intermittent failure as success. Quarantine only when immediate repair is impossible, with an owner, tracked cause, and removal condition.

## Use coverage as evidence of gaps

Coverage shows execution, not correctness. Never add low-value tests to reach an arbitrary percentage.

- Inspect uncovered changed behavior and decide whether its risk warrants a test.
- Prefer branch and behavior analysis over line totals when conditions matter.
- Check that assertions can detect a controlled fault or the pre-fix defect when practical.
- Use mutation results to find weak assertions, equivalent logic, or untested outcomes; do not chase a universal mutation score.
- Delete or consolidate redundant tests whose failure mode is already proven more cheaply at another layer.

## Fit tests into delivery

Run the narrowest relevant checks first. Put fast, deterministic checks on every change and pull request. Run broader, slower, destructive, cross-platform, performance, security, fuzz, and visual suites at the earliest cadence their cost and environment allow, without omitting a critical release gate.

Keep local and CI commands aligned. Pin required runtimes and environments, preserve failure artifacts, and make failures identify the scenario, expected behavior, actual behavior, and useful diagnostics. Test the mergeable configuration, not only an isolated branch state, when the CI platform supports it.

## Audit the result

Reject or revise the test work if any answer is no.

1. Does every new test correspond to a plausible defect, acceptance criterion, contract, or material risk?
2. Would the test fail if that behavior broke, and did it fail against the known defect or a controlled fault when feasible?
3. Does the chosen layer provide the required confidence more cheaply and reliably than a broader layer?
4. Can implementation details change without breaking the test while behavior remains the same?
5. Is the test isolated, deterministic, parallel-safe where expected, and free from live external dependencies?
6. Are fixtures, assertions, snapshots, and baselines small enough to understand and review?
7. Do the selected commands pass, and are any unrun checks or unresolved risks stated accurately?
