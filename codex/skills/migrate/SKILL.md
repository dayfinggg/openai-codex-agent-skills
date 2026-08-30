---
name: migrate
description: Move code, callers, data, configuration, or dependencies from an old contract to a new one with explicit compatibility and rollback decisions. Use for API, schema, framework, dependency, or storage migrations. Do not use for a simple isolated replacement with no consumers.
---

# Migrate

Converge on the target state without leaving an accidental permanent compatibility layer.

## Inventory

Define the old and target contracts. Find all callers, persisted forms, generated artifacts, deployment dependencies, and external consumers. Classify each as migrated, compatible, blocked, or unknown.

## Choose the transition

Decide whether the change can be atomic or requires staged coexistence. State the compatibility window, rollback point, data transformation, observability, and deletion condition. Do not preserve the old path when no real compatibility requirement exists.

## Sequence

Order work so every stage is deployable and verifiable. For a staged migration, introduce the new read or write path, validate real traffic or data, move consumers, then remove the old path. Make repeated operations idempotent when retries are possible.

## Verify

Check caller coverage, transformed data, mixed-version behavior, rollback, and absence of stale uses. Use authoritative counts or queries where data is involved.

## Boundaries

Require confirmation before destructive data operations or external production writes. Report unknown external consumers rather than assuming none exist.

## Output

Return the target state, inventory, transition sequence, checkpoints, rollback strategy, deletion condition, and evidence.
