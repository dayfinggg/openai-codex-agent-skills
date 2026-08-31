# Request boundary

Controllers receive requests and send responses; providers perform application work. [Nst4]
Keep controllers thin and pass DTOs or explicit commands to providers.
Use middleware for transport-wide concerns that do not depend on the selected handler.
Use guards for authentication and authorization that need route metadata or execution context. [Nst5]
Use pipes for parsing and validation before the provider runs.
Use filters for consistent exception mapping and safe response bodies.
Make global, controller-scoped, and method-scoped policy visible and intentional.
Do not let domain providers depend on `Request`, `Response`, `ExecutionContext`, or adapter-specific objects.
Avoid `@Res()` and other platform-specific response APIs unless the endpoint truly needs them.
Return one response and return immediately after an explicit response write.
Generate or validate a request identifier and carry it through providers and outbound calls.
