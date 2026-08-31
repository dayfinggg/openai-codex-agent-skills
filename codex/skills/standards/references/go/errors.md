# Errors

Return errors as the final result, check them, handle them, or return them; do not discard them with `_` without a documented reason.[1][2]
Use an additional `bool` or `error` result instead of an in-band sentinel such as `-1`, `nil`, or an empty string when validity needs signaling.[2]
Use `panic` only for unrecoverable programmer or package-internal conditions; normal operation errors belong in the returned `error`.[1][2]
Add useful operation or input context while preserving an underlying error when callers should inspect it.[1][11]
Wrap with `%w` when the underlying identity or type is part of the package contract; use `%v` when you intentionally hide that dependency.[11]
Use `errors.Is` for sentinel or equivalent matching and `errors.As` for extracting a documented error type through wrappers.[11][12]
Define a sentinel only when callers need stable identity, and document which error properties callers may rely on.[11][12]
Implement `Unwrap` on custom errors that contain an underlying error and preserve useful structured fields for callers.[11]
Use `errors.Join` when several independent failures must be returned together, and let callers inspect the resulting error tree.[12]
Test error semantics such as nilness, `Is`, `As`, and documented fields rather than brittle human-readable strings.[18]
Expose significant sentinel values, concrete error types, pointer versus value form, and cleanup obligations through the public API contract when callers need those details. Prefer names, types, and tests over source comments that repeat the signature.[5]
