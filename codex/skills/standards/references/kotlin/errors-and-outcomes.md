# Errors and outcomes

Kotlin exceptions are unchecked, so function names, KDoc, and result types must communicate meaningful failure behavior.
Catch the narrowest exception that you can recover from and preserve the original cause when translating it.
Do not catch an exception only to log and rethrow without adding context or changing ownership.
Use `require` for caller input, `check` for an object's current state, and a domain exception for a meaningful exceptional boundary.
Use `Result<T>` when success or failure is a value that the immediate caller must compose or inspect.
Remember that `Result` stores an arbitrary `Throwable`; it does not replace a domain-specific error model when error categories matter.
Use `runCatching` only around the operation whose failures belong in the returned `Result`.
In coroutine code, do not swallow `CancellationException` inside broad catches or `runCatching`; rethrow it or call `ensureActive` before handling other failures.
Map infrastructure exceptions to stable application errors at a boundary, and avoid exposing vendor exception classes from domain APIs.
Include useful, non-sensitive context in error messages and never log credentials, tokens, or personal data.
Use sealed errors for expected finite alternatives such as validation, authorization, or known business conflicts.
Use exceptions for unexpected infrastructure failures, broken invariants, and failures that should abort the current operation.
Test both the error category and the externally visible behavior, not only the exception message.
