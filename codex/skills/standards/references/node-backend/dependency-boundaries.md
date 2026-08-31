# Dependency boundaries

Use constructor or factory injection so dependencies are explicit, replaceable, and testable.
Prefer stateless singleton clients and immutable configuration.
Use request-scoped objects only when request identity or isolation requires them.
Keep composition in a bootstrap function or root module rather than hiding construction in handlers.
Avoid mutable module-level singletons that hide test state and shutdown ordering.
Keep transport objects out of domain and persistence interfaces.
Give each module one cohesive capability and a narrow public interface.
Do not add a container, registry, or plugin layer without a current problem it solves.
