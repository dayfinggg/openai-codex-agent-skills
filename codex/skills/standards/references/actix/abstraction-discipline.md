# Abstraction discipline

- Keep application services independent of Actix request and response types, and adapt at the handler boundary.
- Prefer Actix's native extractors, middleware, and `ResponseError` over a second framework-neutral service abstraction.
- Use concrete dependencies and narrow traits for real seams instead of a trait object for every client [M1].
- Avoid deep generic handler wrappers that obscure `FromRequest`, `Responder`, lifetimes, and error types.
- Hide `Arc`, locks, and worker-sharing details behind named services unless ownership is the API's purpose [M1].
- Revisit an abstraction when it makes worker ownership, middleware order, tracing, or shutdown harder to test.
