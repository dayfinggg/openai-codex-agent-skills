---
name: diagnose
description: Reproduce a failure or performance problem and establish its cause. Use when asked why something fails, errors, or is slow. Repair only when a fix is also authorized.
---

# Diagnose

Replace speculation with a short feedback loop and a causal explanation.

## Reproduce

Capture the exact symptom, environment, inputs, expected behavior, and observed behavior. Find the smallest reliable reproduction. If the failure is intermittent, identify the condition that changes its probability instead of adding arbitrary waits.

Preserve a working baseline or last-known-good observation before changing the experiment so later comparisons remain meaningful.

## Narrow

Follow the failing value or event backward through boundaries. Compare a working and failing path when possible. Test one hypothesis at a time with the cheapest discriminating observation. Read logs and code around the first incorrect state, not only the final exception.

For ordering or concurrency failures, trace event identities and state transitions, then reproduce the relevant interleaving with coordination primitives rather than sleeps. Across hosts, account for clock skew instead of treating timestamps alone as causal order.

## Establish cause

A root cause must explain the symptom, the triggering conditions, and why the system did not prevent it. Verify the explanation by changing or isolating the causal condition without silently shipping a fix.

After establishing the cause, search the affected scope for analogous code, data, configuration, or tests that share the same faulty assumption. Report the likely family separately from the proven reproduction.

## Boundaries

Do not implement a repair for a diagnosis-only request. Do not hide the symptom with retries, guards, or broader timeouts. Redact secrets and personal data from evidence.

If evidence suggests compromise, preserve it and its timeline through trusted mechanisms. Contacting others or attacker infrastructure, using credentials on a suspected host, and changing live containment require appropriate authorization. Report essential blockers without turning speculative concerns into incident response.

## Output

State the established cause, relevant reproduction evidence, affected scope, and remaining uncertainty. Include repair recommendations only when requested. Do not dump the investigation history.
