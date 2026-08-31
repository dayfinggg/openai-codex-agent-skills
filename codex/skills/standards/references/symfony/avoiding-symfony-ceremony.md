# Avoiding Symfony ceremony
- Start with a route, focused controller, validator or form, entity or repository, service only when needed, and a test.
- Prefer a named action over a generic service and a repository query with a real name over a one-method interface.
- Prefer a direct call over an event for required work and a real Messenger transport over a synchronous wrapper that hides latency.
- Do not create a bundle, compiler pass, extension, subscriber, or decorator before a concrete requirement exists.
- Keep simple CRUD close to Symfony conventions and isolate only business rules or integrations that need a seam.
- Remove generated empty services, unused tags, dead routes, and obsolete parameters during maintenance.
- Keep the container graph and event flow clear enough to trace one request to its use case and persistence effects.
