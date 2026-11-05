---
name: review
description: Reviews a diff, branch, or pull request against requirements and repository standards, with general and security-focused modes. Use when the user asks to review, check, audit, or verify code changes, a PR, a branch, a diff, or findings from another session, including XSS, SQL injection, or other security findings. Not implementation of fixes.
---

1. Pin the reviewed head, baseline, and requested working-tree changes. For a branch or PR, resolve the target's merge-base. For an explicit snapshot comparison, use the supplied endpoints. Include staged, unstaged, and untracked files only within the requested scope. Verify that the references resolve and distinguish an empty diff from a failed retrieval. Inspect baseline files without moving HEAD or changing the index.

2. Recover requirements from the request, linked issue, and relevant repository specifications. Read applicable repository instructions, CONTRIBUTING.md, and CODING_STANDARDS.md when present. Keep two internal records, requirement coverage and documented-standard compliance. An unavailable specification limits coverage assessment, not the remaining review. Treat author claims such as "safe refactor" as hypotheses rather than evidence.

3. Use general mode by default. Read [the security procedure](references/security.md) when security review is requested or a changed trust boundary, permission, validation, cryptographic operation, value transfer, or external interaction needs adversarial analysis. This adds security analysis to the same review and evidence gate. Do not classify UI, logging, or tests as harmless by filename.

4. Account for every in-scope changed file. Read changed logic with its surrounding implementation and affected callers, dependencies, configuration, and tests. Follow a path beyond the diff when needed to resolve a concrete compatibility or behavior question. Record any excluded or unread portions. Use these defect classes as prompts for relevant checks, not as a quota of findings.

- Requirements can be missing, partially wired, implemented in the wrong layer, or accompanied by unrequested behavior.
- Callers can retain old types, defaults, error handling, serialization, event types, or access assumptions after a contract changes.
- State transitions can double-apply effects, lose updates, violate transaction boundaries, or behave differently on retry, cancellation, timeout, and partial failure.
- Data paths can mishandle empty, null, zero, duplicate, boundary, timezone, ordering, pagination, or tenant-specific inputs admitted by the contract.
- Resource paths can leak handles or memory, outlive owners, deadlock, race, or turn expected workloads into unbounded work.
- Rollouts can mix incompatible code, schemas, configuration, cache entries, or installed dependency versions.
- Tests can mock away the broken boundary, never reach the changed branch, assert implementation details, or pass even with the defect present. User-facing changes can leave instructions or interfaces inconsistent.

5. Challenge each candidate before reporting it. Identify the violated requirement, contract, invariant, or explicit repository rule. Cite the smallest relevant code location and quote the decisive line. Trace the admitted input or reachable state through the real caller to the wrong result. Search for validation, synchronization, ownership, or a repair elsewhere that would invalidate the claim. Compare with the baseline to separate introduced regressions from pre-existing issues.

6. Require reproducible evidence for every finding. Prefer a focused test or minimal reproducer with exact setup, input, expected result, actual result, and executed output. When execution is unavailable, supply a deterministic, line-by-line counterexample using concrete values or a specified interleaving, labelled as static evidence. If neither establishes the failure, keep it out of confirmed findings and report only a material unresolved check. Run review probes without editing tracked source or contacting live systems outside the authorized scope.

7. Report findings by actual impact using the requested format. For each, give severity with its reason, file and line at the reviewed revision, decisive code, triggering condition, wrong behavior, reproducible evidence, and the violated requirement or rule. Group repeated symptoms under their shared cause. Separate explicit standards violations from functional defects. Omit personal style preferences, smell labels without consequences, formatter output, speculative refactors, and unsupported performance claims. Missing tests guide investigation and may violate an explicit test requirement, but do not establish a vulnerability or its severity.

8. End with the checked scope, relevant validation outcome, and material gaps. When none are confirmed, say no defects were found within that scope. Do not equate this with exhaustive correctness. Return the review in chat unless a report artifact was requested. A GitHub comment, approval, or request-changes submission needs explicit publication authorization, separate from the local verdict.
