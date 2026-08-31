# Errors and HTTP responses
- Let the controller or a view layer return a `Response`; do not let domain code construct HTTP responses.
- Map known domain or infrastructure failures to deliberate status, headers, and safe error bodies at the HTTP boundary.
- Use `HttpExceptionInterface` for failures that intentionally carry an HTTP status and headers.
- Understand that `kernel.exception` is the HttpKernel boundary for turning an exception into a response.
- Catch only failures the current layer can recover from, and preserve the causal exception when adding context.
- Keep debug error pages and stack traces disabled for production users.
- Log unexpected failures with request, user, tenant, message, or entity context that is safe to retain.
- Configure Messenger failure handling separately from HTTP error rendering.
