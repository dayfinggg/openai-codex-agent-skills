# Middleware and ordering

- Register middleware with `App::wrap`, `Scope::wrap`, or `Resource::wrap`, and keep cross-cutting work out of handlers [B3].
- Actix executes middleware in the opposite direction from registration, so `.wrap(first).wrap(second)` makes `second` see the request first [B3].
- The response then traverses the same chain in reverse, so write response cleanup with that nesting in mind.
- Use `middleware::from_fn` for a small local middleware and `Transform` plus `Service` for reusable or configurable middleware [B3].
- Add `Logger` or a tracing middleware at the application boundary, and configure it for every `App` instance [B3].
- Use `ErrorHandlers` when status-based response rewriting is required, and keep its output consistent with the API error contract [B3].
- Put request ID creation and credential redaction where every protected scope observes them.
- Require an ordering test for every critical chain, such as request ID, authentication, body limit, timeout, handler, and response logging.
- Make the test record entry and exit markers and assert the exact sequence rather than trusting nested `.wrap` calls by inspection.
