# Errors and HTTP responses
- Map validation, authentication, authorization, not-found, conflict, and dependency failures to deliberate response contracts.
- Translate domain and infrastructure exceptions to HTTP responses at the HTTP boundary.
- Configure reporting, context, ignoring, and rendering through `withExceptions()` in `bootstrap/app.php`.
- Return a safe, stable JSON error shape and never expose stack traces, SQL, credentials, or internal paths in production.
- Log an unexpected exception once with request, user, tenant, command, or entity context that is safe to retain.
- Retry only failures likely to recover and route permanent job failures to a visible review path.
- Preserve the original exception when adding context, and do not catch an exception merely to return success-shaped data.
