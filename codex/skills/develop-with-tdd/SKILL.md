---
name: develop-with-tdd
description: Develop behavior through test-driven development. Use for new or changed behavior, regression fixes, and explicit TDD requests when fast deterministic tests can guide design. Do not force TDD for disposable exploration, pure formatting, generated artifacts, or behavior that is not yet understood.
---

# Develop with TDD

## Workflow

1. Inspect the test framework, commands, conventions, and public behavior.
2. List the next valuable behavior and its important edge cases. Choose one small case.
3. Write a behavior-focused test and run it. Confirm it fails for the intended reason.
4. Implement the minimum production code that makes the test pass.
5. Run the test, then refactor without changing behavior while keeping tests green.
6. Repeat red, green, refactor. Finish with relevant boundary, integration, static, and full-suite checks.

Test observable contracts rather than implementation details. Prefer real, fast, deterministic collaborators over broad mocking. A mock proves an interaction, not an integration. For legacy behavior, add characterization tests before changing it. Never claim a red or green state without running the test.

Read [TDD practices](references/practices.md) when choosing test scope, doubles, or a legacy strategy.
