# Testing
- Unit-test domain rules and application services without a Spring context when possible.
- Use `@SpringBootTest` when full context behavior matters and slice tests when only one adapter matters.
- Use MockMvc or an HTTP client to assert status, headers, content type, and `ProblemDetail` shape.
- Test validation, exception mapping, authorization, transaction rollback, timeout, and cancellation behavior.
- Use Testcontainers for real database or service behavior and let Spring manage container lifecycle when contexts are cached.
- Test security rules with authenticated and unauthenticated principals, including method-security denials.
