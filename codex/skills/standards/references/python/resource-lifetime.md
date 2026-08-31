# Resource lifetime

- Make the owner of every file, socket, lock, process, database session, and temporary resource explicit.
- Prefer `with` and `async with` so cleanup runs when the block exits, including on exceptions.
- Use `contextlib` helpers or a custom context manager to centralize acquire and release logic.
- Use `ExitStack` or `AsyncExitStack` when the number of resources is dynamic.
- Close resources promptly; garbage collection is not a reliable resource-lifetime policy.
- Keep resource acquisition near the code that establishes ownership and release in the same abstraction.
- Avoid global mutable clients unless lifecycle and shutdown behavior are explicit.
- Make cleanup idempotent when callers may retry or cancellation may interrupt the operation.
