# Transactions

- Wrap multiple writes in a transaction when they must commit or roll back as one unit.
- Prefer `save!` and `update!` inside a transaction so an unexpected failure cannot be silently ignored.
- Keep transaction blocks short and avoid network calls, sleeps, rendering, and user interaction inside them.
- Use `after_commit` or an outbox-like design to publish work after the database state is durable.
- Do not rescue `ActiveRecord::StatementInvalid` inside a transaction and continue issuing queries.
- Restart the whole transaction after a database-level failure, especially on PostgreSQL.
- Know that nested `transaction` blocks join the parent by default.
- Use `requires_new: true` only when a savepoint boundary is actually required and the adapter supports it.
- Test both commit and rollback paths, including object state after rollback.
- Remember that transactions do not restore in-memory Ruby objects automatically.
- Treat cross-database workflows as distributed operations that need explicit consistency and retry decisions.
- Use the current transaction callback APIs only when their commit or rollback timing is part of the design.
