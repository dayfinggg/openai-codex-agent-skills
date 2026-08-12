---
name: debug-systematically
description: Diagnose and fix failures using evidence, isolation, minimal correction, and regression checks. Use for bugs, crashes, failing tests, wrong results, or flakiness; exclude reviews, refactors, and performance-only work.
---

# Debug Systematically

Follow the workflow in order. Keep every conclusion tied to an observation. Read [diagnostic techniques](references/diagnostic-techniques.md) only when a failure is intermittent, concurrency-sensitive, environment-dependent, distributed, data-dependent, or difficult to reproduce.

## Establish the failure contract

1. Determine the authorized outcome. Keep diagnosis, review, and explanation requests read-only. Make in-scope edits only when the user requests a fix or implementation.
2. Define the expected behavior, observed behavior, triggering input or event, affected scope, and relevant environment. Verify these facts from tests, contracts, logs, source, or user-provided evidence.
3. Inspect the working state before running commands or editing files. Preserve unrelated changes and avoid cleanup that could erase the failure.
4. Identify the narrowest observable failure. Prefer an exact assertion, exit code, incorrect value, exception, protocol response, or state transition over a broad symptom report.

## Reproduce and preserve evidence

1. Run the narrowest deterministic reproduction available before changing implementation code.
2. Record the exact command, input, environment assumptions, exit status, and relevant output. Preserve original logs, traces, dumps, fixtures, and failing artifacts when later actions could overwrite them.
3. Control variable inputs such as random seeds, clocks, locale, time zone, dependency resolution, configuration, external services, and concurrency where practical.
4. If reproduction fails, compare the known failing environment with the current one and seek another independent signal. Do not infer a root cause or claim a fix from code inspection alone.
5. If required evidence or access is unavailable, state what is known and unknown. Request only the missing information that blocks a safe conclusion.

## Isolate causality

1. Reduce one dimension at a time: input, execution path, component, configuration, environment, dependency, state, or revision.
2. Trace backward from the observable failure through state transitions and boundary contracts until locating the first invalid value, decision, or invariant violation.
3. Compare failing and passing cases. Treat each difference as a candidate cause until a targeted test distinguishes causal differences from correlation.
4. Separate the symptom from the root cause. Exceptions, retries, timeouts, and malformed outputs may be downstream effects of an earlier defect.
5. Stop expanding the investigation when one causal chain explains the evidence and predicts the observed failure without contradicting known passing cases.

## Form and falsify hypotheses

1. Express each hypothesis as a falsifiable prediction: if the proposed cause is real, a specific observation must change under a controlled test.
2. Rank hypotheses by evidence and test cost. Run the cheapest test that clearly distinguishes competing explanations.
3. Change one relevant variable per experiment. Prefer probes, focused tests, temporary instrumentation, revision bisection, and minimized inputs over speculative edits.
4. Try to disprove the leading hypothesis. Discard it when its prediction fails and retain the evidence that ruled it out.
5. Accept a root cause only when it explains the causal chain and a targeted intervention changes the outcome as predicted.

## Implement the authorized fix

1. Add or identify a focused regression check that fails for the defect before the implementation change when practical.
2. Apply the smallest complete correction at the earliest faulty assumption or invariant. Preserve public contracts and unrelated behavior unless the requested change explicitly alters them.
3. Handle relevant boundary and error cases without broad refactoring, speculative abstractions, unrelated dependency changes, suppression directives, or catch-all fallbacks.
4. Do not mask an unresolved cause with retries, delays, swallowed errors, weakened assertions, disabled checks, or expanded timeouts unless that behavior is itself the verified correction.
5. If the root cause lies outside the authorized scope, report the supported diagnosis and stop instead of modifying adjacent behavior.

## Verify the result

1. Rerun the exact original reproduction and confirm that its observable outcome now satisfies the failure contract.
2. Run the focused regression check and relevant neighboring checks. Broaden to integration, static, build, or repeated stress validation according to the changed boundary and risk.
3. Exercise a passing control case and material negative, boundary, or error cases so the fix does not merely invert the failure.
4. Inspect the final diff for accidental behavior changes, temporary probes, generated artifacts, and unrelated edits.
5. Report the reproduced failure, supported root cause, changed behavior, commands run, and exact validation results. Distinguish verified outcomes from residual uncertainty and never guess success.
