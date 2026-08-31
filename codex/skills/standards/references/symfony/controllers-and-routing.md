# Controllers and routing
- A controller reads `Request`, checks access, invokes one use case, and returns a `Response`.
- Keep controllers to glue code. Move orchestration, persistence policy, and business rules into services or domain objects.
- Extend `AbstractController` for useful edge helpers when that coupling stays at the controller boundary.
- Use route attributes with explicit names and HTTP methods when they keep endpoint metadata local.
- Use action or constructor injection instead of fetching arbitrary services from the container.
- Use an entity value resolver for a simple identifier lookup and a repository method for complex mapping or filtering.
- Use an invokable controller when one endpoint has a distinct action name and lifecycle.
- Keep response serialization and status semantics explicit for JSON APIs.
- Register a controller as a service with `#[Route]`, `#[AsController]`, or the controller service tag when it does not use the default setup.
