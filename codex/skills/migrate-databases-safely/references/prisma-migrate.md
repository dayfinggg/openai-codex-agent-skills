# Prisma Migrate deployment

**Reviewed:** 2026-08-11
**Scope:** Prisma Migrate histories and deployment. Resolve the installed Prisma major and datasource first.

## History and environments

- Treat the configured Prisma schema and full migrations directory as the source of truth. Commit the complete history.
- Generate and test migrations in an authorized development environment. Review generated SQL and customize only before application where the installed tool supports it.
- Apply reviewed pending migrations in delivery environments through the supported non-interactive deployment command and immutable repository artifact.
- Do not use development migration, reset, or destructive reconciliation commands in production.
- Investigate drift and failed migrations through non-destructive status and schema comparison first. Do not mark a migration applied or rolled back without proving the actual database state and documenting reconciliation.

## Composition

- Use `work-with-prisma` for schema and client call-site behavior.
- Use `engineer-relational-databases` for physical constraints, indexes, locks, plans, and engine semantics.
- Keep application compatibility, backfill, canary, recovery, and production authorization in this migration workflow.

## Official sources

- [Prisma Migrate overview](https://www.prisma.io/docs/orm/prisma-migrate)
- [Development and production](https://www.prisma.io/docs/orm/prisma-migrate/workflows/development-and-production)
- [Migration histories](https://www.prisma.io/docs/orm/prisma-migrate/understanding-prisma-migrate/migration-histories)
- [Troubleshooting production](https://www.prisma.io/docs/orm/prisma-migrate/workflows/patching-and-hotfixing)
- [Prisma CLI reference](https://www.prisma.io/docs/orm/reference/prisma-cli-reference)
