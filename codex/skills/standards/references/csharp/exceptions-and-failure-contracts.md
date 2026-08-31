# Exceptions and failure contracts

- Throw the most specific predefined exception that describes a caller error or invalid object state.
- Use `ArgumentNullException.ThrowIfNull` and related guard helpers for public argument validation.
- Validate usage errors synchronously before entering the asynchronous part of a task-returning method.
- Catch an exception only when the code can recover, restore a known state, add useful context, or perform required cleanup.
- Catch specific exception types and order derived catches before base catches.
- Use `throw;` to rethrow without destroying the original stack; wrap with an inner exception when changing abstraction level.
- Avoid catching `Exception` as routine control flow and never silently swallow failures.
- Use a `Try...` or another explicit result contract for expected absence when the API semantics support it.
- Do not use exceptions for ordinary branching or validation that can be performed cheaply before the operation.
- Keep exception messages clear, actionable, and free of secrets; include relevant parameter or operation context.
- Do not throw from `finally`, `Dispose`, `Equals`, `GetHashCode`, or `ToString` except for unavoidable critical failures.
- Define a custom exception only when an existing type cannot express the contract; end its name with `Exception` and provide standard constructors.
