---
name: diagnose
description: Reproduce a failure, regression, or performance problem and identify its root cause with evidence. Use when the user asks why something is broken, failing, crashing, flaky, or slow. Do not modify the implementation unless the request also asks for a fix.
---

# Diagnose

Replace speculation with a short feedback loop and a causal explanation.

## Reproduce

Capture the exact symptom, environment, inputs, expected behavior, and observed behavior. Find the smallest reliable reproduction. If the failure is intermittent, identify the condition that changes its probability instead of adding arbitrary waits.

Preserve a working baseline or last-known-good observation before changing the experiment so later comparisons remain meaningful.

## Narrow

Follow the failing value or event backward through boundaries. Compare a working and failing path when possible. Test one hypothesis at a time with the cheapest discriminating observation. Read logs and code around the first incorrect state, not only the final exception.

For ordering or concurrency failures, build a timestamped event trace with identities and state transitions, then reproduce the smallest relevant interleaving with coordination primitives rather than sleep-based timing.

## Establish cause

A root cause must explain the symptom, the triggering conditions, and why the system did not prevent it. Verify the explanation by changing or isolating the causal condition without silently shipping a fix.

After establishing the cause, search the affected scope for analogous code, data, configuration, or tests that share the same faulty assumption. Report the likely family separately from the proven reproduction.

## Boundaries

Do not implement a repair for a diagnosis-only request. Do not hide the symptom with retries, guards, or broader timeouts. Redact secrets and personal data from evidence.

When compromise is plausible, preserve evidence and timeline through clean channels, avoid ordinary credentials on the suspected host, and involve the authorized security or forensics owner. Do not contact attacker infrastructure or make irreversible containment changes that destroy evidence unless immediate harm requires it. Keep compromise investigation separate from ordinary bug repair.

## Output

State the reproduction, observations, eliminated hypotheses, root cause, confidence, affected scope, and the smallest justified repair direction.
