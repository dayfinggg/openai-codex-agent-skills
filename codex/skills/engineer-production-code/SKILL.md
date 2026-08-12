---
name: engineer-production-code
description: Use for every request to write, generate, modify, implement, or provide executable code or tests, even when no files change and code appears only in the answer. Apply this production baseline with narrower implementation skills; exclude read-only review and architecture-only decisions.
---

# Engineer Production Code

Use this for every executable code or test deliverable. Apply it as a companion baseline with narrower implementation skills and as the primary workflow for standalone code generation. Let language, framework, and domain skills supply ecosystem details. Resolve conflicts in favor of higher-priority instructions and verified repository requirements.

## Establish the Contract

- Inspect applicable instructions, nearby code, public contracts, dependencies, configured tooling, and supported runtime versions before editing.
- Define the observable behavior and acceptance conditions. Preserve compatibility unless the request explicitly changes it.
- Verify material requirements. Request missing input when it would change correct behavior instead of inventing an API, dependency, format, or business rule.

## Choose the Design

- Implement the smallest complete change that solves the present requirement.
- Apply KISS and YAGNI. Avoid speculative features, configurability, layers, abstractions, and unrelated refactors.
- Apply DRY only to stable, repeated concepts. Prefer clear local duplication to a premature shared abstraction.
- Apply SOLID where it creates cohesive responsibilities, explicit dependencies, and useful change boundaries. Do not introduce ceremony to satisfy a pattern.
- Reuse suitable project dependencies. Add the fewest new dependencies necessary and verify their maintenance, compatibility, security posture, and license when addition is required.

## Implement Complete Behavior

- Follow repository structure, naming, formatting, and established patterns unless they are the defect being corrected.
- Use current stable idioms supported by the existing toolchain. Do not upgrade the toolchain solely to adopt a newer pattern.
- Use precise domain names, cohesive units, explicit state and dependencies, and strong types where the language supports them.
- Validate untrusted input at trust boundaries. Use secure defaults, least privilege, safe serialization, parameterized data access, and secret-safe handling.
- Handle expected failures deliberately. Preserve useful error context, avoid silent recovery, and leave the system in a valid state after partial failure.
- Manage resources, cancellation, concurrency, transactions, and retries according to their actual lifecycle and failure modes.
- When an idempotency key or retry token is part of the contract, bind it to a stable request fingerprint for the full accepted reuse window. Keep five semantics distinct in storage and code, using project-native names: `new` may claim and start the effect; `in-progress` must wait or return without starting it again; terminal success or failure replays its result; `conflicting` rejects a different fingerprint; `unknown` reconciles the original effect with the same key. A conflict is a caller outcome, never a replacement binding: preserve the original fingerprint and state, let the original fingerprint continue through that state, and reject every different fingerprint without starting an effect. Never collapse these semantics into a generic proceed or failure state, and never release or overwrite the binding after a conflict, failed outcome, or ambiguous attempt unless the verified contract explicitly permits reuse.
- Require the effect adapter and store to classify terminal failure, conflict, in-progress, and unknown outcomes rather than treating every rejection as unknown. Reconcile unknown through a verified status lookup or an idempotent retry with the same key. If the existing contracts provide neither classification nor reconciliation, report that complete behavior is blocked; do not label a partial wrapper production-ready or make repeated unknown errors stand in for reconciliation.
- When a required guarantee is blocked by the known contracts, provide no executable replacement, patch, or tests for a weaker behavior unless the user separately requests a best-effort partial design after the limitation is clear. A disclaimer does not make partial code a complete solution. State the exact missing contract and the minimum verifiable capability needed to proceed.
- Complete every production execution path. Preserve behavior outside the requested scope.

## Enforce Source-File Hygiene

- Do not add redundant comments, doc comments, docstrings, or documentation that merely narrates code. Add them only when required by repository conventions, public API contracts, licensing, generated-file markers, tool directives, or to record material rationale, invariants, concurrency constraints, or correctness conditions that code cannot make clear.
- Do not add TODO, FIXME, XXX, commented-out code, dead code, placeholders, fake implementations, dummy returns, accidental no-ops, unfinished branches, or production stubs.
- Preserve valid existing comments. Update or remove them only when the change makes them obsolete or incorrect.
- Add source metadata only when syntax, licensing, generated-code conventions, tool directives, public contracts, or correctness strictly require it.
- Do not hand-edit generated output. Change its source or generator and regenerate it.
- Keep test doubles, fixtures, and synthetic data inside tests. Make them minimal and faithful to the exercised contract.

## Verify the Result

- Add or update focused behavioral tests in proportion to risk and repository practice. Cover material boundary and failure cases. For idempotent behavior, inject terminal success, terminal failure, conflict, in-progress, and unknown outcomes; prove duplicate concurrency, terminal replay, unknown reconciliation, and that conflicts before and after every reachable state preserve the original binding without another effect.
- Run the narrow configured formatter, linter, type checker, tests, and build relevant to the change. Broaden checks only when the affected surface justifies it.
- Inspect the final diff for scope creep, incomplete behavior, obsolete artifacts, accidental public-contract changes, and source-file policy violations.
- Report validation limits and unresolved risks accurately. Never claim an unrun check or unobserved outcome.
