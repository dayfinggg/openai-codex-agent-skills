# Coroutines

Mark a function `suspend` when it may suspend before returning; do not treat `suspend` as a synonym for “runs in parallel.”
Call suspending functions from another suspending function or an intentional bridge such as `runBlocking`.
Use `coroutineScope` for concurrent child work that must complete with the operation and fail it as a unit.
Use `launch` when a `Job` represents completion or cancellation and no value is returned.
Use `async` when a value is needed, and await the `Deferred` in the same structured scope.
Use `runBlocking` at a blocking entry point, adapter, or test, not inside a request path that is already coroutine-aware.
Keep every long-lived scope tied to an application, component, or request lifecycle that can cancel it.
Avoid `GlobalScope`; it has no `Job`, cannot be collectively cancelled, and loses structured-concurrency guarantees.
Do not replace `GlobalScope` with an unowned `CoroutineScope()`; give an owned scope a clear lifetime and cancellation path.
Let child coroutines inherit the caller's context unless the operation has a documented dispatcher requirement.
Use `Dispatchers.Default` for CPU-bound work and a bounded or injected I/O dispatcher for blocking calls.
Keep blocking Java or database calls off an event-loop thread by moving them at the adapter boundary with `withContext`.
Inject dispatchers or a coroutine context when code needs deterministic tests or a non-default execution policy.
Do not put a new unrelated `Job` into a child builder's context because it breaks parent-child cancellation.
Use `SupervisorJob` or `supervisorScope` only when sibling failures are intentionally independent and each failure is observed.
Remember that cancellation is cooperative; suspending calls normally check it, while tight non-suspending loops may need `ensureActive`.
Release resources in `finally` or `use`, and make cleanup cancellation-safe without hiding cancellation from callers.
Use `CoroutineExceptionHandler` for failures with no normal propagation path, not as a replacement for local recovery logic.
