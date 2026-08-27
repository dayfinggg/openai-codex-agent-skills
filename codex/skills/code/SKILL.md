---
name: code
description: Write, modify, refactor, and review production code using the project's actual versions, conventions, contracts, and validation. Use for implementation, bug fixes, performance or security work, API changes, and code quality improvements in any language or stack.
---

# Code

Produce the smallest complete change that solves the stated problem and improves or preserves the surrounding code's health. Treat principles as decision tools, not goals to maximize.

## Start from the project

1. Define the requested behavior, acceptance evidence, scope boundary, and public behavior that must remain unchanged.
2. Inspect applicable instructions, nearby code, tests, manifests, lockfiles, formatter and linter settings, compiler options, generated-code boundaries, and relevant history before choosing a design.
3. Determine the exact language, runtime, framework, library, SDK, database, protocol, and tool versions in use. Consult official documentation and release notes for those versions. Do not silently upgrade or use a newer API because it is preferable in isolation.
4. Reuse the project's established architecture and idioms unless they cause the defect or prevent the requested outcome. Local consistency outranks a generic style preference.
5. Choose the least complex design that satisfies current confirmed requirements, failure modes, security needs, and performance constraints. Avoid speculative layers and premature generalization.

## Implement completely

1. Write real, runnable logic. Do not add comments, explanatory prose, placeholders, stubs, pseudocode, TODO or FIXME markers, dummy values, ignored branches, or unfinished fallbacks. Preserve required license headers and generated markers without adding new commentary.
2. Keep the diff focused. Do not rename, move, reformat, upgrade, or redesign unrelated code.
3. Make contracts explicit through types, signatures, schemas, validation, and tests. Validate untrusted input at the boundary and keep valid internal states easy to represent.
4. Keep state changes and external effects visible. Separate pure decisions from I/O when that makes behavior easier to test or reason about, without forcing every function into a functional style.
5. Prefer cohesive modules with narrow interfaces. Hide change-prone implementation details and avoid global state, hidden dependencies, cross-layer shortcuts, and bidirectional coupling.
6. Add a dependency only when existing project facilities or the standard library cannot solve the requirement cleanly. Verify its supported versions, maintenance, security record, license, transitive cost, and lockfile impact.
7. Preserve public APIs, persisted data, configuration, commands, protocols, error contracts, and supported environments unless the task requires a break. Provide a deliberate migration or compatibility path when callers cannot change atomically.

## Load conditional guidance

1. Read [references/design.md](references/design.md) before introducing or changing abstractions, functions, modules, classes, interfaces, public APIs, or architecture.
2. Read [references/runtime.md](references/runtime.md) when the change touches error handling, resources, concurrency, asynchronous work, performance, caching, security, dependencies, releases, or compatibility.
3. Do not load either reference for a trivial local edit whose design and runtime behavior are already fixed by adjacent code.

## Validate behavior

1. Map each requested behavior and material failure mode to observable evidence. Add or update tests when the repository has an established test location and the changed behavior is not already covered.
2. Test the narrowest changed unit first, then the affected integration path, and only then broader suites that add confidence. Use the project's existing commands and infrastructure.
3. Cover the regression, boundary values, invalid input, relevant failures, and compatibility behavior. Prefer deterministic tests of public behavior over implementation-shaped assertions or excessive mocks.
4. Run applicable formatting, static analysis, type checking, compilation, tests, and packaging. Run race, sanitizer, security, migration, or benchmark checks when the changed risk requires them and the project supports them.
5. Review the final diff for accidental scope growth, dead code, duplicated knowledge, leaked secrets, swallowed errors, unbounded work, stale documentation, and unsupported API use.
6. Report only results actually observed. Separate unrelated pre-existing failures from failures caused by the change.
