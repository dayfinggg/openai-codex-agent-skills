---
name: test-driven-development
description: Use a focused red-green-refactor loop when test-first development is requested or a regression has a suitable behavioral seam.
---

Use this skill when the user requests TDD or test-first work, or when a reproducible regression can be captured by a focused failing behavior test before the fix without distorting the design. Do not force test-first work when no stable seam exists or the task is documentation, configuration, exploratory diagnosis, or another case where a pre-fix test adds little evidence.

Test through a public interface or agreed seam. Make the smallest test fail for the intended reason, then make the smallest implementation change that turns it green. Refactor only while the behavior remains covered. Avoid tautological assertions, excessive mocking, and tests that duplicate the production algorithm. Run the focused test during the loop and the relevant broader suite before completion.
