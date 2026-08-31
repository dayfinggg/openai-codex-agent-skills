# Application and module boundaries

- Use `create_app()` as the composition root once setup is more than trivial, and accept test configuration there. [L1]
- Create extensions without binding them to an app, then call `init_app()` inside the factory. [L1]
- Use one blueprint per business capability or bounded route group, and register blueprints before the first request. [L2] [L4]
- Keep routes, schemas, policies, query helpers, templates, and tests close to the blueprint that owns them.
- Do not import a global app instance into domain modules; use `current_app`, `request`, and `g` only in valid contexts. [L3]
- Keep the entrypoint responsible for configuration, extension initialization, blueprint registration, middleware, and error handlers.
- Avoid database calls, network calls, and mutable request state during module import.
- Do not create controller, service, repository, and mapper folders by habit.
- Add a service or use-case function only when a workflow crosses models, transactions, or external systems.
