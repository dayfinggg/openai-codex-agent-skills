# Dependency injection
- Prefer constructor injection for required dependencies and immutable components.
- Use setter or configuration-method injection only for genuinely optional dependencies.
- Let one constructor express required collaborators and use qualifiers when multiple candidates exist.
- Keep bean wiring in configuration or a composition root rather than constructing infrastructure in domain code.
- Treat circular dependencies as a design signal and refactor ownership before enabling workarounds.
- Use `@ConfigurationProperties` for cohesive settings instead of scattering `@Value` lookups through beans.
- Keep configuration properties focused on environment data and avoid making them service locators.
