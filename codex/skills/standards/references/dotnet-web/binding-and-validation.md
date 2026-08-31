# Binding and validation

- Validate at the HTTP boundary, then enforce business invariants again in application or domain code.
- In .NET 10 Minimal APIs, call `builder.Services.AddValidation()` to enable validation for supported parameters and request types.
- Minimal API validation uses DataAnnotations and `IValidatableObject` for query, header, and body values and returns `400 Bad Request` for failures.
- If Minimal API handlers or validatable types live in another assembly, register validation from that assembly so its source-generated metadata is discovered.
- Controllers marked with `[ApiController]` automatically return a validation `400` without a manual `ModelState.IsValid` branch.
- Customize validation failures through `ProblemDetails` rather than leaking internal exception or binding details.
- Disable validation only for a documented endpoint that has a reviewed reason to bypass it.
- Do not confuse syntactic input validation with authorization, ownership checks, or domain invariants.
