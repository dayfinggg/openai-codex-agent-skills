# Callbacks

- Use callbacks for short, local lifecycle behavior whose ordering is obvious from the model.
- Keep normalization and record-local invariant maintenance close to the record when a callback improves correctness.
- Treat callbacks as implicit control flow that every save, destroy, import, and test fixture may trigger.
- Avoid hiding email, network calls, billing, or long workflows in `before_save`, `after_save`, or `after_destroy`.
- Use `after_commit` for work that must observe committed data, such as cache invalidation or external notifications.
- Make `after_commit` work idempotent because it runs after persistence and cannot roll the transaction back.
- Remember that an exception in `after_commit` does not undo the already committed database change.
- Use `after_rollback` only for rollback-specific cleanup and test its behavior in nested transactions.
- Use `throw :abort` or the documented callback result when deliberately cancelling a lifecycle operation.
- Place `before_destroy` before `dependent: :destroy` associations when its ordering matters.
- Document callbacks that are required for correctness and test the public operation that triggers them.
- Review bulk and direct SQL calls because they may bypass the callbacks that protect ordinary writes.
