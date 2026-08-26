---
name: diagnose-bugs
description: Reproduce and isolate a bug, regression, failure, or unexplained behavior before fixing it.
---

Use this skill for bug reports, regressions, failures, incidents, or unexplained behavior where the cause is not already established by direct evidence.

Capture the expected behavior, observed symptom, relevant environment, and current evidence. Build the smallest deterministic reproduction available. Rank a small set of falsifiable hypotheses and test one distinguishing fact at a time. Prefer a failing regression test or focused trace before changing the implementation when a suitable seam exists.

Fix the verified cause with the smallest complete change. Keep the original symptom as a regression check, remove temporary instrumentation, and distinguish the verified cause from plausible but unproven contributing factors.
