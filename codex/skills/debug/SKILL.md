---
name: debug
description: Diagnose and repair software failures through reproducible evidence, controlled experiments, change isolation, root-cause analysis, and regression proof. Use for crashes, incorrect behavior, regressions, flaky failures, hangs, races, resource leaks, production incidents, and unexplained performance degradation; not for ordinary implementation without a failure to investigate.
---

# Debug

Turn the report into an observable failing signal, isolate the causal condition, make the smallest corrective change, and prove the signal no longer fails. Do not use code changes as a substitute for diagnosis.

## Establish the failure

1. State the expected behavior, observed behavior, impact, frequency, first known occurrence, affected and unaffected versions, and exact environment. Separate verified facts from reports and assumptions.
2. Inspect applicable instructions, code, configuration, tests, manifests, lockfiles, recent changes, deployment history, and available telemetry before changing anything.
3. Preserve evidence that may disappear: exact commands, inputs, outputs, timestamps, versions, environment variables, seeds, request or trace identifiers, logs, dumps, profiles, screenshots, and system state. Redact secrets without discarding diagnostic structure.
4. In a live incident, reduce user harm first through a known safe rollback, traffic shift, feature disablement, isolation, or capacity action when appropriate. Preserve evidence before mitigation when safe. Treat mitigation, cause, and permanent fix as separate findings.

## Reproduce before repairing

1. Run the narrowest existing failing command without modifications and record its complete result. Confirm that the signal detects the reported behavior rather than an unrelated failure.
2. Reproduce under the reported versions and environment. Control time, timezone, locale, randomness, test order, concurrency, network, cache, filesystem, database state, credentials, feature flags, and external services when they can affect the outcome.
3. Classify the failure as deterministic, intermittent, load-dependent, timing-dependent, data-dependent, environment-specific, or observer-sensitive. For intermittent failures, record attempts, failures, timing, seeds, order, and relevant state instead of relying on one run.
4. Reduce input, setup, dependencies, processes, and code paths while repeatedly confirming that the same failure remains. A minimal example must preserve the causal condition, not merely produce a similar error message.
5. Create or identify an executable regression signal that fails before the fix. If no reliable signal can be obtained, continue gathering evidence and avoid speculative edits.

## Form testable hypotheses

1. Map the path from input to symptom, including boundaries, state transitions, ownership, external calls, and recent changes. Locate the earliest point where actual behavior diverges from expected behavior.
2. Distinguish the symptom, trigger, proximate mechanism, contributing conditions, and root cause. A root cause must explain the evidence and why the system allowed the failure to occur or recur.
3. Keep a short ranked set of plausible hypotheses. For each hypothesis, write the observation it predicts and the safest experiment that would distinguish it from alternatives.
4. Test one meaningful variable at a time when possible. Prefer experiments that can disconfirm a hypothesis. Record negative results so failed ideas are not repeated.
5. Do not infer causation from correlation, temporal proximity, a familiar past incident, or a successful restart. Update the hypothesis ranking when evidence changes.

## Isolate the cause

1. Divide the search space across time, revisions, inputs, configuration, components, requests, or execution paths. Use binary search when the outcome is sufficiently reliable.
2. Use `git bisect` only with a known good revision, known bad revision, and a classifier that distinguishes the target failure. Automate with `git bisect run` when the test is deterministic enough, and account for unbuildable or inconclusive revisions.
3. Compare a working case and failing case while changing one dimension at a time. Differences are leads, not causes, until a controlled test connects them to the failure.
4. Choose the observation tool that answers the current hypothesis: structured logs for events, metrics for aggregate state, traces for request paths, profiles for resource cost, dumps and backtraces for failure state, and breakpoints or watchpoints for control and data flow.
5. Add temporary instrumentation narrowly and measure its overhead. Verbose logging, tracing, debuggers, sanitizers, and profilers can change timing, resource use, and concurrency behavior.
6. For distributed failures, verify each boundary with correlated identifiers and known inputs. For concurrency failures, use race detectors, thread sanitizers, lock or scheduler traces, repeated stress, and recorded seeds or schedules where available. Do not hide races with sleeps or larger timeouts.

## Apply the causal fix

1. Change the smallest boundary that prevents the demonstrated cause while preserving requested scope and existing contracts. Do not combine the fix with unrelated cleanup, renaming, dependency upgrades, or architectural replacement.
2. Address invalid state, missing synchronization, incorrect ownership, broken validation, stale cache behavior, contract mismatch, or other demonstrated mechanism directly. Do not only suppress the final exception, retry indefinitely, or mask the symptom.
3. If immediate risk permits only mitigation, label it as mitigation and state what remains unresolved. Do not call a workaround a root-cause fix.
4. Apply the `code` skill for implementation constraints and the `tests` skill when creating or repairing automated tests.

## Prove the repair

1. Demonstrate that the regression signal fails on the original code or known bad revision and passes with the fix under the same controlled conditions.
2. When practical, reverse the fix or run the old revision to show that the failure returns. This guards against a test that passes because the environment or input changed.
3. Repeat intermittent and concurrency reproductions enough to improve confidence, using the observed pre-fix failure rate and risk to choose the run count. Report counts and duration rather than saying the failure is gone after one pass.
4. Run relevant unit, integration, contract, end-to-end, race, sanitizer, stress, migration, and performance checks in increasing scope. Verify adjacent failure paths and compatibility behavior.
5. Confirm that telemetry, resource use, latency, and error behavior remain acceptable when the fix affects production runtime characteristics.
6. Review the final diff and evidence chain. Every changed line must connect to the demonstrated cause or regression proof.

## Close the investigation

1. Report reproduction, evidence, ruled-out hypotheses, causal mechanism, fix, validation, and remaining uncertainty. Use exact commands and observed results.
2. For significant incidents, record a timeline, impact, detection gap, response, mitigation, contributing causes, root causes, and corrective actions. Keep the analysis blameless and system-focused.
3. Tie each preventive action to a demonstrated control gap and a verifiable completion signal. A process reminder without a changed control is not proof against recurrence.
4. Do not claim a root cause when evidence supports only a likely factor. State the unresolved boundary and the next discriminating evidence needed.
