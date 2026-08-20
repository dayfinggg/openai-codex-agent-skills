---
name: test-driven-development
description: Implement new behavior or regressions with focused red-green-refactor tests.
---

Use this skill when adding behavior, fixing a regression, or when the user requests test-first development.

Test through public interfaces and agreed seams. Write a failing test that captures the requested behavior before the fix when a suitable seam exists. Make the smallest implementation change that turns it green, then refactor only when behavior remains covered. Run focused checks after each slice and the relevant broader suite at the end. Avoid tautological tests, excessive mocking, and tests that duplicate implementation details.
