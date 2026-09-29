---
name: building-backend
description: Implement or change server routes, HTTP APIs, request validation, background jobs or business logic. Use the reference for the project's actual framework.
---

# Building backend

Check the installed framework version and follow the existing application structure. Read only the reference for the changed surface:
- Laravel or Symfony: [php-frameworks.md](php-frameworks.md).
- Express, Fastify, Hono or NestJS: [node-frameworks.md](node-frameworks.md).
- FastAPI or Django: [python-frameworks.md](python-frameworks.md).
- HTTP contracts: [api-design.md](api-design.md).

The references describe specific framework versions. Confirm APIs against the installed version and official documentation where needed. Do not migrate old code or introduce a new response format merely to match a reference.

Validate external input at the boundary. Keep substantial business rules separate from HTTP handling when that makes ownership and testing clearer. Preserve authorization, transaction boundaries and public error contracts. Log diagnostic context without secrets and return safe client-facing errors.

Move work out of the request when its duration, retry semantics or existing architecture requires a queue, rather than adding infrastructure for every side effect. Use database, security and testing guidance only for the relevant operation.
