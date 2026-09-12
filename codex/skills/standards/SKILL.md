---
name: standards
description: Apply the installed language, framework, or database conventions to changed code when a stack-specific decision arises during implementation or review. Skip audits of unchanged code.
---

# Standards

## Precedence

Apply standards in this order:

1. Governing system and developer instructions, followed by the user's explicit requirements.
2. Applicable repository instructions that do not conflict with those requirements.
3. Checked-in formatter, linter, compiler, analyzer, test, and build configuration.
4. Existing local conventions that are consistent and intentional.
5. Current official guidance for the installed language, framework, and database versions.
6. The references in this skill.

References are conditional guidance, not authority to restyle a repository, change policy, upgrade dependencies, publish, or alter live systems.

## Load focused guidance

Inspect affected files and manifests to identify the installed stack and runtime. Select the relevant indexes below, then read only topic files needed for the decision. Use each directory's `sources.md` to resolve citation labels or verify uncertain claims against official documentation for the installed version. Bundled notes do not prove feature availability. Do not traverse the entire reference tree.

Use `references/principles/index.md` for abstraction, duplication, cohesion, coupling, sizing, or refactoring decisions. Use `references/testing/index.md` for test design, doubles, boundaries, or reliability. Use `references/ux/index.md` for interaction design, research, prototypes, or mobile usability. None is mandatory for unrelated changes.

### Languages

- TypeScript: `references/typescript/index.md`
- JavaScript source files, including mixed TypeScript packages: `references/javascript/index.md`
- Python: `references/python/index.md`
- Go: `references/go/index.md`
- Rust: `references/rust/index.md`
- Java: `references/java/index.md`
- C#: `references/csharp/index.md`
- PHP: `references/php/index.md`
- Ruby: `references/ruby/index.md`
- Kotlin: `references/kotlin/index.md`

### Web frameworks

- Framework-independent HTML, CSS, forms, accessibility, or responsive UI: `references/web-ui/index.md`
- React: `references/react/index.md`
- Next.js: `references/nextjs/index.md`
- Vue: `references/vue/index.md`
- Nuxt: `references/nuxt/index.md`
- Angular: `references/angular/index.md`
- Node.js backend code: `references/node-backend/index.md`
- Express: `references/express/index.md`
- Fastify: `references/fastify/index.md`
- NestJS: `references/nestjs/index.md`
- Django: `references/django/index.md`
- FastAPI: `references/fastapi/index.md`
- Flask: `references/flask/index.md`
- Spring Boot: `references/spring/index.md`
- Ktor: `references/ktor/index.md`
- ASP.NET Core: `references/dotnet-web/index.md`
- Laravel: `references/laravel/index.md`
- Symfony: `references/symfony/index.md`
- Rails: `references/rails/index.md`
- Go `net/http` services: `references/go-http/index.md`
- chi: `references/go-http/index.md` and `references/chi/index.md`
- Gin: `references/go-http/index.md` and `references/gin/index.md`
- Echo: `references/go-http/index.md` and `references/echo/index.md`
- Axum: `references/axum/index.md`
- Actix Web: `references/actix/index.md`

### Databases

- Relational modeling and portable SQL: `references/sql/index.md`
- PostgreSQL: `references/postgresql/index.md`
- MySQL: `references/mysql/index.md`
- SQLite: `references/sqlite/index.md`
- MongoDB: `references/mongodb/index.md`
- Redis: `references/redis/index.md`

### Cross-cutting concerns

- Framework-independent application security: `references/security/index.md`
- Algorithms, data structures, and complexity: `references/algorithms/index.md`
- Git state, integration, history, and publication safety: `references/git/index.md`

For cross-stack changes, combine only references owning affected boundaries. Domain-driven design patterns require actual domain complexity. Simple CRUD does not justify repositories, services, aggregates, event buses, plugin frameworks, or extra layers by itself.

## Work within scope

Apply standards to new and materially changed code within scope. Preserve generated and vendor files unless their owning workflow requires changes. Documentation advice in the references applies only when documentation is explicitly requested, and the governing rules on comments and documentation override any reference. When guidance exceeds scope, keep the local change compatible and disclose material limits.
