# PostgreSQL decisions

**Reviewed:** 2026-08-11
**Scope:** PostgreSQL `current` documentation pointed to version 18 at review time. Use the installed major documentation for a project.

## Correctness and concurrency

- Use `NOT NULL`, `UNIQUE`, `PRIMARY KEY`, `CHECK`, exclusion, and foreign-key constraints according to the invariant. Understand that SQL null semantics affect uniqueness and checks.
- Choose isolation from the anomaly the transaction must prevent. Account for serialization failures and deadlocks with bounded whole-transaction retries only when the operation is safe to repeat.
- Keep a stable lock order and inspect lock behavior for statements that can block writers or readers.

## Indexes and plans

- Match B-tree, hash, GiST, SP-GiST, GIN, BRIN, partial, expression, and multicolumn capabilities to actual operators and data distribution.
- Compare estimated and actual rows, loops, buffers, I/O, sort and memory behavior. `EXPLAIN ANALYZE` executes the statement and can mutate data.
- Use concurrent index operations only after checking their restrictions, failure states, resource cost, and version-specific semantics.

## Official sources

- [Constraints](https://www.postgresql.org/docs/current/ddl-constraints.html)
- [Indexes](https://www.postgresql.org/docs/current/indexes.html)
- [Transaction isolation](https://www.postgresql.org/docs/current/transaction-iso.html)
- [Using EXPLAIN](https://www.postgresql.org/docs/current/using-explain.html)
- [CREATE INDEX](https://www.postgresql.org/docs/current/sql-createindex.html)
