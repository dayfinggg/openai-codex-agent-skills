# Async and concurrency

- Use `async def` when the libraries in the call chain expose awaitable I/O. [F10]
- Use a normal `def` path operation for blocking I/O because FastAPI runs sync path operations and dependencies in a threadpool. [F10]
- Do not assume a normal `def` utility called from an async function is offloaded; it runs directly and can block the event loop. [F10]
- Prefer async database and HTTP clients for an async path, or move blocking work behind an intentional worker boundary.
- Do not use async merely to wrap CPU-bound code; use a process, worker, or task queue for expensive computation.
- Bound concurrency with connection pools, semaphores, queue limits, request limits, and deadlines.
- Treat cancellation as normal, release resources in `finally` or dependency cleanup, and avoid unowned fire-and-forget tasks.
- Use a durable task queue for work that must survive a request, process restart, or retry.
- Test timeout, cancellation, backpressure, and partial-failure behavior rather than only successful awaits.
