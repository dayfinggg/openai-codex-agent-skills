---
name: tdd
description: Develop a feature or bug fix through a focused failing-test, minimal-implementation, and refactor loop. Use when the user requests TDD, asks for a regression test, or the bug has an obvious cheap local test target. Do not force TDD when the useful test path is unclear, expensive, or integration-heavy.
---

# TDD

Follow the governing instructions and the user's requirements for communication, code style, authorization, and delegation. This skill supplies task-specific guidance, not permission to expand the task. Its workflow and output fields describe internal checks and relevant content, not a mandatory response layout or a progress report. When used within broader authorized work, continue that work through completion rather than stopping to deliver this skill's intermediate result.

Use a test to define behavior before implementation when that test provides a fast and trustworthy feedback loop.

## Red

Choose the narrowest test seam that observes public behavior rather than internal steps. Write one test for the missing or broken behavior. Run it and confirm that it fails for the expected reason. A syntax error, unrelated failure, or test that already passes does not establish red.

## Green

Make the smallest production change that satisfies the test without weakening assertions or bypassing the real path. Run the focused test until it passes, then run nearby tests that protect the same contract.

## Refactor

Improve names and structure only while tests remain green. Avoid speculative generalization. Add another test only for a distinct behavior or failure mode.

## When red is impractical

Explain why the test cannot be made cheap or reliable. Use a reproduction script, integration check, or manual observable check instead. Do not create a brittle test merely to satisfy the workflow.

Time pressure alone is not a reason to skip the red, green, and refactor evidence or the relevant regression checks. When an alternate check is necessary, record the behavior it does not prove and the resulting residual risk.

## Output

Report the failing observation, implementation change, passing evidence, and any broader checks.
