# Functions and errors

- Give each function one coherent operation with explicit inputs, outputs, mutation, side effects, and failure behavior.
- Keep pure computation separate from I/O, DOM, process, and persistence bindings when that makes the core reusable and testable. [J2]
- Throw `Error` instances or meaningful subclasses, not strings or ad hoc primitives. [J11][J13]
- Add context while preserving the original failure with `new Error(message, { cause })`. [J12][J13]
- Catch only failures the current layer can recover from, translate, or enrich. Re-throw unexpected failures.
- Do not assume a caught value or `error.cause` is an `Error`; inspect or normalize it before reading properties. [J12]
- Keep error messages actionable but free of secrets, tokens, and untrusted markup.
- Document error categories, retryability, cancellation, and cleanup for exported operations whose behavior is not obvious.
- In Node, attach an `'error'` listener to every `EventEmitter` whose errors are not otherwise consumed. An unhandled event can crash the process. [J13]
- Use `finally` for cleanup that must happen on success, failure, and cancellation.
