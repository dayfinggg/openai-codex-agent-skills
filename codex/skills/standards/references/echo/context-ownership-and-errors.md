# Context, ownership, and errors

- Extract the standard request context from c.Request and pass it as the first parameter below the Echo boundary.
- Do not store echo.Context or a request context in long-lived structs.
- Use context-aware database and outbound HTTP operations and derive narrower dependency deadlines.
- Do not write ResponseWriter data from a goroutine after the handler returns.
- Give background work an application lifecycle context, owner, stop condition, and shutdown join.
- Map domain errors to one stable public envelope in the centralized error handler.
- Use errors.Is and errors.As after lower layers wrap causes with %w.
- Check Echo's committed-response state before writing an error response.
- Keep transaction ownership in the service or repository layer rather than in an Echo handler.
