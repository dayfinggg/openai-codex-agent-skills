---
name: regression-verification
description: "Select and execute evidence-based regression checks for a meaningful change. Use before completing implementation or a bug fix, with risk-proportionate validation."
---

Verify the requested behavior without creating redundant tests or claiming unperformed checks.

1. Recover the requirement, changed contract, affected consumers, and original defect evidence. Read the diff and existing checks. Preserve unrelated user changes.
2. Identify the smallest checks capable of failing when the requested behavior is wrong. Choose unit, integration, runtime, configuration, or inspection according to the actual risk. A test that mirrors implementation is not independent evidence.
3. For a defect, verify that the reproduction exercises the reported failure. If an old revision can be tested safely, observe it fail for the right reason. Do not alter the user's worktree to obtain a baseline.
4. Run existing relevant checks with the project's configured tools and versions. Confirm target selection, executed counts, meaningful assertions, and nonzero failures. An empty test run or linter-only pass does not prove runtime behavior.
5. Exercise changed failure, cancellation, concurrency, or data-compatibility paths only when the change affects them. Do not add a broad hypothetical test matrix.
6. Fix regressions introduced by the change. Distinguish unrelated pre-existing failures and do not modify them solely to obtain a green summary.
7. After passing checks, broaden or repeat only for new edits, failures, or a specific unresolved concern. Inspect the final diff for scope, generated files, secrets, and temporary materials.
8. Remove verified task-owned temporary fixtures and helpers when no process needs them. Retain requested deliverables and permanent tests that add meaningful coverage.

Finish once the requirements and relevant checks are satisfied. Report what changed, the performed validation, and only material limitations. Keep explanatory reports in chat unless a standalone document is requested.

For skill development, structural validity and host discovery are different from measured improvement on real engineering tasks. Preserve that distinction in completion claims.

