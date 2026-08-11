# Prisma schema, client, and query behavior

**Reviewed:** 2026-08-11
**Scope:** Prisma ORM GA behavior. Resolve the installed version and provider before applying any rule.

## Project fit

- Treat the configured Prisma schema and migration history as the source of truth. Discover paths from project configuration rather than assuming `prisma/schema.prisma`.
- Preserve configured generator output and imports. Generated client code is derived output, not a manual edit surface.
- Keep framework lifecycle ownership intact. Long-lived servers commonly reuse a client while short-lived tools and tests need explicit cleanup. Verify the adapter and runtime contract for the installed version.

## Schema and client correctness

- Model nullability, uniqueness, relations, referential actions, mappings, defaults, and native types from the persisted invariant. A Prisma declaration does not replace an engine constraint when the invariant must hold outside Prisma.
- Regenerate after an authorized schema change and compile all affected call sites. Do not assume generated types validate external values at runtime.
- Use safe parameterized APIs for raw SQL. If dynamic identifiers are required, allow-list them because ordinary value binding does not make identifiers safe.

## Query measurement

- Compare emitted query count, selected columns, rows returned, latency, and the database plan on representative data.
- Investigate N+1 when a loop or resolver issues relation reads per parent. Use the supported relation-loading, batching, join, or explicit query shape that preserves results and memory bounds.
- Make cursor and offset pagination ordering stable. Avoid unbounded reads and large nested result graphs.
- Treat Prisma query events and logs as sensitive. Redact parameters and avoid production-wide verbose logging without a bounded purpose.

## Official sources

- [Prisma ORM overview](https://www.prisma.io/docs/orm)
- [Prisma Schema overview](https://www.prisma.io/docs/orm/prisma-schema/overview)
- [Prisma Client setup](https://www.prisma.io/docs/orm/prisma-client/setup-and-configuration/introduction)
- [Query optimization and performance](https://www.prisma.io/docs/orm/prisma-client/queries/advanced/query-optimization-performance)
- [Prisma CLI reference](https://www.prisma.io/docs/orm/reference/prisma-cli-reference)
