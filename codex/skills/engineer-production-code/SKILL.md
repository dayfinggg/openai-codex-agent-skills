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
- When retries, idempotency, distributed effects, or ambiguous outcomes are material, use the relevant domain skill and verified service contracts rather than inventing guarantees.
- If a required guarantee is blocked by known contracts, state the missing capability and do not present a weaker implementation as production-ready. Implement an explicitly requested prototype or partial migration step only with its limitations and acceptance boundary made clear.
- Complete every production execution path. Preserve behavior outside the requested scope.

## Enforce Source-File Hygiene

- Do not add comments, doc comments, docstrings, or documentation that merely narrate code. Add concise documentation when required by repository conventions, public API contracts, licensing, generated-file markers, tool directives, or to explain material rationale, invariants, security, concurrency, algorithms, or correctness conditions that code cannot make clear.
- Do not use TODO-style notes, commented-out code, dead code, placeholders, fake implementations, dummy returns, accidental no-ops, unfinished branches, or production stubs as substitutes for complete requested behavior. Add a tracked TODO only when project convention and the requested scope require deferred work; make its owner or removal condition discoverable.
- Do not create a new README, changelog, migration note, implementation report, audit report, plan, summary, or other standalone Markdown or documentation file unless the user explicitly requests that artifact. Report completed work in the final response. Update existing documentation only when requested or when the code change would otherwise leave it materially incorrect.
- Preserve valid existing comments. Update or remove them only when the change makes them obsolete or incorrect.
- Add source metadata only when syntax, licensing, generated-code conventions, tool directives, public contracts, or correctness strictly require it.
- Do not hand-edit generated output. Change its source or generator and regenerate it.
- Keep test-only doubles and fixtures outside production runtime and place them according to repository convention. Make them minimal, faithful to the exercised contract, and free of production secrets or personal data.

## Verify the Result

- Define the observable behavior and material risks before choosing tests. Use the lowest layer that reproduces each behavior faithfully: unit tests for local logic, integration or contract tests for real boundaries and serialization, and a small end-to-end set for critical user journeys or production-like wiring. Add another layer only when it detects a distinct failure class.
- Assert stable public behavior, side effects, and invariants rather than private methods, incidental calls, internal ordering, or broad snapshots unless those details are contractual. Give each test one coherent reason to fail and a name that identifies the behavior and condition.
- Cover relevant normal, boundary, negative, recovery, and regression cases in proportion to risk. Keep fixtures minimal and explicit. Use faithful doubles to isolate the tested unit or inject failures at narrow boundaries; prefer real local collaborators when their semantics are what the test must verify.
- Keep ordinary automated tests isolated, repeatable, and deterministic. Control clocks, randomness, locale, environment, retries, and external I/O; avoid arbitrary sleeps, execution-order dependencies, and shared residue. For concurrency, stress, and fuzz tests, bound and record seeds or schedules where supported, and assert invariants rather than incidental ordering.
- When safe and inexpensive, confirm a regression test fails with the targeted defect and passes with the correction. Use coverage to find untested behavior, not as a percentage target, and do not add redundant or trivial tests to raise it.
- Run the narrow configured formatter, linter, type checker, tests, and build relevant to the change. Broaden to integration, contract, end-to-end, security, performance, migration, or accessibility checks when the affected contract or risk justifies it.
- Inspect the final diff for scope creep, incomplete behavior, obsolete artifacts, accidental public-contract changes, and source-file policy violations.
- Report validation limits and unresolved risks accurately. Never claim an unrun check or unobserved outcome.
