---
name: mongodb
description: "Design MongoDB schemas, write queries, optimize query performance, or diagnose application client connections. Select the relevant workload and version-matched procedure."
---

Establish the target MongoDB deployment, server and driver versions, authorized database, and requested result. Choose the relevant procedure from verified workload evidence.

Read [host integration](../.shared/host-integration.md) once before following the imported procedures.

| Task | Read |
|---|---|
| Configure or diagnose client pools, lifecycle, and connection failures | [Connections](references/connections/guide.md) |
| Design documents, validation, embedding, or references | [Schema design](references/schema/guide.md) |
| Turn a data question into a query or aggregation | [Query authoring](references/queries/guide.md) |
| Investigate slow queries, indexes, or aggregation performance | [Query optimization](references/optimization/guide.md) |

Load the selected guide and only the reference patterns it calls for. Keep schema design, query meaning, and measured performance distinct even when a task needs several procedures.

Discover the host's actual MongoDB capabilities instead of assuming upstream MCP names are available. An existing authorized driver or CLI can provide equivalent evidence. Preserve the current deployment and do not provision a hosted service solely to follow a sample.

