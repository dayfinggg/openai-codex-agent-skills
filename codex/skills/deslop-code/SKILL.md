---
name: deslop-code
description: Simplify generated-looking or unnecessarily complex code while preserving verified behavior.
---

Use this skill when the user explicitly asks to clean up, simplify, deslop, or reduce generated-looking code without changing its contract.

Identify the behavior and invariants that must remain true, then inspect the smallest relevant scope. Remove accidental complexity, redundant branches, needless wrappers, speculative abstractions, stale comments, and duplication only when the resulting code is clearer and still fits repository conventions. Prefer direct control flow and existing abstractions; do not replace one form of indirection with another.

Run focused regression checks for the preserved behavior and inspect the diff for unrelated changes. If behavior cannot be established well enough to prove preservation, state that limitation instead of describing the cleanup as behavior-preserving.
