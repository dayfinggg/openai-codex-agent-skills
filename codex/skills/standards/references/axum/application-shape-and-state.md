# Application shape and state

- Keep `main` responsible for configuration, resource construction, router assembly, binding, and shutdown.
- Expose an `app(state)` or `router(state)` constructor so tests can build the service without opening a socket [A8].
- Use `Router::with_state` and `State<T>` for application state; a router with missing state cannot be served until `.with_state` completes [A2].
- Axum clones state for every request, so store pools, clients, and other expensive resources behind cheap cloneable handles [A1] [A2].
- Implement `FromRef` when a handler needs a substate rather than the entire application state [A2].
- Use `Extension` only for deliberately dynamic request data because a missing extension is a runtime 500 response [A2].
- Keep request-local principals and claims in typed extensions or a custom extractor after authentication has succeeded.
