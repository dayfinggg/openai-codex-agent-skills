# Concurrency and transactions

- InnoDB combines MVCC with two-phase locking and normally locks rows rather than whole tables. [M4]
- Ordinary `SELECT` statements use nonlocking consistent reads by default. [M4]
- A consistent read sees a snapshot of committed changes and excludes later or uncommitted changes. [M5]
- `REPEATABLE READ` is the default InnoDB isolation level, so one transaction reuses the snapshot from its first consistent read. [M5]
- `READ COMMITTED` creates a fresh consistent snapshot for each read in the transaction. [M5]
- Use locking reads such as `FOR UPDATE` or `FOR SHARE` only when the unit of work needs lock coordination. [M4]
- Start, commit, and roll back work with `START TRANSACTION`, `COMMIT`, and `ROLLBACK`, or use equivalent client API methods. [M6]
- `autocommit` is a session setting, so configure it explicitly for pooled connections and reset it before reuse. [M6]
- Group related writes into one transaction instead of committing every row. [M6]
- Keep transactions short and avoid network calls, user interaction, or unbounded loops while locks are held.
- Acquire locks in a consistent order across code paths to reduce deadlock probability.
- InnoDB can detect a deadlock, roll back one transaction, and return error `1213`; retry the entire transaction, not only its last statement. [M18]
- The official MySQL InnoDB locking walkthrough includes a video that visualizes lock waits and deadlock cycles. [M19]
- Use `START TRANSACTION READ ONLY` when the application can declare a read-only unit of work. [M6]
- Break huge data changes into bounded batches because rolling back a huge transaction can take several times as long as the original change. [M6]
- Do not assume a DDL statement and DML changes share one rollback boundary across every engine or statement. [M6]
