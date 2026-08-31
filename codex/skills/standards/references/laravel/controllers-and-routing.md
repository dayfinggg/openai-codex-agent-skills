# Controllers and routing
- Let a controller authenticate, authorize, validate, call one use case, and format the response.
- Keep query composition, multi-write orchestration, and external side effects out of large controller methods.
- Use resource controllers when the endpoint is ordinary CRUD and invokable controllers when one action deserves a name.
- Let Laravel resolve controller dependencies through constructor or action type hints.
- Use route model binding for a straightforward identifier lookup and return the framework's normal not-found response.
- Move scoped, conditional, or multi-record lookups into a named query or repository method.
- Attach cross-cutting behavior through route or controller middleware instead of duplicating checks in actions.
- Return an explicit view, redirect, JSON response, or response object for each branch.
