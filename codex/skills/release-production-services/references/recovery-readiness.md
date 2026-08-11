# Recovery readiness

**Reviewed:** 2026-08-11
**Scope:** Backup, restore, rollback, roll-forward, and failover evidence for production changes.

## Data and configuration recovery

- Identify authoritative data and configuration, owner, replication or backup topology, encryption keys, retention, RPO, RTO, and legal constraints.
- Confirm the most recent usable backup or recovery point, chain integrity, restore procedure, compatible engine and application versions, and access to required keys.
- Treat replication as availability, not automatically as protection from logical corruption or deletion.
- Verify restoration in an isolated authorized environment with schema, invariant, application, and timing checks. A successful backup job alone does not prove recovery.

## Rollback and roll-forward

- Rollback requires a compatible prior artifact and configuration plus data that the prior version can read safely.
- Prefer roll-forward when reverting schema or state would lose accepted writes, violate invariants, or take longer than a reviewed corrective change.
- Preserve migration history and failed-state evidence. Do not edit applied migration files or erase partial state to make status look clean.
- For failover, verify target freshness, split-brain prevention, client routing, dependency locality, capacity, and a return or steady-state plan.

## Stop conditions

Do not start a data-risking release when required recovery evidence is stale, missing, inaccessible, or incompatible. Stop active change on failed reconciliation, unexplained lag, backup chain failure, or ambiguous primary ownership.

## Official sources

- [PostgreSQL backup and restore](https://www.postgresql.org/docs/current/backup.html)
- [MySQL backup and recovery](https://dev.mysql.com/doc/refman/8.4/en/backup-and-recovery.html)
- [Google SRE emergency response](https://sre.google/sre-book/emergency-response/)
- [NIST Contingency Planning Guide](https://csrc.nist.gov/pubs/sp/800/34/r1/upd1/final)
