# Async and concurrency

- Use `asyncio` for concurrent I/O-bound work, not as a default replacement for synchronous code.
- Keep an async call chain async; do not block the event loop with synchronous network, disk, or CPU work.
- Use `asyncio.run()` once as the normal top-level entry point, or use `Runner` for one shared loop.
- Await every coroutine and retain every background task until its outcome is handled.
- On Python 3.11 and later, prefer `asyncio.TaskGroup` for related tasks because it waits for tasks and propagates failures together. On older supported versions, use a project-approved structured-concurrency library or explicitly own, await, cancel, and collect every task.
- Do not create fire-and-forget tasks without an owner, a strong reference, cancellation, and error handling.
- On Python 3.11 and later, use `asyncio.timeout()` around external operations. On older supported versions, use `asyncio.wait_for()` or the repository's established deadline helper.
- In cancellation cleanup, use `try/finally` and normally re-raise `CancelledError` after cleanup.
- Avoid swallowing cancellation because structured concurrency relies on it.
- Bound concurrency with queues or semaphores, and use task groups to own the bounded tasks.
- Use async context managers for async resources and keep their lifetime within the owning task.
