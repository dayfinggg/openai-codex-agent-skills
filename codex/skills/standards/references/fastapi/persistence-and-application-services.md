# Persistence and application services

- FastAPI does not force a database or ORM; choose the SQL or document toolkit that fits the service. [F5]
- Use the selected ORM or query toolkit directly for ordinary CRUD and query composition.
- Add a repository only for a real persistence boundary, multiple stores, or a testable adapter contract.
- Provide a database session through a dependency with `yield`, and close or roll back it in the cleanup path. [F6]
- Scope a session to the request unless a longer lifetime is explicit and safe.
- Keep transaction orchestration in an application function when a workflow writes several entities.
- Make commits, rollbacks, retries, idempotency, and external side effects explicit.
- Do not publish a message, invalidate a cache, or enqueue work before the transaction that makes it valid commits.
- Keep query helpers near the capability that owns their meaning, and measure query count before optimizing.
