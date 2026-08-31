# Null safety

Use a non-null type unless absence is a real state that callers must handle.
Make nullable values enter at a boundary, then validate or map them into a non-null domain type.
Prefer an explicit `if` when the null branch contains meaningful work or logging.
Use `?.` for a short optional chain and `?:` when a clear fallback or early return exists.
Let smart casts narrow a stable value after an explicit null check.
Treat `!!` as an assertion of a locally proven invariant, not as routine null handling.
If `!!` is unavoidable at an adapter boundary, keep it close to the check and make the failure message or test explain the invariant.
Do not use nullable booleans for three states unless all three states are intentional and documented.
Prefer `value == true` or `value == false` when a nullable boolean is unavoidable in a condition.
Use `filterNotNull`, `mapNotNull`, or a domain parser when a collection contains optional input.
Do not confuse a read-only collection type with deep immutability.
Convert Java platform types immediately at the boundary when their nullability is not trusted.
Annotate Java APIs with supported nullability annotations so Kotlin sees actual nullable or non-nullable types.
