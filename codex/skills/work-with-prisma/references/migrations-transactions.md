# Prisma migrations and transactions

**Reviewed:** 2026-08-11
**Scope:** Prisma ORM and Prisma Migrate. Use the documentation matching the installed major and datasource.

## Transaction decisions

- Use nested writes for dependent related writes represented by the Prisma relation model.
- Use batch or array transaction APIs for independent operations whose ordering contract is understood.
- Use interactive transactions only when application logic must run between database operations. Keep them short and exclude remote calls or user interaction.
- Set isolation only when supported by the installed Prisma and database versions. Handle documented serialization or deadlock conflicts with bounded retries around an idempotent unit.
- Preserve the original error and rollback semantics. A successful callback is not proof that an external side effect outside the database was atomic.

## Migration boundaries

- Keep the complete tool-defined migration history in version control and review generated SQL before use.
- Do not edit, delete, reorder, or rename a migration already applied to a shared environment without a documented reconciliation procedure.
- Use development migration commands only against an authorized development database. Use the supported deploy workflow for reviewed pending migrations in delivery environments.
- Inspect schema drift or migration status through non-destructive commands first. A reset or forced reconciliation is never a diagnostic probe.
- Combine with `migrate-databases-safely` for expand, backfill, cutover, contract, recovery, and production sequencing.

## Official sources

- [Transactions and batch queries](https://www.prisma.io/docs/orm/prisma-client/queries/transactions)
- [Prisma Migrate overview](https://www.prisma.io/docs/orm/prisma-migrate)
- [Development and production migrations](https://www.prisma.io/docs/orm/prisma-migrate/workflows/development-and-production)
- [Migration histories](https://www.prisma.io/docs/orm/prisma-migrate/understanding-prisma-migrate/migration-histories)
- [Prisma Migrate deploy](https://www.prisma.io/docs/orm/reference/prisma-cli-reference#migrate-deploy)
