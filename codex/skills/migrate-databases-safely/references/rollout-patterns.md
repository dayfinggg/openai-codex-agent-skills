# Compatible rollout patterns

**Reviewed:** 2026-08-11
**Scope:** Schema and data transitions for applications that may run old and new versions concurrently.

## Expand, transition, contract

1. Add a compatible representation without removing the old one. Avoid a new required value until every writer can supply it or a safe database default exists.
2. Deploy readers and writers that tolerate both representations. Define one authoritative write path and explicit fallback semantics.
3. Backfill in bounded, idempotent, resumable batches. Use stable ordering, checkpoints, rate limits, retries only for safe units, and metrics for progress, lag, errors, locks, and saturation.
4. Reconcile independently with invariant queries, counts, hashes, sampled records, and application-level checks appropriate to the data.
5. Cut reads or writes over using a controlled release mechanism only when old and new paths are observable and reversible.
6. Remove compatibility code and old data only after the observation window proves no supported consumer depends on it and recovery requirements are met.

## Stop conditions

Stop before or during rollout when schema drift is unexplained, available space is below the reviewed bound, replication lag or lock time exceeds the gate, the backfill cannot resume safely, reconciliation diverges, error or latency budgets are breached, or the target identity is ambiguous.

## Recovery

- Prefer roll-forward when reversal would lose newly written data or the engine cannot safely reverse DDL.
- Use rollback only when the prior application and schema remain compatible and the reversal path was rehearsed.
- A destructive reverse migration is not a rollback plan unless data recovery has been tested.
- Preserve the failed state and evidence needed for diagnosis before cleanup.

## Official sources

- [Prisma expand and contract pattern](https://docs.prisma.io/docs/guides/database/data-migration)
- [Google SRE canarying releases](https://sre.google/workbook/canarying-releases/)
- [Google SRE release engineering](https://sre.google/sre-book/release-engineering/)
- [PostgreSQL backup and restore](https://www.postgresql.org/docs/current/backup.html)
