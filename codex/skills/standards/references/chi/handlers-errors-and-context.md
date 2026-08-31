# Handlers, errors, and context

- Keep chi handlers as ordinary http.HandlerFunc values so services and tests do not depend on chi.
- Read and validate path, query, header, and body values before calling the application service.
- Use dedicated DTOs and never bind directly into a business or persistence struct.
- Use one error mapping function at the HTTP boundary and return after it writes.
- Wrap lower-layer errors with %w and classify them with errors.Is or errors.As.
- Pass context.Context as the first argument to services, repositories, and clients.
- Use context values only for request-scoped metadata and package-owned typed keys.
- Do not store chi.Context or a request context in a long-lived struct.
- Do not write a response from a goroutine after the handler returns.
- Keep background work on an application lifecycle context or a durable queue.
