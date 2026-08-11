# MySQL and MariaDB decisions

**Reviewed:** 2026-08-11
**Scope:** MySQL 8.4 documentation was reviewed. MariaDB and other MySQL-compatible engines require their own installed-version documentation where behavior differs.

## Correctness and concurrency

- Confirm storage engine, SQL mode, character set, collation, generated columns, foreign-key support, and DDL algorithm before relying on behavior.
- Treat InnoDB isolation, consistent reads, locking reads, gap or next-key locks, deadlocks, and autocommit as explicit transaction design inputs.
- Retry a complete idempotent transaction only for documented transient conflicts. Preserve external side-effect semantics.

## Indexes and plans

- Design leftmost prefixes and covering indexes from actual predicates, joins, order, and selectivity. Measure write and storage cost.
- Use `EXPLAIN` and optimizer trace features supported by the installed version. Compare estimates with representative runtime evidence.
- Before online DDL, inspect the supported algorithm, lock level, table rebuild behavior, temporary space, replication effects, and fallback if the requested mode is unavailable.

## Official sources

- [Optimization and indexes](https://dev.mysql.com/doc/refman/8.4/en/optimization-indexes.html)
- [Transaction isolation levels](https://dev.mysql.com/doc/refman/8.4/en/innodb-transaction-isolation-levels.html)
- [EXPLAIN](https://dev.mysql.com/doc/refman/8.4/en/explain.html)
- [Online DDL](https://dev.mysql.com/doc/refman/8.4/en/innodb-online-ddl.html)
- [Backup and recovery](https://dev.mysql.com/doc/refman/8.4/en/backup-and-recovery.html)
