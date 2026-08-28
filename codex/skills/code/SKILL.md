---
name: code
description: Implement or refactor production code in an existing repository. Use when executable code changes are the primary work, including diagnosed bug fixes. Pair with affected domain skills; do not use for read-only review, diagnosis-only, architecture-only, or plan-only requests.
---

# Code

Implement the smallest complete change that satisfies the repository's current contracts. Use this skill for code design and implementation quality. Follow the base model instruction for repository discovery, authorization, tool use, general validation order, and final reporting; load specialist skills only for domains the change materially affects.

## Fit the codebase

1. Define the requested observable behavior, scope boundary, and public behavior that must remain unchanged.
2. Use the exact installed language, runtime, framework, library, SDK, protocol, database, and tool versions. Follow established repository and language idioms rather than importing a generic style.
3. Reuse the current architecture unless it causes the defect or prevents the requested outcome. Choose the design with the fewest concepts, states, branches, dependencies, and layers that still satisfies confirmed correctness, failure, security, and performance requirements.
4. Treat KISS, YAGNI, DRY, SOLID, functional design, and object design as decision aids, not targets. Do not reshape code merely to demonstrate a principle.

## Implement the behavior

1. Make contracts explicit at the boundary through appropriate types, signatures, schemas, validation, and error behavior. Keep valid internal states easy to represent.
2. Keep state changes, resource ownership, and external effects visible. Separate decisions from I/O when that materially improves reasoning, testing, or failure handling without forcing an unnatural paradigm.
3. Prefer cohesive modules with narrow interfaces. Hide change-prone details and avoid global state, ambient dependencies, cross-layer shortcuts, bidirectional coupling, and abstractions that need flags or type checks to serve unrelated callers.
4. Add a dependency only when the standard library and installed project facilities cannot solve the requirement cleanly. Account for compatibility, maintenance, license, transitive and runtime cost, resolved versions, and removal cost.
5. Preserve public APIs, persisted data, configuration, commands, protocols, errors, ordering, timing, and supported environments unless the task requires a break. Provide a deliberate compatibility or migration path when consumers cannot change atomically.

## Load conditional guidance

1. Read [design decisions](references/design.md) before introducing or materially changing abstractions, modules, classes, interfaces, public APIs, or architectural boundaries. Skip it for a local edit whose structure is already fixed by adjacent code.
2. Read [runtime and delivery decisions](references/runtime.md) when the change affects errors, resources, concurrency, asynchronous work, caching, dependencies, compatibility, or release behavior.
3. Use `debug` to establish a reproducible cause before implementation when the failure mechanism is unknown. Use `tests` for substantial test selection, fixtures, assertions, flakiness, or test repair.
4. Apply `api`, `database`, `frontend`, `accessibility`, `security`, `performance`, `devops`, `observe`, or `docs` only when the changed boundary belongs to that domain. Do not restate their rules here.

## Prove the change

1. Map each requested behavior and material failure mode to observable evidence. Add or update tests only where existing evidence does not already cover the changed risk.
2. Use the repository's established compiler, formatter, static analysis, type checker, test, build, and packaging gates. Add race, sanitizer, security, migration, browser, or benchmark checks only when the changed risk and existing project tooling justify them.
3. Review the final code for accidental surface expansion, impossible or hidden state, duplicated knowledge, leaked resources or secrets, swallowed errors, unbounded work, stale cache behavior, unsupported APIs, and compatibility regressions.
