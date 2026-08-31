# Validation and errors
- Use Bean Validation with `@Valid` or `@Validated` on request models and method constraints where appropriate.
- Handle both `MethodArgumentNotValidException` and `HandlerMethodValidationException` in current Spring MVC.
- Validate business invariants again in the domain or application service because callers are not all HTTP clients.
- Centralize cross-cutting mappings in `@ControllerAdvice` or a focused `ResponseEntityExceptionHandler`.
- Prefer RFC 9457 `ProblemDetail` for REST errors when clients can consume `application/problem+json`.
- Map domain failures deliberately to 400, 401, 403, 404, 409, 422, or 5xx semantics.
- Do not expose stack traces, SQL, secrets, internal class names, or tokens in a client error.
