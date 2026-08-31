# Asynchronous code

- Use the Task-based Asynchronous Pattern for new asynchronous APIs.
- Return `Task` or `Task<T>` by default; reserve `ValueTask` for measured allocation-sensitive paths with compatible consumers.
- Add `Async` to asynchronous operation names and never append it to a synchronous method.
- `async` enables `await`; it does not by itself move work to another thread.
- Await every task whose completion, exception, or cancellation matters.
- Do not use `.Result`, `.Wait()`, or other blocking waits to bridge asynchronous code without a documented boundary.
- Prefer async all the way through the call chain; keep synchronous wrappers rare and deliberate.
- Use `async void` only for event handlers or framework callbacks that require that signature.
- Keep an async event handler thin and delegate its logic to a testable `Task`-returning method.
- Start independent operations before awaiting them and compose them with `Task.WhenAll` when concurrency is safe.
- Pass a `CancellationToken` for operations that genuinely support cancellation, usually as `cancellationToken`.
- Treat cancellation as cooperative; pass the token down, observe it, clean up, and preserve cancellation semantics.
- Dispose every `CancellationTokenSource` that the code owns.
- Use `ConfigureAwait(false)` in context-free library code when the library does not need a captured context; preserve context where the application requires it.
- Do not drop a task for background work unless an owner tracks its lifetime, observes failures, and coordinates shutdown.
- Await a `ValueTask` once, or convert it once with `AsTask()`; do not cache or await the same `ValueTask` repeatedly.
