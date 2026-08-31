# Async and background work

- Install Flask's `async` extra before using coroutine routes, handlers, or hooks. [L7]
- Use async only for concurrent I/O that the called libraries support; async does not make CPU-bound work faster. [L7]
- Flask remains WSGI, so each async view still occupies one worker for its request. [L7]
- Do not call blocking database, filesystem, or HTTP code inside an async view unless the worker boundary is intentional.
- Do not spawn unowned background tasks in a view because unfinished tasks are cancelled when the event loop stops. [L7]
- Use a durable task queue for work that must survive request completion, retries, or process restart.
- Use an ASGI server and adapter only with a tested lifecycle, or choose an ASGI-first framework for a mainly async, long-lived, or websocket-heavy service. [L7]
- Test cancellation, timeout, cleanup, and partial-failure behavior for every async path.
