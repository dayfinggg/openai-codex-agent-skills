---
name: design-testing-strategy
description: Design risk-based test strategy when material work involves layer selection, fixtures or oracles, nondeterminism, or broader verification gaps. Exclude routine focused tests, defect debugging, and agent evaluation.
---

# Design Testing Strategy

## Establish the test contract

1. Inspect the repository's existing test frameworks, commands, fixtures, CI configuration, and naming conventions before proposing changes.
2. Identify the behaviors at risk, their externally observable outcomes, affected boundaries, likely failure modes, and the impact of failure.
3. Rank the risks. Cover each material risk at the lowest layer that can reproduce it faithfully and fail for the right reason.
4. Define the minimum set of tests that provides useful confidence. Add multiple layers only when each layer detects a different class of failure.
5. Use the existing toolchain. Add a test dependency or framework only when the required behavior cannot be tested adequately with what the project already supports.

## Select the test layer

| Layer | Prefer for | Avoid |
| --- | --- | --- |
| Unit | Pure logic, edge cases, state transitions, and error mapping | Reproducing framework, database, network, or serialization behavior |
| Integration | Persistence, serialization, filesystem, queue, process, and component-boundary behavior | Mocking the integration whose semantics are under test |
| Contract | Provider-consumer compatibility, schemas, protocols, versioning, and error shapes | Duplicating ordinary integration tests without a compatibility risk |
| Property | Invariants, parsers, encoders, round trips, and large input spaces | Using unconstrained generators that produce mostly invalid or irrelevant cases |
| End-to-end | A small set of critical user journeys and production-like wiring | Exhaustive branch coverage or scenarios cheaper layers already prove |
| Performance | Explicit latency, throughput, resource, or scalability budgets under representative load | Optimizing from a noisy microbenchmark or an unspecified target |
| Security | Authentication, authorization, trust boundaries, input handling, data exposure, and abuse cases | Treating a happy-path functional test as security evidence |

## Implement durable tests

- Assert observable behavior and stable contracts. Avoid private implementation details, incidental call counts, internal ordering, and broad snapshots.
- Give each test one coherent reason to fail. Name it after the behavior and condition it verifies.
- Exercise boundaries, negative paths, recovery behavior, and regressions in proportion to their risk.
- Keep fixtures minimal, valid, local, and explicit. Let each test own mutable state. Introduce builders or shared fixtures only after repetition proves they improve clarity.
- Use faithful test doubles only at narrow, uncontrollable boundaries. Prefer real local collaborators when correctness depends on their semantics.
- Control clocks, randomness, locale, environment, concurrency, retries, and external I/O. Record random seeds, avoid arbitrary sleeps, and use deterministic synchronization or bounded polling.
- Preserve isolation and repeatability. Make setup and cleanup idempotent, and never depend on execution order or shared residue.
- Do not test language or framework behavior unless the project depends on a disputed compatibility assumption.

## Verify the strategy

1. Run the narrowest affected tests first, then the repository's relevant broader checks.
2. Confirm each new regression test would fail when the targeted behavior is broken, when this can be demonstrated safely and cheaply.
3. Repeat tests exposed to concurrency, timing, or randomized inputs enough to reveal instability without substituting repetition for deterministic control.
4. Treat coverage reports as evidence for finding untested behavior, not as a target. Do not add trivial assertions or duplicate tests to raise a percentage.
5. Remove redundant cases and report material risks that remain untested because of unavailable environments, data, permissions, or observability.

Keep root-cause investigation in the debugging workflow. Keep prompt, model, and agent-output evaluation in the agent-evaluation workflow.
