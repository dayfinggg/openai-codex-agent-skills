# Errors and recovery

- Raise a specific exception class that tells callers what went wrong.
- Define application errors under a domain namespace and inherit from `StandardError` unless process-level failure is intended.
- Prefer `raise ErrorClass, "message"` over `raise ErrorClass.new("message")` for ordinary errors.
- Prefer `raise` over `fail` so raising and re-raising use one vocabulary.
- Rescue the narrowest exception class that the code can handle, and keep the rescue scope small.
- Do not rescue `Exception`, because that also catches signals and process-control exceptions.
- Do not leave a rescue body empty. Recover, translate, report, or make an intentional no-op visible through control flow, configuration, or a test; add a source note only when the reason cannot be expressed otherwise.
- Do not use exceptions for expected branching when a predicate or explicit result communicates the case.
- Avoid modifier-form `rescue` when it would hide which expression is protected or which errors are caught.
- Translate dependency-specific errors at an integration boundary and preserve the original cause where the runtime supports it.
- Retry only when the operation is safe to retry, the cause can change, and the number of attempts is bounded.
- Use `ensure` for cleanup, and never return from `ensure` because it can hide an exception.
- Log an error once at the boundary that can act on it; avoid duplicate logs at every layer.
- Test the error class, relevant message context, and recovery behavior instead of only asserting that something failed.
