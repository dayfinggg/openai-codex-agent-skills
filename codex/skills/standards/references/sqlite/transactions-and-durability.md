# Transactions and durability

- `BEGIN` starts an explicit transaction that ends at `COMMIT` or `ROLLBACK`; `SAVEPOINT` provides nesting. [S4]
- `BEGIN DEFERRED` is the default and delays acquiring a lock until the first access. [S4]
- `BEGIN IMMEDIATE` starts a write transaction immediately, while `BEGIN EXCLUSIVE` also blocks readers outside WAL mode. [S4]
- An implicit transaction commits when its last active statement finishes, so reset or finalize prepared statements deterministically. [S4]
- `COMMIT` can return `SQLITE_BUSY` while another connection has a pending read, leaving the transaction active for a later retry. [S4]
- Foreign-key enforcement settings cannot be changed in the middle of a transaction. [S6]
- Choose `PRAGMA synchronous` and journal mode as an explicit durability policy rather than as an unexplained performance tweak. [S5]
- Test power-loss, crash-recovery, disk-full, and interrupted-transaction behavior on the actual storage hardware when durability matters.
