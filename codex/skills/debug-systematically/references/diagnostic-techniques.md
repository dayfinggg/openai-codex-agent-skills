# Diagnostic Techniques

Use these techniques to select a discriminating experiment when the core workflow does not isolate the cause directly.

## Match the technique to the evidence

| Failure pattern | Preferred technique | Evidence it can establish |
| --- | --- | --- |
| Deterministic on one input | Minimize the input and execution path | The smallest condition required for failure |
| Introduced within a known revision range | Binary-search revisions with one stable reproduction | The first revision correlated with failure |
| Intermittent | Repeat with fixed seeds and captured timing, state, and environment | A measurable correlation or reproducible schedule |
| Concurrency-sensitive | Capture event ordering, task or thread identity, locks, queues, and cancellation | A violated ordering or ownership invariant |
| Environment-dependent | Compare resolved runtime, dependencies, configuration, locale, time zone, permissions, and external endpoints | The environmental difference required for failure |
| Data-dependent | Snapshot and minimize the exact input, schema version, and persistent state | The data property or state transition that triggers failure |
| Distributed | Correlate request identifiers and inspect each boundary request, response, retry, and timeout | The first component that violates its contract |
| State accumulates over time | Reset one state layer at a time and compare fresh with warmed execution | The retained state responsible for divergence |

Do not treat a correlation as causal until a controlled intervention produces the predicted result. Avoid changing several variables in a single experiment.

## Preserve a reproducible evidence bundle

1. Capture the command or request exactly as executed, including the working directory and relevant arguments.
2. Save the smallest failure-inducing input without rewriting its material content.
3. Record the runtime, resolved dependency versions, configuration sources, and environment differences relevant to the failure.
4. Preserve timestamps, identifiers, exit codes, stack traces, assertions, logs, and state snapshots needed to order events.
5. Redact secrets without removing structural evidence. Record each redaction so absence is not mistaken for source data.
6. Keep generated diagnostics separate from source changes and remove temporary probes after validation.

## Maintain a hypothesis ledger

Use a compact ledger when more than one plausible cause remains.

| Hypothesis | Predicted observation | Discriminating test | Result | Status |
| --- | --- | --- | --- | --- |
| One precise causal statement | One observable consequence | One controlled experiment | Exact evidence | Supported, weakened, or rejected |

Update the status from test evidence, not plausibility. A supported hypothesis still requires a causal intervention or equally strong evidence before it becomes the reported root cause.

## Check the root-cause claim

1. Confirm that the cause precedes the symptom and explains the complete failing path.
2. Confirm that it accounts for both failing and relevant passing cases.
3. Confirm that removing or correcting it changes the outcome as predicted.
4. Confirm that no closer upstream invariant violation better explains the same evidence.
5. State any remaining assumption that has not been directly tested.

## Scale regression validation to risk

| Changed boundary | Add to the original reproduction and focused test |
| --- | --- |
| Public API or protocol | Consumer, compatibility, and error-contract checks |
| Persistent data or migration | Forward, backward-compatibility, failure-recovery, and representative-data checks |
| Concurrency or timing | Controlled repeated runs, cancellation, timeout, and ordering checks |
| Security or trust boundary | Invalid, unauthorized, malformed, and adversarial input checks |
| Cross-component behavior | Contract or integration checks across the affected boundary |
| Build, packaging, or environment | Clean-environment build and resolved-artifact inspection |

Use broader validation only where the fix can affect broader behavior. A passing unrelated suite does not replace rerunning the original failure.
