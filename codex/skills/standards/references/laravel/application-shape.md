# Application shape
- Keep routes, middleware, controllers, commands, jobs, and listeners as transport adapters.
- Put business decisions in named actions, domain objects, or application services that can be called from more than one entrypoint.
- Use Laravel's conventional directories until feature grouping makes ownership clearer.
- Use the service container only where dependency construction or substitution needs it.
- Prefer a concrete class when no substitution seam exists, and do not create empty interfaces or service wrappers.
- Treat Eloquent, queues, mail, notifications, and HTTP clients as infrastructure boundaries.
