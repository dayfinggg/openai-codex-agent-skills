# Asynchronous behavior and the event loop

- Mark asynchronous APIs clearly and return the promise they create. An async function's caller must be able to await or handle its result.
- Await dependent operations in sequence. Start independent operations together and await them with `Promise.all`. [J14]
- Pass promises to `Promise.all`, not function values. Remember that it rejects when any member rejects and preserves input order on fulfillment. [J14]
- Bound concurrency for large or externally limited work. The `p-map` implementation is a verified example of a concurrency limit, backpressure, and `AbortSignal` support. [J16]
- Do not use `array.forEach(async () => ...)` when completion matters. Use `for...of` for sequence or `map` plus `Promise.all` for intentional concurrency.
- Do not leave floating promises. A deliberately detached operation needs local rejection handling, lifecycle ownership, and a reason that is visible to reviewers.
- Accept and forward an `AbortSignal` for cancellable I/O, and distinguish an expected abort from an operational failure. [J15]
- Abort controllers communicate cancellation. The underlying API must honor the signal for work to stop. [J15]
- Remove listeners, close streams, and release resources in a `finally` block or an equivalent lifecycle hook.
- Remember that Node `EventEmitter` listeners run synchronously and their return values are ignored. Keep listeners short and handle async failures explicitly. [J18]
- Keep each browser task, callback, and microtask small enough to preserve input and rendering responsiveness. Jake Archibald's event-loop talk explains the task and microtask distinction. [J28]
- Keep Node event-loop callbacks short. Avoid synchronous filesystem, crypto, compression, and child-process calls in server request paths. [J17][J27]
- Bound input before expensive regular expressions, `JSON.parse`, `JSON.stringify`, sorting, or recursive traversal. Large or adversarial input can cause denial of service. [J17]
