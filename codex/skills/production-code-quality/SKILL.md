---
name: production-code-quality
description: Implement and verify maintained production source in any language or DSL with repository-first rules, exact toolchains, fallback code-shape gates, and risk-based evidence. Use whenever creating or changing retained code, including correctness-, compatibility-, security-, performance-, concurrency-, accessibility-, data-, or operations-sensitive paths. Skip review-only, planning-only, diagnosis without fixes, disposable examples, derived generated output, and vendored code.
---

# Production Code Quality

## Outcome and rule resolution

Produce the smallest complete change that satisfies the requested behavior and leaves unrelated behavior, public contracts, project topology, and concurrent work unchanged.

Resolve every implementation rule in this order:

1. Follow active instructions, the requested outcome, permissions, and acceptance criteria.
2. Follow the closest scoped repository instructions and approved specifications.
3. Use manifests, lockfiles, generators, and configured formatter, linter, analyzer, compiler, type checker, test, and build rules for the changed surface.
4. Use official documentation for the exact language, runtime, framework, protocol, and tool versions when local definitions do not settle the contract.
5. Preserve coherent, compatible precedent in the same package or feature.
6. Use this skill's fallback policy only for a decision left open by every higher source.

Treat a configured project check as a hard gate in its declared scope. Do not weaken, suppress, bypass, or replace it unless the task explicitly changes that policy. Apply fallback shape gates to new units and materially reshaped changed units. For a surgical edit inside pre-existing legacy code that already exceeds a fallback threshold, do not force an unrelated rewrite. Preserve or improve the metric and record a bounded legacy exception.

## Ordered workflow

1. Establish the observable outcome, edit authority, retained-code surface, non-goals, acceptance criteria, and behavior that must remain stable. Exclude derived generated and vendored files unless the task changes their source of truth or generation contract.
2. Find the affected package or application root. Inspect only the governing instructions, nearby implementation and tests, definitions and callers, manifests and lockfiles, effective versions, module mode, build targets, and configured quality tools that can change the result.
3. Load one applicable language reference for every language with changed retained source: [Python](references/python.md), [TypeScript and JavaScript](references/typescript-javascript.md), [Go](references/go.md), [Rust](references/rust.md), [Java and Kotlin](references/java-kotlin.md), [.NET](references/dotnet.md), [C and C++](references/c-cpp.md), [Swift](references/swift.md), or [other languages and DSLs](references/other-languages.md). Do not load unrelated language guides.
4. Read [code shape and naming](references/code-shape-and-naming.md) when adding or materially changing declarations, control flow, parameters, names, or comments, and whenever repository metric policy is absent. Read [project structure and file roles](references/project-structure-and-file-roles.md) only when creating, moving, renaming, exporting, or assigning a role to a file, module, package, test, migration, configuration, or generated artifact.
5. Trace the changed contract through inputs, outputs, invariants, error behavior, resource lifetime, cancellation, serialization, public seams, and reachable consumers. For a poorly understood or weakly tested area, read [legacy change](references/legacy-change.md) and establish the smallest useful characterization baseline.
6. Classify only affected quality attributes using the table below. Name the concrete failure mode and an observable gate for each activated attribute. Do not add machinery for an unaffected quality.
7. Design the smallest complete change. Apply [simplicity and SCC-Guard](references/simplicity.md) whenever the candidate adds an abstraction, dependency, public surface, configuration, shared state, concurrency, background work, extension point, or an otherwise broader diff. Read [readability and design](references/readability-design.md) for a material cohesion, control-flow, data-flow, or boundary decision, and [state and authoritative knowledge](references/state-and-knowledge.md) for duplicated knowledge, derived data, or cache ownership.
8. Implement the normal, boundary, and material failure paths without placeholders, silent error handling, test-specific branches, speculative hooks, or unrelated cleanup. Preserve existing comments and documentation, updating them only when the change would otherwise make them false or the repository contract requires an addition.
9. Run the narrowest configured format check, analyzer, type or compiler check, behavior test, and build that can distinguish success. Then run only the risk-specific gates selected in step 6. Apply fallback shape gates where no repository policy exists.
10. Inspect the complete diff and resulting artifact. Remove every hunk, symbol, wrapper, option, dependency, comment, and compatibility path that cannot be traced to a current criterion, required failure path, consumer, migration, or reliable verification need. Re-run affected checks after removal.

## Affected-quality classification

| Quality | Activate when the changed path can affect | Required evidence |
| --- | --- | --- |
| Correctness and maintainability | Every retained-code change | Configured static gates plus focused behavior on normal, boundary, and material failure paths. |
| Compatibility and migration | Public API, ABI, CLI, schema, wire or persisted format, configuration, defaults, or supported runtime | Read [compatibility](references/compatibility.md). Verify affected old and new consumers or data, transition, and recovery. |
| Security | A trust boundary, authorization, secrets, sensitive data, untrusted input, rendering, files, commands, dependencies, build, or deployment | Read [security](references/security.md). Verify the relevant negative path, least privilege, resource bounds, and absence of secret leakage. |
| Performance, memory, I/O, or cost | An explicit budget, regression, measured hot path, materially growing data, or a claimed optimization | Read [performance](references/performance.md). Require a correct comparable baseline, profiler evidence, repeated measurements, and an independent workload before claiming improvement. |
| Concurrency, cancellation, resilience, or resource lifetime | Shared mutable state, async or background work, queues, networking, retries, or owned resources | Read [concurrency and resilience](references/concurrency-resilience.md). Verify ownership, termination, ordering, bounds, cancellation, failure propagation, and cleanup. |
| External API or dependency contract | A package, SDK, protocol, generated client, or version-sensitive symbol is added, upgraded, or materially relied upon | Read [API and dependency contracts](references/api-contracts.md). Confirm exact installed definitions and a success and material error path. |
| Testing strategy | The task selects or changes test level, fixtures, isolation, or cross-boundary coverage | Read [testing](references/testing.md). Map each material risk to the cheapest reliable observable seam. |
| Accessibility, availability, data integrity, rollback, or operations | The changed path can alter that user or production property | Use the repository's specialist tools and contracts. Do not claim the property from a generic build or unit test. |

Use [sources](references/sources.md) only when a durable source is needed to resolve a trade-off or support a recommendation. Prefer current exact-version primary documentation for changeable contracts.

## SCC-Guard

Start with a zero budget for new production dependencies, public symbols, abstraction layers, configuration keys, shared state, concurrency models, background workers, feature flags, speculative fallbacks, independent renames, and broad formatting. Exceed a coordinate only for a current criterion, consumer, established boundary, or demonstrated verification need.

Choose the least mechanism that is sufficient: an existing local path, then a language feature, the standard library, an already installed core dependency, a small local helper, and only then a new abstraction or dependency. Compare alternatives only when two viable choices differ materially in contract, risk, reversibility, or measured performance.

## Stop conditions and completion evidence

Stop before mutation when edit authority is absent, a material product or architecture decision remains unresolved, an exact contract cannot be established and guessing can change behavior, or the next step requires an unrequested external, destructive, privileged, or hard-to-recover action. A missing optional gate does not by itself require stopping. Continue with available evidence and report the missing property unless safe correctness depends on that gate. Do not repeat an unchanged failed check.

Finish when the requested behavior and every material failure path are implemented, configured and fallback gates are passed or covered by a justified exception, every activated quality has observed evidence or a precise limitation, and direct diff inspection shows no unsupported complexity or scope growth.
