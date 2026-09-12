# Dependency injection and design

- Prefer constructor injection for required collaborators. Use types and readonly properties only when the supported runtime and mutation/hydration contracts allow them. Older runtimes can use ordinary private properties initialized in the constructor.
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
- Keep module boundaries around business capabilities with explicit public entry points and owned data. Cross-module calls should use these contracts rather than reaching into another module's tables or internal services.
- Start with the existing application structure. Add ports/adapters where they isolate actual infrastructure, not an interface for every class. A modular monolith does not require separate Composer packages or services.
- Use value objects to enforce meaningful invariants. Introduce aggregates, domain events, CQRS, or an outbox only when current consistency or delivery requirements justify them. Simple CRUD can use direct framework services.
- Keep dependency direction clear and avoid cycles. A small composition root may wire concrete services directly; adding a container is not required for dependency injection.
- Traits share implementation, not module ownership or runtime contracts. Avoid traits that depend on undeclared properties, container access, or hidden lifecycle ordering.
- Preserve framework extension points, public subclassing, and plugin hooks in maintenance work. Architectural improvement is not permission to remove those contracts.
