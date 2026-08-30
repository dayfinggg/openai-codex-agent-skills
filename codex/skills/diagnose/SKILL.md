---
name: diagnose
description: Reproduce a failure, regression, or performance problem and identify its root cause with evidence. Use when the user asks why something is broken, failing, crashing, flaky, or slow. Do not modify the implementation unless the request also asks for a fix.
---

# Diagnose

Replace speculation with a short feedback loop and a causal explanation.

## Reproduce

Capture the exact symptom, environment, inputs, expected behavior, and observed behavior. Find the smallest reliable reproduction. If the failure is intermittent, identify the condition that changes its probability instead of adding arbitrary waits.

## Narrow

Follow the failing value or event backward through boundaries. Compare a working and failing path when possible. Test one hypothesis at a time with the cheapest discriminating observation. Read logs and code around the first incorrect state, not only the final exception.

## Establish cause

A root cause must explain the symptom, the triggering conditions, and why the system did not prevent it. Verify the explanation by changing or isolating the causal condition without silently shipping a fix.

## Boundaries

Do not implement a repair for a diagnosis-only request. Do not hide the symptom with retries, guards, or broader timeouts. Redact secrets and personal data from evidence.

## Output

State the reproduction, observations, eliminated hypotheses, root cause, confidence, affected scope, and the smallest justified repair direction.
