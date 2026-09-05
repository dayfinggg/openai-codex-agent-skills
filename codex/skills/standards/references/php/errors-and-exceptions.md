# Errors and exceptions

- Use exceptions for exceptional failures and return values for ordinary, expected outcomes.
- Throw domain-specific exceptions that preserve the failing operation and relevant safe context.
- Catch the narrowest exception that can be handled at that layer.
- Catch `Throwable` only at an application boundary, a worker loop, or a deliberate logging or recovery boundary.
- Translate infrastructure exceptions into a stable application contract at the boundary.
- Re-throw with the original exception as `previous` when adding context; do not discard the causal chain.
- Do not silently swallow failures. Handle an expected recoverable failure explicitly, or propagate it. Establish deliberate no-op behavior through the contract and a focused check rather than an explanatory source comment.
- Use `finally` for cleanup that must run on success and failure; do not return from `finally`.
- Configure `E_ALL` during development and test; log production failures without exposing stack traces or secrets to users.
- Avoid the error-control operator `@`; it hides unrelated failures and makes diagnosis harder.
- Use a PSR-3 logger when a component needs logging; put an exception in the `exception` context key and keep messages stable.
