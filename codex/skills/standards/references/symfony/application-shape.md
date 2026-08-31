# Application shape
- Keep the default Symfony directory structure unless a documented project convention gives a stronger boundary.
- Use PHP namespaces under `App\` to organize application logic instead of creating an internal bundle.
- Keep controllers, console commands, event listeners, message handlers, and forms at the framework edge.
- Put business decisions in named application services, domain objects, or value objects that do not require the kernel.
- Let the service container compose adapters, but keep the application dependency graph visible through type hints.
- Treat Doctrine, Messenger, the event dispatcher, forms, mail, and HTTP clients as explicit infrastructure boundaries.
