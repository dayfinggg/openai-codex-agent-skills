# Async and request concurrency

- Use ASGI for genuinely asynchronous request handling, long-lived I/O, or high in-process concurrency. [D10]
- Use WSGI when the project is otherwise synchronous and has no async workload that benefits from ASGI. [D10]
- Use async ORM methods and `async for` where supported. [D10]
- Wrap synchronous-only code with `sync_to_async()` from an async view rather than calling the synchronous ORM directly. [D10]
- Keep transaction-bearing work in one synchronous function called through an adapter because Django transactions do not yet work in async mode. [D10]
- Disable persistent database connections in async mode and use a backend or pool sized for the target concurrency. [D10]
- Keep third-party middleware and libraries on the same sync or async path where possible to avoid repeated adaptation.
- Do not enable `DJANGO_ALLOW_ASYNC_UNSAFE` in production to silence safety checks. [D10]
