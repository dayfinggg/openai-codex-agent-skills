# Composition and request boundaries

Create the app in one factory and register global middleware in deliberate order.
Use routers to group one cohesive resource or capability under a clear mount path.
Keep route handlers thin and delegate application work to services with explicit dependencies.
Make the pipeline visible as security, request ID, access logging, parsers, authentication, routes, not-found handling, and errors.
Remember that middleware loaded first executes first and a handler that neither responds nor calls `next()` leaves the request hanging. [E1]
Use `app.use()` for cross-cutting middleware and router-level middleware for feature-specific policy. [E1]
Do not mutate request objects with undocumented fields when an explicit context object will do.
Do not let route handlers call database or queue clients through hidden module globals.
Keep route path and HTTP method ownership unambiguous.
