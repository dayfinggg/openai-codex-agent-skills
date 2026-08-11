---
name: implement-and-verify
description: Implement an approved bounded change and prove every acceptance criterion with observed evidence. Use for criterion-driven edits to code or artifacts after material product and architecture decisions are resolved. Skip planning-only, review-only, diagnosis-only, and work whose required behavior is still undecided.
---

# Implement and Verify

## Composition order

1. Resolve a material product, domain, interface, migration, or architecture decision before this workflow. Do not invoke a decision workflow merely because implementation is large.
2. Diagnose first only when the cause is unknown and an incorrect fix could regress behavior. Fix directly when the cause and correction are already evidenced.
3. Use this skill to own acceptance-to-change-to-evidence traceability and the final bounded diff. Apply `production-code-quality` only to retained production source. Let the applicable artifact skill own native document, spreadsheet, presentation, PDF, image, or UI verification.
4. When TDD is explicitly requested or required by repository policy, let `tdd` control each test-first behavior cycle while this skill retains criterion coverage and final evidence ownership.

Treat named supporting skills as composition roles, not package file dependencies. If one is unavailable, retain this workflow and the repository-native gates rather than guessing or loading sibling files.

## Workflow

1. Establish the approved outcome, edit scope, non-goals, acceptance criteria, and preserved behavior. Inspect the applicable repository instructions, current implementation or artifact, tests, configuration, versions, definitions, and consumers that can change the result. Stop before editing only for a contradiction, an unresolved material decision, or an unverifiable required outcome.
2. Map each criterion to its observable outcome, affected surface, intended change, and evidence gate. Use [change and evidence](references/change-evidence.md) only for multiple criteria, coupled surfaces, compatibility or migration work, or consequential quality risks. Verify a simple change directly. Do not create a traceability artifact in the repository unless requested.
3. Establish project fit before creating, moving, or renaming a retained file. Find the package or artifact root, mechanically significant names, configured generator or discovery rules, and nearby files of the same role. Preserve public paths, generated outputs, applied migration history, and deliberate local conventions. Do not impose another language's layout or naming grammar.
4. Design the smallest complete change. Include every required behavior and error path, plus only the tests, compatibility work, migration, or update to existing documentation needed to keep the result complete. Treat a new dependency, public surface, abstraction, configuration key, stateful component, concurrency mechanism, owner, feature flag, or unrelated cleanup as out of budget unless a current criterion or existing contract requires it. Compare alternatives only when the choice materially changes risk, contract, reversibility, or complexity.
5. Implement the complete in-scope paths without placeholders, test-only production branches, silent failure handling, or speculative hooks. Preserve established architecture and compatible behavior unless the approved criterion changes them.
6. Classify only the quality attributes the changed path can affect. Select repository-native gates that observe those attributes, run the narrowest reliable check first, and broaden according to risk. Do not claim compatibility, security, accessibility, performance, concurrency, migration, recovery, or presentation quality from a gate that does not observe it.
7. Inspect the full final diff and user-visible artifact. Trace every hunk to required behavior, a necessary test, preservation of a contract, migration, or a required update to existing documentation. Remove untraceable churn, duplicated mechanisms, unused generality, test weakening, and fixture-specific production logic, then rerun affected gates.
8. Reconcile every criterion with the final state and observed evidence. Distinguish passed, failed, skipped, unavailable, and inconclusive gates. Name an external blocker and its consequence instead of completing a criterion by assertion.

Read the dated [source ledger](references/sources.md) only when refreshing or justifying this workflow, not during routine implementation.

Finish when every acceptance criterion maps to a complete in-scope change and observed evidence or to a concrete external blocker, every affected quality risk is accounted for, and no untraceable diff remains.
