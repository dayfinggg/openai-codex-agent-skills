# Router assembly

- Construct one chi.NewRouter during startup and pass it as the http.Server Handler.
- Register routes near the feature that owns them, then mount feature routers from one composition point.
- Use method-specific helpers such as Get, Post, Put, Patch, and Delete.
- Use Route or Group for a shared prefix and shared policy.
- Use With for a narrow middleware stack on one endpoint.
- Use Mount to attach a separately owned http.Handler without changing its contract.
- Define NotFound and MethodNotAllowed responses with the same public error envelope as normal handlers.
- Keep route patterns explicit and avoid a catch-all route that hides missing registrations.
- Treat URL parameters as untrusted strings and parse or validate them in the transport boundary.
- Use chi.URLParam only at the HTTP edge, then pass typed values to the service.
- Generate route documentation from the router when the API contract needs a route inventory.
- Keep route pattern names stable so request metrics do not use raw, high-cardinality URLs.
