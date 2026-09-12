---
name: tdd
description: Use a failing test to drive an authorized change when TDD is requested or a regression has a cheap reliable test. Skip brittle or impractical test-first loops.
---

# TDD

Use a test to define behavior before implementation when that test provides a fast and trustworthy feedback loop.

## Red

Choose the narrowest test seam that observes public behavior rather than internal steps. Write one test for the missing or broken behavior. Run it and confirm that it fails for the expected reason. A syntax error, unrelated failure, or test that already passes does not establish red.

## Green

When implementation is authorized, make the smallest change that satisfies the test without weakening assertions or bypassing the real path. Rerun after each relevant edit, then check nearby behavior protecting the same contract. A test-only request does not authorize production changes.

## Refactor

Improve names and structure only while tests remain green. Avoid speculative generalization. Add another test only for a distinct behavior or failure mode.

## When red is impractical

Explain why the test cannot be made cheap or reliable. Use a reproduction script, integration check, or manual observable check instead. Do not create a brittle test merely to satisfy the workflow.

Time pressure alone is not a reason to skip the red, green, and refactor evidence or the relevant regression checks. When an alternate check is necessary, record the behavior it does not prove and the resulting residual risk.

## Output

Report the failing observation, implementation change, passing evidence, and any broader checks.
