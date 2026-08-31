# Avoiding Laravel ceremony
- Start with a route, controller, form request, model or query, action only when needed, and a feature test.
- Prefer a named action over a generic service and a meaningful query over a repository interface with one pass-through method.
- Prefer a direct call over an event for required work and a real queue over a synchronous wrapper that hides latency.
- Do not add a service provider, facade, contract, observer, listener, or job until a real responsibility justifies it.
- Keep simple CRUD close to Laravel conventions and isolate only business rules or integrations that need a seam.
- Remove generated empty classes and dead bindings when the feature no longer uses them.
