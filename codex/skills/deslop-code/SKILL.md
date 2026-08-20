---
name: deslop-code
description: Simplify generated-looking code without changing behavior.
---

Use this skill when the user asks to clean up, simplify, deslop, or reduce generated-looking code.

Establish the behavior to preserve and inspect the smallest relevant scope. Remove only code that is unnecessary for behavior, safety, or repository conventions. Prefer direct control flow, existing abstractions, and minimal diffs. Do not add speculative abstractions, broad error handling, casts that suppress type errors, deep nesting, or explanatory comments. Run focused checks and confirm that the diff changes no unrelated behavior.
