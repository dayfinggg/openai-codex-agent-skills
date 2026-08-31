# Exceptions and resources

- Define failure behavior in the method contract, including recoverability and relevant context.
- Use a checked exception for a recoverable condition that callers must explicitly handle and that belongs in the API contract.
- Use an unchecked exception for violated preconditions, invalid state, or programmer errors.
- Create domain-specific exception types when callers need to distinguish recovery paths.
- Throw the most specific meaningful exception and include safe, actionable context.
- Preserve the original cause when translating or adding context.
- Catch only when the code can recover, translate at a boundary, clean up, or add required context.
- Catch narrow exception types; do not use a blanket catch for convenience.
- Do not catch Throwable or Error except at a deliberate process boundary that rethrows or terminates safely.
- Do not ignore a caught exception; document the rare intentional no-op.
- Log an exception once at the boundary that can act on it, rather than logging and rethrowing at every layer.
- Do not use exceptions, null, or magic sentinel values for ordinary branching.
- Use try-with-resources for every AutoCloseable resource.
- Preserve suppressed exceptions when resource cleanup fails.
- Propagate InterruptedException or restore the interrupt status after catching it.
- Keep secrets, tokens, and personal data out of exception messages and logs.
