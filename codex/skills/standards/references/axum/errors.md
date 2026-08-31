# Errors

- Define an application error type with stable public categories and a retained source error for diagnostics.
- Implement `IntoResponse` for the Axum-facing error type and map validation, authentication, conflict, timeout, and dependency failures deliberately [A5].
- Use generic 5xx response bodies while logging causes, request IDs, route templates, and safe context [S1].
- Remember that an extractor rejection bypasses the handler, so test its status and body as a separate boundary [A3].
- Keep middleware errors infallible at the router boundary by converting them with `HandleError` or `HandleErrorLayer` [A5].
- Do not use panics as control flow; a `CatchPanicLayer` is only a last-resort process boundary and should return a generic 500 [H7].
- Review error mapping as part of the HTTP contract because status and body shape are observable behavior [L1].
