# Dependency injection

- Inject dependencies instead of constructing them in consumers so implementations can be replaced in tests and features can stay decoupled.
- Prefer `inject()` in field initializers, matching the Angular style guide and improving type inference.
- Call `inject()` only in an Angular injection context, such as a component, service, provider factory, guard, or route loader.
- Use `@Service()` for a new root singleton that uses `inject()` and needs no advanced provider configuration.
- Keep `@Injectable({providedIn: 'root'})` for constructor injection, non-root scopes, `useClass` or `useFactory` configuration, and libraries supporting older Angular versions.
- Use `InjectionToken` for configuration values, functions, and other non-class dependencies.
- Remember that Angular resolves an element injector tree before the environment injector tree.
- Provide at the narrowest intentional scope: root for application-wide state, route for feature state, and component for isolated instances.
- A component provider creates an instance for that component and its descendants, not for parents or siblings.
- Avoid hidden singleton state when a route or component lifetime is the real ownership boundary.
