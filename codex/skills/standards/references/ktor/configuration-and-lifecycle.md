# Configuration and lifecycle
- Use `application.conf` or `application.yaml` for modules, deployment settings, and custom configuration groups.
- Substitute environment variables for secrets and deployment-specific values.
- Use `property()` for required values and `propertyOrNull()` only when absence is valid.
- Use typed configuration mapping such as `getAs<T>()` for cohesive application settings.
- Keep module names and startup order in configuration when using `EngineMain`.
- Fail fast on missing endpoints, invalid durations, unsafe limits, and incompatible feature flags.
- Subscribe to application lifecycle events to release resources and record startup or shutdown state.
