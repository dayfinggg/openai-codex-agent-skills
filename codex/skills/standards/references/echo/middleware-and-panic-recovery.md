# Middleware and panic recovery

- Echo middleware uses func(next echo.HandlerFunc) echo.HandlerFunc and can run before and after the next handler.
- Keep middleware order explicit across request IDs, limits, authentication, authorization, recovery, logging, and tracing.
- Return errors from handlers and middleware so the centralized error handler owns response formatting.
- Do not write a response and then return an unrelated error that could trigger a second response.
- Echo's Recover middleware should report the panic and pass control to the centralized HTTPErrorHandler.
- The error handler must inspect whether the response is already committed.
- Write a generic 500 only before commit; after commit, log and abort or close according to the protocol.
- Never append an error body after a partial success response.
- Do not expose panic values, stack traces, or internal error messages.
- Avoid duplicate recovery and request logging from Echo and an outer net/http layer.
- Keep proxy-derived client IPs untrusted until the deployment trust chain is configured.
