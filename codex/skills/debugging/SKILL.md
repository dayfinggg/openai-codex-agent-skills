---
name: debugging
description: Diagnose bugs or performance regressions whose cause is not clear from the error.
---

Build a repeatable check for the reported symptom. Use a failing test, real request, CLI invocation, browser flow, or captured trace.
Minimize the failing case without changing the failure being investigated.
Rank plausible causes and state what observation would disprove each one. Probe one variable at a time.
For intermittent failures, measure the reproduction rate and control shared state, timing, and randomness.
For performance regressions, record a baseline and profile the slow path before choosing a fix.
Turn the minimized reproduction into a regression check at the interface that actually exposes the fault.
After the fix, rerun the original scenario and remove temporary instrumentation.
When only a human can reproduce the failure, read [hitl-loop.template.sh](scripts/hitl-loop.template.sh) and adapt its observation loop.
If reproduction is impossible, report the attempts and the specific missing access or artifact rather than guessing.
