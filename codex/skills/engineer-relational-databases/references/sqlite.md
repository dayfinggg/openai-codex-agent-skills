# SQLite decisions

**Reviewed:** 2026-08-11
**Scope:** Current SQLite documentation. Confirm the embedded library version and compile options used by the application.

## Correctness and concurrency

- Enable and verify foreign-key enforcement for each connection when the application relies on it.
- Account for dynamic typing, type affinity, strict tables where supported, rowid behavior, and null semantics.
- Choose `DEFERRED`, `IMMEDIATE`, or `EXCLUSIVE` transaction behavior from write contention and failure requirements. SQLite serializes writes even when readers can proceed under the selected journal mode.

## Indexes and plans

- Use the query planner output and representative data to validate index selection, covering behavior, ordering, and automatic indexes.
- Keep transactions bounded and handle busy or locked outcomes with a documented timeout and safe retry policy.
- Test on the same journal, synchronous, filesystem, and connection settings used by the target application.

## Official sources

- [Transactions](https://www.sqlite.org/lang_transaction.html)
- [Query planner](https://www.sqlite.org/queryplanner.html)
- [Foreign key support](https://www.sqlite.org/foreignkeys.html)
- [Strict tables](https://www.sqlite.org/stricttables.html)
- [Write-ahead logging](https://www.sqlite.org/wal.html)
