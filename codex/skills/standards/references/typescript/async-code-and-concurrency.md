# Async code and concurrency

- Annotate exported asynchronous contracts as `Promise<T>` when the result is not obvious. [S10][S18]
- Every promise must be intentionally awaited, returned, caught, or explicitly discarded under a local rule that permits it. Make deliberate discards visible through control flow, a narrow tool configuration, or a test; do not add a prose comment solely to justify one. [S20]
- Enable typed linting for promise misuse when its performance cost is acceptable for the repository. [S14][S15]
- Avoid passing an async callback to a void-only callback API unless a wrapper handles its rejection. [S21]
- Use `for...of` for ordered asynchronous work and `Promise.all` for independent work that must all succeed. [S20][S29]
- Use `Promise.allSettled` when every outcome matters and partial failure is part of the contract. [S29][S30]
- Preserve required sequencing; do not turn dependent operations into concurrent tasks for cosmetic speed.
- Bound concurrency for untrusted or large collections and make backpressure explicit.
- Propagate cancellation with `AbortSignal` when the underlying API supports it.
- Avoid `Array.prototype.forEach` with async callbacks because it does not await them.
- Remove `async` from functions that do not await or intentionally normalize a promise.
- Attach error handling to event emitters and streams according to the runtime API, not only with a surrounding `try` block. [S28]
- Test rejection, timeout, cancellation, retry, ordering, and partial-success behavior.
