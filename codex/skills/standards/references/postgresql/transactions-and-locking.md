# Transactions and locking

Keep transactions short and contain only the atomic state change that must commit together.
Never hold a transaction open while waiting on a user, network call, queue, or unrelated batch.
Read Committed is the default; each statement gets a snapshot, so successive statements can see different committed data.
In Read Committed, one complex DML statement can encounter concurrent changes while finding and updating rows. Express the check and mutation as one atomic statement, constraint, or protected lock when the invariant spans that gap.
Use Repeatable Read or Serializable only when the invariant requires it and retry the whole transaction on serialization failure.
Retry the entire Serializable transaction from the beginning. Use `SERIALIZABLE READ ONLY DEFERRABLE` for a consistent read-only report when waiting for a safe snapshot is acceptable, and exported snapshots only for coordinated parallel readers that share one point in time.
Use row locks deliberately; they block writers and lockers of the same row but do not block ordinary readers.
Use `SKIP LOCKED` for queue-like work distribution rather than general-purpose consistency. Choose session-level versus transaction-level advisory locks deliberately, and remember that `SELECT FOR UPDATE` can dirty a page and produce a physical write.
Acquire locks on multiple objects in a consistent order to prevent deadlocks.
Treat a deadlock error as a failed transaction and retry the transaction after rollback.
Use `pg_locks` with `pg_stat_activity` to identify blockers, waiters, and long-running transactions.
Use `lock_timeout` to fail fast on DDL or lock acquisition, and use `statement_timeout` to cap execution time.
Set those timeouts per role, session, or migration rather than globally when different workloads need different budgets.
Use `idle_in_transaction_session_timeout` where appropriate because idle transactions retain locks and delay removal of dead tuples.
Do not assume an index or foreign key is lock-free; inspect the command's documented lock level before production use.
Choose function volatility correctly: nested SQL in a `VOLATILE` function can obtain a fresh snapshot, while `STABLE` and `IMMUTABLE` functions use the calling statement's snapshot rules.
