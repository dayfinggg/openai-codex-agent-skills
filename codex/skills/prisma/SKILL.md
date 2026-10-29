---
name: prisma
description: "Set up or diagnose Prisma ORM, write client queries, use CLI commands, or perform an explicitly requested upgrade. Match procedures to the installed ORM version and database."
---

Establish the application's actual ORM, client, and CLI versions, database provider, runtime, and package manager before selecting a procedure. A CLI version alone does not identify the application's generation.

Read [host integration](../.shared/host-integration.md) once before applying these versioned procedures.

| Task and precondition | Read |
|---|---|
| Set up Prisma, repair a connection, or determine the correct version-specific workflow | [Setup and version selection](references/setup/guide.md) |
| Run ORM 7 CLI, generation, schema, or migration commands | [Prisma 7 CLI](references/cli-v7/guide.md) |
| Write ORM 7 client queries, relations, transactions, or raw SQL | [Prisma 7 Client](references/client-v7/guide.md) |
| Perform an explicitly requested ORM 6-to-7 SQL migration | [Upgrade to 7](references/upgrade-v7/guide.md) |
| Evaluate or perform a requested MongoDB upgrade | [MongoDB upgrade](references/upgrade-mongodb/guide.md) |

For Prisma 8, follow setup and version selection to the skill shipped with the installed package. Do not apply ORM 7 examples to another major or substitute a major upgrade for a connection repair.

Upgrade procedures are conditional and require an upgrade in the user's task. Preserve the existing provider, data, schema, and runtime unless the requested work changes them. Loading this skill does not authorize provisioning a new database service.

