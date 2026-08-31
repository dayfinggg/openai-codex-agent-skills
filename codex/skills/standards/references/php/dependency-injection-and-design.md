# Dependency injection and design

- Prefer constructor injection with typed parameters and `private readonly` properties for required immutable collaborators.
- Keep an object usable immediately after construction; avoid setter or property injection that creates temporal coupling.
- Depend on an interface when substitution, a port, or an external boundary is part of the design; use a concrete class when no seam is needed.
- Keep the composition root responsible for selecting implementations and wiring object graphs.
- Do not inject a service container into normal domain or application services.
- PSR-11 explicitly discourages using a container inside an object as a service locator.
- If a dependency is selected dynamically, inject a typed factory or a small resolver rather than the whole container.
- Keep domain objects independent of HTTP, database, filesystem, and framework services where practical.
- Keep controllers, commands, and message handlers thin; delegate business rules to application or domain services.
- Separate policy, orchestration, persistence, and presentation responsibilities even when they start in one module.
- Prefer composition over inheritance; make a class `final` when extension is not part of its contract.
