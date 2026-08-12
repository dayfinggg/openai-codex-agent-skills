---
name: migrate-codebases
description: Coordinate migrations across runtimes, frameworks, modules, contracts, and storage. Use for staged transitions with compatibility gates and rollback; exclude routine package upgrades, features, and refactors.
---

# Migrate Codebases

Treat a migration as a controlled transition between verified contracts. Keep the system usable at every approved checkpoint unless the user explicitly accepts a bounded outage.

Own migration orchestration: stage ordering, cross-boundary compatibility, integration gates, cutover, and end-to-end rollback. Use specialist skills for their mechanics while retaining responsibility for the combined transition.

## Establish the migration contract

1. Define the current state, target state, migration driver, affected boundaries, success criteria, constraints, and explicit exclusions.
2. Inspect the repository, build and deployment configuration, runtime assumptions, generated artifacts, tests, and operational evidence before choosing a path.
3. Inventory affected dependencies, entry points, callers, consumers, public APIs, serialized formats, configuration keys, persistence access, module boundaries, and external integrations.
4. Record each material contract with its owner, current behavior, target behavior, compatibility requirements, and evidence needed before removal of the old path.
5. Verify exact source and target versions against primary migration guides, release notes, and compatibility documentation. Mark unsupported or unverified assumptions as unknown.
6. Load and use `$manage-dependencies` for dependency stages, including package selection, version compatibility, manifests, lockfiles, advisories, and bounded package changes. Keep their ordering, entry and exit gates, cross-stage compatibility, and end-to-end rollback in this skill.
7. Load and use `$design-databases` for relational or document schema evolution, database backfills, consistency and data validation, and database rollback mechanics. Keep integration ordering, cutover gates, and system-level rollback coordination in this skill.
8. Keep migrations of non-database stored data, including files, object stores, search indexes, and caches, in this skill unless a narrower specialist exists. Define format invariants, compatibility periods, reconciliation or rebuild paths, validation, cutover, and rollback.

## Capture a baseline

1. Run the narrow existing build, static checks, and tests that exercise the affected contracts before editing.
2. Preserve pre-existing failures separately from migration regressions.
3. Add focused characterization or contract tests only where important current behavior lacks coverage.
4. Capture relevant performance, compatibility, or operational baselines when a regression in those properties would invalidate the migration.
5. Confirm that recovery inputs, backups, or reproducible artifacts exist before any authorized irreversible state change.

## Design reversible stages

1. Choose the smallest independently deployable or verifiable slices. Order them by dependency direction and contract compatibility, not by file layout.
2. Prefer an atomic switch only when the affected surface is small, all consumers move together, validation is complete, and rollback is immediate. Otherwise use staged coexistence.
3. Define every stage with prerequisites, exact changes, preserved invariants, validation gates, observable signals, rollback actions, and completion criteria.
4. Introduce an adapter, compatibility mode, feature flag, or translation boundary only when it enables a necessary stage. Give it one owner, one purpose, and an objective removal condition.
5. Keep old and new paths behaviorally comparable while consumers move. Time-box coexistence and avoid ambiguous ownership, unbounded dual operation, and permanent compatibility layers.
6. Separate contract changes from unrelated cleanup. Defer optional redesign until the target path is stable and the obsolete path is removed.

## Execute and validate each stage

1. Make one coherent stage at a time and keep its diff limited to the defined migration boundary.
2. Update producers, consumers, tests, build configuration, and generated sources through their generators as required by that stage.
3. Run focused checks first, then the broader test, build, compatibility, and performance checks justified by the affected surface.
4. Compare old and new behavior using contract tests, recorded fixtures, shadow results, canaries, or production telemetry only when those mechanisms exist and their use is authorized.
5. Stop when a validation gate fails. Diagnose the evidence, revise or roll back the current stage, and do not stack later stages on an unverified checkpoint.
6. Record completed checks and their actual results. Never infer compatibility, successful cutover, or rollback readiness from edits alone.

## Cut over and retire the old path

1. Confirm that all known consumers, configurations, runtime targets, and deployment paths use the target contract before final cutover.
2. Apply the predefined cutover and monitor the signals tied to its success criteria within the authorized environment.
3. Keep rollback available until the agreed stability criteria are satisfied. Test the rollback mechanism when its risk and environment permit.
4. Remove obsolete implementations, adapters, flags, configuration, dependencies, tests that assert retired behavior, and temporary migration tooling once their removal conditions are met.
5. Re-run the full validation set after cleanup and search for remaining references to the retired path.
6. Report the achieved target state, removed compatibility paths, validation evidence, remaining limitations, and whether rollback was tested or only defined.

## Guardrails

- Do not replace an evidence-based migration plan with a big-bang rewrite.
- Do not combine the migration with unrelated features, formatting churn, speculative abstractions, or broad refactoring.
- Do not leave indefinite dual systems, dead flags, obsolete adapters, placeholders, suppressed failures, or unimplemented branches.
- Do not fabricate compatibility guarantees, consumer coverage, measurements, deployment results, or completed checks.
- Obtain direction before changing a public contract without a compatibility path or performing a destructive step whose rollback cannot be verified.
