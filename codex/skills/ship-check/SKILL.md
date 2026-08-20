---
name: ship-check
description: Run focused final checks before handing off code changes.
---

Use this skill before completing an implementation, bug fix, or refactor when validation is possible or the user asks whether the work is ready.

Confirm that the diff is non-empty, in scope, and free of temporary instrumentation, caches, and generated artifacts that do not belong in the change. Inspect tracked and untracked files. Run the smallest relevant tests first, then the broader relevant suite and configured formatting, type, or lint checks when justified. Check changed behavior through its public path and add an independent boundary, concurrency, security, or performance check when the claim requires it. Do not treat model-authored tests alone as independent proof. Separate passed checks, skipped checks, and unresolved risks. Do not add new behavior during this pass.
