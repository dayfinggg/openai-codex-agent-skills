# Async, cancellation, and work duration

- Make the entire request call chain asynchronous when it performs I/O.
- Never block on asynchronous work with `.Result`, `.Wait()`, or `GetAwaiter().GetResult()`.
- Do not use `Task.Run` to disguise synchronous I/O or to wrap ordinary request work.
- Never use `async void` for application operations or fire-and-forget work.
- Pass `HttpContext.RequestAborted` to database, HTTP, and other cancellable operations; Minimal APIs can bind it directly as a `CancellationToken`.
- Set explicit request or dependency timeouts for operations whose duration must be bounded.
- Move long-running or durable work to a hosted background service, a durable queue, or an external worker and return a trackable result.
- Stream only when the contract needs streaming, and propagate cancellation through the producer and serializer.
