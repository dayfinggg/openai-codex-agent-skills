# Transactions and isolation

- Put a business operation that must be atomic inside one transaction and commit only after all required statements succeed.
- Roll back on failure and release the connection without leaving it idle in a transaction.
- Keep transactions short; do not hold locks while waiting on network calls, user input, or unrelated work.
- Set isolation deliberately when correctness depends on repeatable reads, predicate consistency, or serial execution.
- Transaction defaults, snapshots, locking, phantoms, and retry errors differ by engine and version; consult the target vendor reference and test the exact behavior.
- Isolation-level names describe minimum phenomena, but implementations can differ in how they achieve those guarantees.
- Use `SERIALIZABLE` for a proven invariant that requires it, and retry serialization failures as a complete transaction.
- Handle deadlocks with bounded retries and consistent lock ordering; never retry a non-idempotent side effect blindly.
- Lock the smallest set of rows that protects the invariant, and document `FOR UPDATE` or engine-specific hints.
- Use savepoints for a deliberate partial rollback, not as a substitute for a clear transaction boundary.
- Know whether the client runs in autocommit mode and make that behavior visible in tests.
- Treat DDL as a separate portability concern because transactional behavior differs across engines.
