---
name: orm-query-review
description: "Review ORM query correctness and performance, including EF Core specifics. Check generated SQL, loading, pagination, transactions, tracking, and concurrent updates."
---

Establish the ORM, driver, database provider, and observable query or mutation contract.

Read [host integration](../.shared/host-integration.md) once when using imported EF Core guidance.

| Task | Read |
|---|---|
| Review general ORM loading, generated SQL, pagination, transactions, or concurrency | [General ORM review](references/general/guide.md) |
| Review or fix Entity Framework Core data access | [EF Core procedure](references/ef-core/guide.md) |

For EF Core, use the general contract as needed and load the provider-specific procedure for tracking, DbContext lifetime, hidden saves, bulk writes, dynamic queries, and physical index evidence. Other ORMs do not need the EF Core procedure.

For Prisma version-specific APIs, use the installed prisma skill. Preserve domain events, audit behavior, access policy, transaction semantics, and the result contract. An optimization must retain correctness and be supported by the appropriate query or workload evidence.

