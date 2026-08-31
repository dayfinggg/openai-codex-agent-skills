# Handler boundary

- Implement http.Handler or http.HandlerFunc and return after writing the response.
- Let a handler translate HTTP input and output, but keep business rules in an application service.
- Keep SQL, retries, and external API policy out of handlers.
- Inject services and repositories through constructors so tests can replace them without globals.
- Read all required request data before writing headers or a body.
- Set Content-Type and other headers before the first WriteHeader or Write.
- Call WriteHeader once for non-OK responses and return immediately after an error response.
- Never use ResponseWriter or Request.Body after ServeHTTP returns or from a goroutine that outlives the handler.
- Use http.MaxBytesReader or http.MaxBytesHandler for every endpoint that accepts a body.
- Return 413 Request Entity Too Large when a body or upload exceeds its endpoint limit.
- Stream large bodies rather than buffering unbounded input or output.
- Use http.ServeContent or http.FileServerFS only with controlled filesystem roots and validated names.
- Return a stable error envelope with a public code, safe message, and request identifier.
- Map internal errors to public responses in one transport boundary.
