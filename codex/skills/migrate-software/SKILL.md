---
name: migrate-software
description: Plan or execute compatible migrations of data, schemas, APIs, dependencies, frameworks, runtimes, and services. Use when old and new states must coexist, consumers must move safely, or rollback and data integrity matter.
---

# Migrate Software

## Workflow

1. Inventory versions, owners, consumers, contracts, data volume and quality, operational limits, and vendor-supported paths.
2. Define target state, compatibility window, invariants, acceptance criteria, checkpoints, and explicit abort conditions.
3. Prefer staged expand, backfill, verify, switch, observe, and contract steps. Make every stage deployable and safe with mixed versions.
4. Design idempotent resumable backfills with rate limits, checkpoints, reconciliation, and auditability.
5. Rehearse on representative data. Measure correctness, latency, errors, saturation, and progress before advancing.
6. Define rollback where reversible and forward repair where it is not. Back up and test restore before destructive or irreversible stages.
7. Remove compatibility code only after consumer and data verification.

Do not perform destructive, irreversible, production, or externally visible migration steps without explicit authorization. Read [migration practices](references/practices.md) before choosing a rollout strategy.
