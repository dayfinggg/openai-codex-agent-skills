---
name: refactor-safely
description: Refactor focused internals without behavior changes. Handle decomposition, renaming, boundary cleanup, or deduplication. Route audits to $review-code-quality and repo-wide normalization to $standardize-project.
---

# Refactor Safely

Preserve externally observable behavior while improving internal structure. Treat any required behavior change as separate work unless the user explicitly authorizes it.

## Workflow

1. Establish the contract.
   - Identify affected callers, public types, schemas, persistence formats, commands, exit codes, side effects, error behavior, and relevant performance or security constraints.
   - State the invariants that must remain true.
   - Inspect repository instructions and existing conventions before choosing a design.

2. Capture the baseline.
   - Run the narrowest relevant existing checks before editing.
   - Add focused characterization tests only when important behavior is otherwise unprotected and repository practice supports tests.
   - Record pre-existing failures and keep them distinct from regressions introduced by the refactor.

3. Select a seam.
   - Find the smallest boundary that permits an independently verifiable change.
   - Prefer changes that reduce coupling, clarify responsibility, or make dependencies explicit.
   - Avoid touching adjacent modules unless required to preserve the selected seam.

4. Refactor incrementally.
   - Make one small, reversible structural change at a time.
   - Keep public names, signatures, protocols, serialization, and side effects stable unless a contract change is explicitly authorized.
   - Preserve evaluation order and count, including name and property lookup, getters, proxies, coercion, overloaded operators, callbacks, errors, and mutable global or ambient state. Do not precompute, cache, reorder, or extract an expression until equivalence is protected by evidence.
   - Update all affected internal call sites atomically.
   - Remove duplication only when the copies express the same stable concept and are expected to change together.

5. Validate each meaningful step.
   - Run the narrow relevant formatter, static checks, and tests after each coherent change.
   - Investigate a failure before continuing. Revert or revise the last structural change when behavior cannot be shown equivalent.
   - Broaden validation only after focused checks pass and the affected surface justifies it.

6. Finish narrowly.
   - Review the final diff for accidental behavior changes, compatibility drift, dead code, unrelated formatting, and widened scope.
   - Remove temporary compatibility paths or transitional code unless an existing contract still requires them.
   - Report the preserved contract, structural change, and validation evidence without claiming safety beyond the checks performed.

## Guardrails

- Prefer the smallest readable design that improves the demonstrated problem.
- Keep local duplication when similarity is incidental, ownership differs, or future change is unlikely to stay coupled.
- Route read-only review or audit work to `$review-code-quality`; do not mutate code under a review-only request.
- Route repository-wide convention, layout, naming, or build and lint normalization to `$standardize-project`.
- Do not mix feature implementation, defect diagnosis or behavior fixes, dependency upgrades, migrations, broad rewrites, or cosmetic cleanup into the refactor. Use `$debug-systematically` for defects and `$migrate-codebases` for platform, runtime, framework, contract, or stored-data transitions.
- Stop and re-scope when preserving behavior requires a new public contract, data transformation, platform transition, or product decision.
- Do not add speculative abstractions, compatibility layers without active consumers, placeholders, or suppression directives.
- Preserve generated artifacts through their source or generator instead of editing them directly.
