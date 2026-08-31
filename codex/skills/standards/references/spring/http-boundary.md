# HTTP boundary
- Keep `@RestController` methods short enough that mapping and use-case intent are obvious.
- Parse and normalize request data before invoking the application service.
- Return explicit status codes and response DTOs rather than exposing persistence entities as an accidental API.
- Keep transaction policy, SQL, remote calls, and authorization policy out of controller methods.
- Put cross-cutting HTTP behavior in filters, interceptors, argument resolvers, or focused configuration.
