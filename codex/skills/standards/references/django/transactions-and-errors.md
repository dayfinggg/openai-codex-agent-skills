# Transactions and errors

- Wrap the smallest multi-write use case in `transaction.atomic()`. [D8]
- Catch database exceptions around an inner atomic block rather than inside the block so Django can roll back correctly. [D8]
- Use `transaction.on_commit()` for jobs, notifications, cache invalidation, or messages that must follow a successful commit. [D8]
- Keep transaction orchestration in an application function when it spans several models; keep simple model writes direct.
- Map expected not-found, permission, validation, and conflict conditions to stable HTTP responses.
- Keep unexpected exceptions as server failures, log them once at the boundary that can act, and do not expose tracebacks or SQL.
- Test both the response contract and the database state after expected failures.
