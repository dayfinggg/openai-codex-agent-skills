---
name: diagnose-software
description: Diagnose software defects, regressions, flaky tests, production incidents, and unexplained behavior. Use when the user asks for a cause or investigation. Do not implement a fix unless the request also authorizes changes.
---

# Diagnose Software

## Workflow

1. Define expected and observed behavior, impact, environment, frequency, onset, and a reproducible boundary.
2. Reproduce the issue or gather the strongest available evidence. Preserve exact errors, inputs, versions, timing, and recent changes.
3. Narrow the failing layer with logs, traces, metrics, tests, diffs, and minimal instrumentation. Do not change several variables at once.
4. Rank falsifiable hypotheses by evidence and cost. Run the smallest discriminating check for each.
5. Trace the causal chain from trigger through mechanism to user-visible failure. Distinguish root cause, contributing conditions, and symptoms.
6. Report confirmed facts, eliminated hypotheses, remaining uncertainty, and the smallest safe correction and regression test. If authorized, implement and verify them.

Never present correlation, a plausible story, or a disappearing symptom as a confirmed root cause. Remove temporary instrumentation unless it provides lasting value.

Read [diagnostic practices](references/practices.md) for evidence and incident guidance.
