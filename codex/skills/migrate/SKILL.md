---
name: migrate
description: Migrate APIs, schemas, frameworks, dependencies, or storage while preserving required compatibility. Skip isolated replacements without affected consumers.
---

# Migrate

Converge on the target state without leaving an accidental permanent compatibility layer.

## Inventory

Define the old and target contracts. Find all callers, persisted forms, generated artifacts, deployment dependencies, and external consumers. Classify each as migrated, compatible, blocked, or unknown.

When domain meaning changes, inventory the bounded contexts and owners that use each term. Preserve or deliberately migrate aggregate and transaction boundaries, translation layers, and published event semantics. Use an anticorruption layer when a legacy or external model must coexist without becoming the target domain model.

## Choose the transition

Decide whether the change can be atomic or requires staged coexistence. State the compatibility window, rollback point, data transformation, observability, and deletion condition. Do not preserve the old path when no real compatibility requirement exists.

For security-sensitive versions, credentials, or signing keys, define a security floor, the revocation sequence, and evidence that retired access is rejected after cutover. Plan rollback and recovery without restoring vulnerable artifacts or credentials. Temporary compatibility bypasses need an owner and removal condition. Execute revocation only within authorized live operations.

## Sequence

Keep each stage deployable and verifiable. For coexistence, order compatible readers, writers, data conversion, consumer cutover, and old-path removal according to the actual contract. Verify with representative data or authorized traffic. Make retryable transformations idempotent.

## Verify

Check caller coverage, transformed data, mixed-version behavior, rollback, and absence of stale uses. Use authoritative counts or queries where data is involved.

## Boundaries

Distinguish preparing a migration from executing it against a live system. Use the environment and operations authorized by the user. A request to write or update a migration does not by itself authorize production execution, deletion, or credential revocation. Reuse existing authorization and follow the governing permission rules. Report unknown external consumers rather than assuming none exist.

## Output

Return the target state, inventory, transition sequence, checkpoints, rollback strategy, deletion condition, and evidence.
