---
name: standards
description: Apply language, framework, database, HTML, CSS, accessibility, and responsive UI quality standards when writing, editing, refactoring, reviewing, or organizing source code, tests, schemas, migrations, queries, and web interfaces. Detect the active stack and load only its references. Do not use for prose-only or non-code configuration tasks.
---

# Standards

Improve code clarity, correctness, maintainability, and scalability without expanding the requested scope or adding speculative architecture.

## Precedence

Apply standards in this order:

1. User requirements and repository instructions.
2. Checked-in formatter, linter, compiler, analyzer, test, and build configuration.
3. Existing local conventions that are consistent and intentional.
4. Current official language, framework, and database guidance.
5. The references in this skill.

Do not restyle a repository to match a personal preference. When local practice conflicts with correctness, security, or an explicit official requirement, surface the conflict and make the smallest justified correction.

## Load focused guidance

Inspect the files and project manifests before choosing references. Load `references/principles.md` only when deciding abstractions, duplication, file boundaries, or structural tradeoffs. Then load only the language, framework, and database files needed for the current task.

### Languages

- TypeScript: `references/typescript.md`
- JavaScript source files, including mixed TypeScript packages: `references/javascript.md`
- Python: `references/python.md`
- Go: `references/go.md`
- Rust: `references/rust.md`
- Java: `references/java.md`
- C#: `references/csharp.md`
- PHP: `references/php.md`
- Ruby: `references/ruby.md`
- Kotlin: `references/kotlin.md`

### Web frameworks

- Framework-independent HTML, CSS, forms, accessibility, or responsive UI: `references/web-ui.md`
- React: `references/react.md`
- Next.js: `references/nextjs.md`
- Vue: `references/vue.md`
- Nuxt: `references/nuxt.md`
- Angular: `references/angular.md`
- Node.js backend code: `references/node-backend.md`
- Express: `references/express.md`
- Fastify: `references/fastify.md`
- NestJS: `references/nestjs.md`
- Django: `references/django.md`
- FastAPI: `references/fastapi.md`
- Flask: `references/flask.md`
- Spring Boot: `references/spring.md`
- Ktor: `references/ktor.md`
- ASP.NET Core: `references/dotnet-web.md`
- Laravel: `references/laravel.md`
- Symfony: `references/symfony.md`
- Rails: `references/rails.md`
- Go `net/http` services: `references/go-http.md`
- chi: `references/go-http.md` and `references/chi.md`
- Gin: `references/go-http.md` and `references/gin.md`
- Echo: `references/go-http.md` and `references/echo.md`
- Axum: `references/axum.md`
- Actix Web: `references/actix.md`

### Databases

- Relational modeling and portable SQL: `references/sql.md`
- PostgreSQL: `references/postgresql.md`
- MySQL: `references/mysql.md`
- SQLite: `references/sqlite.md`
- MongoDB: `references/mongodb.md`
- Redis: `references/redis.md`

For a cross-stack change, load the minimum combination that owns the affected boundaries. Do not load the entire reference set.

## Apply standards

Use `references/principles.md` as the canonical source for DRY, KISS, YAGNI, cohesion, coupling, abstraction timing, and size decisions. Use the selected stack references for ecosystem-specific rules. Do not restate their guidance from memory or load unrelated references.

## Work within scope

Apply these standards to new and materially changed code. Avoid unrelated cleanup, repository-wide reformatting, dependency replacement, or architectural migration unless the request requires it. Preserve generated files and vendor code unless their owning workflow says otherwise.

When a standard suggests a larger change than the task permits, keep the local change compatible and report the broader improvement separately.

## Verify

Run the repository's formatter, linter, compiler or type checker, focused tests, and relevant broader checks. Use the configured tools rather than manually approximating their output. Inspect the final diff for unnecessary abstraction, duplicated knowledge, hidden behavior, unrelated churn, and violations of the loaded references.
