# Errors and exceptions

- Raise an exception for an exceptional condition that the caller can handle; do not return ambiguous sentinels.
- Choose the narrowest useful built-in exception, such as `ValueError`, `TypeError`, `KeyError`, or `OSError`.
- Define domain exceptions under `Exception` or an appropriate built-in subclass, with an `Error` suffix.
- Catch the narrowest exception that the code can recover from or translate.
- Keep `try` blocks small so unrelated programming errors are not accidentally hidden.
- Never use bare `except:` for ordinary application handling.
- Catch `Exception` only at an intentional boundary that records, translates, or re-raises the failure.
- Preserve the original cause with `raise NewError(...) from err` when translating an exception.
- Use `raise` without an argument when re-raising from an exception handler.
- Use `finally` or a context manager for cleanup regardless of success or failure.
- Do not use `assert` for user input, permissions, data validation, or required application behavior.
- Use `assert` for internal invariants that may safely disappear under optimized execution.
- Give errors enough operation and input context to diagnose them, but never include secrets.
- Log an error once at the boundary that can act on it; do not log and re-raise at every layer.
