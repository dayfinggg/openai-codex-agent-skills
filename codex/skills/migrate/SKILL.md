---
name: migrate
description: Move code, callers, data, configuration, or dependencies from an old contract to a new one with explicit compatibility and rollback decisions. Use for API, schema, framework, dependency, or storage migrations. Do not use for a simple isolated replacement with no consumers.
---

# Migrate

Follow the governing instructions and the user's requirements for communication, code style, authorization, and delegation. This skill supplies task-specific guidance, not permission to expand the task. Its workflow and output fields describe internal checks and relevant content, not a mandatory response layout or a progress report. When used within broader authorized work, continue that work through completion rather than stopping to deliver this skill's intermediate result.

Converge on the target state without leaving an accidental permanent compatibility layer.

## Inventory

Define the old and target contracts. Find all callers, persisted forms, generated artifacts, deployment dependencies, and external consumers. Classify each as migrated, compatible, blocked, or unknown.

When domain meaning changes, inventory the bounded contexts and owners that use each term. Preserve or deliberately migrate aggregate and transaction boundaries, translation layers, and published event semantics. Use an anticorruption layer when a legacy or external model must coexist without becoming the target domain model.

## Choose the transition

Decide whether the change can be atomic or requires staged coexistence. State the compatibility window, rollback point, data transformation, observability, and deletion condition. Do not preserve the old path when no real compatibility requirement exists.

For a security-sensitive version, credential, or signing-key migration, define the minimum safe version, revoke the retired authority, prove that old access no longer works, and prevent rollback or recovery from reviving a vulnerable artifact or credential. Give every temporary compatibility bypass an owner and deletion deadline or condition.

## Sequence

Order work so every stage is deployable and verifiable. For a staged migration, introduce the new read or write path, validate real traffic or data, move consumers, then remove the old path. Make repeated operations idempotent when retries are possible.

## Verify

Check caller coverage, transformed data, mixed-version behavior, rollback, and absence of stale uses. Use authoritative counts or queries where data is involved.

## Boundaries

Distinguish preparing a migration from executing it against a live system. Use the environment and operations authorized by the user. A request to write or update a migration does not by itself authorize production execution, deletion, or credential revocation. Reuse existing authorization and follow the governing permission rules. Report unknown external consumers rather than assuming none exist.

## Output

Return the target state, inventory, transition sequence, checkpoints, rollback strategy, deletion condition, and evidence.
