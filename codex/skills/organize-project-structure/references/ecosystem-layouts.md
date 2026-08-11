# Ecosystem Grammars and Example Trees

Use only the section for the detected stack. These trees are examples, not templates. Preserve the owning package's coherent precedent and all mechanically significant paths.

## Contents

- [TypeScript and NestJS](#typescript-and-nestjs)
- [React and Next.js](#react-and-nextjs)
- [Python and FastAPI](#python-and-fastapi)
- [Polyglot monorepo](#polyglot-monorepo)
- [Artifact placement checks](#artifact-placement-checks)

## TypeScript and NestJS

Use the grammar `<feature-or-concept>[.<qualifier>].<role>[.<test-kind>].ts` when the owning Nest package follows role suffixes.

| Suffix | Actual responsibility | Common misuse |
| --- | --- | --- |
| `.controller.ts` | Transport adapter that accepts protocol input and delegates | Business or persistence logic in the controller |
| `.service.ts` | Injectable provider with a cohesive application or domain-facing responsibility | A miscellaneous helper collection |
| `.repository.ts` | Persistence port or adapter with owned queries and a contract | Empty wrapping of an ORM repository |
| `.module.ts` | Nest composition boundary declared with `@Module()` | Any TypeScript or ES module |
| `.schema.ts` | Named runtime, validation, or persistence schema | A vague replacement for DTO, entity, and migration |
| `.dto.ts` | Request, response, command, or event boundary shape | Domain entity or ORM persistence model |
| `.entity.ts` | ORM entity when the selected ORM and package use it | A second persistence representation without a reason |
| `.spec.ts` | Test discovered by the Nest package's configured runner | Automatic replacement of a package's `.test.ts` convention |

Choose singular or plural bases from the feature and neighboring class names. A feature may use `users.service.ts`, while a persistence representation uses `user.entity.ts`. Do not normalize this globally.

```text
api/
├── package.json
├── nest-cli.json
├── tsconfig.json
├── src/
│   ├── main.ts
│   ├── app.module.ts
│   └── modules/
│       ├── auth/
│       │   ├── auth.module.ts
│       │   ├── auth.controller.ts
│       │   ├── auth.service.ts
│       │   └── dto/
│       │       └── sign-in.dto.ts
│       └── users/
│           ├── users.module.ts
│           ├── users.controller.ts
│           ├── users.service.ts
│           ├── users.repository.ts
│           ├── users.service.spec.ts
│           ├── dto/
│           │   ├── create-user.dto.ts
│           │   └── update-user.dto.ts
│           └── schemas/
│               └── user.schema.ts
└── test/
    └── app.e2e-spec.ts
```

Keep internal imports direct, such as `./users.service`. An outer package entry point may export the supported feature surface. A custom repository belongs only where it owns a persistence contract, query set, or adapter responsibility.

## React and Next.js

React component identifiers start with a capital letter, but React does not impose one filename casing. Preserve the package's `UserCard.tsx`, `user-card.tsx`, or other coherent precedent.

Next.js App Router filenames such as `page.tsx`, `layout.tsx`, `loading.tsx`, `error.tsx`, `not-found.tsx`, and `route.ts` are framework contracts. Preserve route segment syntax, route groups, and private folders. Do not rename these files to role-suffixed alternatives.

```text
web/
├── package.json
├── next.config.ts
├── tsconfig.json
├── public/
└── src/
    ├── app/
    │   ├── layout.tsx
    │   ├── page.tsx
    │   ├── api/
    │   │   └── health/
    │   │       └── route.ts
    │   └── (app)/
    │       └── users/
    │           ├── page.tsx
    │           ├── loading.tsx
    │           ├── error.tsx
    │           ├── _components/
    │           │   ├── UserList.tsx
    │           │   └── UserList.test.tsx
    │           ├── _lib/
    │           │   └── get-users.ts
    │           └── [id]/
    │               └── page.tsx
    ├── features/
    │   └── auth/
    │       ├── components/
    │       │   └── LoginForm.tsx
    │       └── server/
    │           └── session.ts
    ├── components/
    │   └── ui/
    │       └── Button.tsx
    └── lib/
        └── env.ts
```

Colocate route-specific code when the repository uses that strategy. Promote components or server utilities to global folders only when several current consumers and a stable contract justify the move. Names such as `lib`, `components`, and `features` have no framework semantics by themselves.

## Python and FastAPI

Use importable lowercase `snake_case` modules and packages. Do not create Nest-shaped names such as `user.service.py`. Both layer-first and feature-first layouts are valid:

- Layer-first: `routers/users.py`, `services/users.py`, `repositories/users.py`, `schemas/users.py`
- Feature-first: `users/router.py`, `users/service.py`, `users/repository.py`, `users/schemas.py`

Choose `schemas.py`, `models.py`, `dto.py`, or more specific names by actual contents and local precedent. Keep Pydantic boundary models, ORM models, and domain objects distinct when they have different responsibilities. Use a `src/` layout only when packaging and import behavior justify it.

```text
backend/
├── pyproject.toml
├── alembic.ini
├── src/
│   └── acme_api/
│       ├── __init__.py
│       ├── main.py
│       ├── config.py
│       ├── db/
│       │   ├── __init__.py
│       │   └── session.py
│       ├── migrations/
│       │   ├── env.py
│       │   └── versions/
│       ├── auth/
│       │   ├── __init__.py
│       │   ├── router.py
│       │   ├── service.py
│       │   └── schemas.py
│       └── users/
│           ├── __init__.py
│           ├── router.py
│           ├── service.py
│           ├── repository.py
│           ├── models.py
│           └── schemas.py
└── tests/
    ├── auth/
    │   └── test_router.py
    └── users/
        ├── test_repository.py
        └── test_service.py
```

A small application may be clearer as `app/routers/users.py` and `app/models.py`. Do not add a repository, feature package, or `src/` layer only to match the larger example.

## Polyglot monorepo

Make each deployable and package root visible. Each language keeps its manifest, toolchain, tests, build, and owned migrations. Root configuration coordinates only policy or commands genuinely shared across the repository.

Keep cross-language contract sources separate from consumer-local generated clients. Export a generated client only through the owning consumer package's deliberate public entry point.

```text
platform/
├── README.md
├── .editorconfig
├── package.json
├── package-lock.json
├── apps/
│   └── web/
│       ├── package.json
│       ├── next.config.ts
│       └── src/
├── services/
│   ├── identity-api/
│   │   ├── pyproject.toml
│   │   ├── src/
│   │   ├── tests/
│   │   └── migrations/
│   └── notifications-worker/
│       ├── go.mod
│       ├── cmd/
│       └── internal/
├── packages/
│   ├── design-system/
│   │   ├── package.json
│   │   └── src/
│   │       └── index.ts
│   └── identity-client-ts/
│       ├── package.json
│       └── src/
│           ├── index.ts
│           └── generated/
├── contracts/
│   ├── openapi/
│   │   └── identity.yaml
│   └── events/
│       └── user-created.schema.json
├── infra/
│   ├── compose/
│   └── terraform/
└── tools/
    └── codegen/
```

A root Node workspace manifest does not define Python, Go, Java, or .NET layout. Do not create a repository-wide `src/`, `services/`, or `packages/` rule unless the actual deployables and ownership model support it.

## Artifact placement checks

| Artifact | Owner and placement | Do not do |
| --- | --- | --- |
| Public entry point | Package or feature with supported external consumers | Treat every `index.ts` as public API |
| Barrel | Intentional boundary with explicit exports | Add one to every directory or use it for same-folder Nest internals |
| Unit or component test | Production counterpart when runner and precedent support colocation | Mix `.spec` and `.test` without configured reason |
| Integration or end-to-end test | Environment or system boundary it exercises | Hide environment setup among unit tests |
| Migration | Service or package that owns the schema and tool history | Centralize independent databases or rename applied history |
| Tool config | Root only for common policy, otherwise owning package | Rename canonical files or absorb different targets into one config |
| Scaffolded source | Owning feature after generator output | Keep treating editable source as derived output |
| Derived generated output | Tool-defined output beside its source or consumer | Edit by hand or mix manual code into the generated file |
| Generated migration history | Data owner and migration tool directory | Regenerate or rewrite after application as ordinary cleanup |
