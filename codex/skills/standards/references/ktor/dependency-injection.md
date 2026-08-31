# Dependency injection
- Register small-application dependencies through module parameters when that keeps construction visible.
- Use the built-in DI plugin for named implementations, shared lifecycle, async providers, or larger composition roots.
- Register providers once during application setup and resolve them at module setup rather than in every request.
- Use type-based resolution by default and named dependencies only when multiple implementations are intentional.
- Keep resource creation and shutdown in the DI or application lifecycle that owns the resource.
- Override DI providers in `testApplication` before loading modules when a fake is sufficient.
- Keep startup order explicit when one module resolves a dependency provided by another module.
