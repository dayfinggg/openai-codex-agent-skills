# Middleware order

- chi middleware uses the standard func(next http.Handler) http.Handler shape.
- Put request ID and trusted proxy extraction before request logging when logs need those fields.
- Put recovery around application handlers and ensure it understands response commit state.
- Write a generic 500 only before commit; after commit, log and abort or close rather than append a second body.
- Put body-size and content-type limits before decoding.
- Put authentication before authorization and attach only a verified principal.
- Add route-group authorization at the group that owns the policy.
- Keep middleware short and explicit; a middleware should have one cross-cutting responsibility.
- Do not hide database access or business decisions in middleware.
- Do not register chi middleware and an equivalent outer middleware twice.
- Review built-in middleware semantics, especially client IP, timeout, logger, recoverer, and path cleanup behavior.
- Treat client IP headers as untrusted unless the deployment has a known proxy trust chain.
- Use a request context derived from r.Context for deadlines and request-scoped metadata.
