# Validation and errors
- Install `RequestValidation` for typed request-body checks and define rules close to the request contract.
- Handle `RequestValidationException` through `StatusPages` so invalid bodies have one response shape.
- Install `StatusPages` once at the application boundary for exception and status-code mapping.
- Use typed domain failures and one error renderer so every route has consistent semantics.
- Map domain failures deliberately to 400, 401, 403, 404, 409, 422, or 5xx semantics.
- Keep route handlers free of broad `catch (Throwable)` blocks that hide cancellation or programming defects.
- Do not expose stack traces, SQL, secrets, internal class names, or tokens in a client error.
