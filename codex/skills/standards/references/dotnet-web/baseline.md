# Baseline

- Use `WebApplication.CreateBuilder(args)` and `WebApplication` as the composition root for new apps.
- Keep service registration, configuration binding, middleware order, and endpoint mapping visible in `Program.cs` or in clearly named extension methods.
- Treat HTTP as a boundary with explicit routes, verbs, status codes, content types, authentication, and authorization requirements.
- Define and review the public contract before optimizing implementation details.
- Generate an OpenAPI document with `Microsoft.AspNetCore.OpenApi` and keep interactive documentation restricted to development or authorized users.
- Prefer framework capabilities over a new package or custom pipeline component when they meet the requirement.
