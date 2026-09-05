---
name: standards
description: Apply relevant code, test, database, and interface standards during implementation or review. Detect the installed stack and load only guidance needed for the changed behavior. Do not use for prose-only tasks or unrelated audits.
---

# Standards

Follow the governing instructions and the user's requirements for communication, code style, authorization, and delegation. This skill supplies task-specific guidance, not permission to expand the task. Its workflow and output fields describe internal checks and relevant content, not a mandatory response layout or a progress report. When used within broader authorized work, continue that work through completion rather than stopping to deliver this skill's intermediate result.

Improve code clarity, correctness, maintainability, and scalability without expanding the requested scope or adding speculative architecture.

## Precedence

Apply standards in this order:

1. Governing system and developer instructions, followed by the user's explicit requirements.
2. Applicable repository instructions that do not conflict with those requirements.
3. Checked-in formatter, linter, compiler, analyzer, test, and build configuration.
4. Existing local conventions that are consistent and intentional.
5. Current official guidance for the installed language, framework, and database versions.
6. The references in this skill.

Do not restyle a repository to match a personal preference. Resolve routine differences within the authorized scope. Ask only when an essential requirement cannot be reconciled. Treat references as conditional guidance, not permission to change project policy, upgrade dependencies, publish code, or alter live systems.

## Load focused guidance

Each technology has its own directory under `references/`. Open that directory's `index.md` first, then load only the linked topic files needed for the current decision. Do not load every topic file for a technology by default. Check installed versions and target environments before applying a version-sensitive claim. Verify uncertain or changing behavior in the corresponding official documentation. A bundled reference is not proof that a feature is available in the project.

Inspect the files and project manifests before choosing references. Use `references/principles/index.md` only when deciding abstractions, duplication, file boundaries, refactoring, or structural tradeoffs. Use `references/testing/index.md` when test design, test doubles, suite reliability, or test boundaries materially affect the work. Use `references/ux/index.md` when the task includes interaction design, usability, user research, prototyping, or mobile interaction decisions. Then load only the language, framework, and database indexes needed for the current task.

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

For a cross-stack change, load the minimum combination that owns the affected boundaries. Do not load the entire reference set.

Use DDD patterns only as vocabulary for real, changing domain complexity. Simple CRUD does not require repositories, services, aggregates, an event bus, plugin frameworks, or extra layers merely because those patterns exist.

## Apply standards

Use `references/principles/index.md` as the router for the canonical DRY, KISS, YAGNI, cohesion, coupling, abstraction-timing, and size guidance. Use the selected stack indexes for ecosystem-specific rules. Do not restate their guidance from memory or load unrelated topic files.

## Work within scope

Apply these standards to new and materially changed code. Avoid unrelated cleanup, repository-wide reformatting, dependency replacement, or architectural migration unless the request requires it. Preserve generated files and vendor code unless their owning workflow says otherwise.

Express intent through names, types, structure, and behavior. Follow the user's code-style rules across every reference in this skill. Do not add prose comments, docstrings, TODO or FIXME notes, commented-out code, placeholder implementations, or unsolicited documentation. Preserve mandatory license notices and directives or type annotations required by the toolchain. Do not remove unrelated existing comments. Documentation advice in the references applies only when documentation is explicitly requested.

When a standard suggests a larger change than the task permits, keep the local change compatible. Mention a material limitation when necessary to explain the result. Offer broader improvements only when requested.

## Verify

Use isolated or disposable state for destructive, recovery, or fault-injection checks. Do not write low-value tests for reversible small edits or tests that merely mirror the implementation. Run the configured checks that directly cover the changed code and behavior. Start with the applicable formatter, linter, compiler or type checker, and focused tests. Broaden or repeat checks only when the blast radius, a failure, a new edit, or a repository requirement justifies it. Inspect the final diff for unnecessary abstraction, duplicated knowledge, hidden behavior, unrelated churn, and violations of the loaded references.
