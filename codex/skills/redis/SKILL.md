---
name: redis
description: "Develop or diagnose Redis data structures, commands, connections, clustering, access security, metrics, or search. Load the procedure matching the actual Redis task."
---

Identify the Redis version, client version, deployment topology, and requested outcome. Choose a procedure before changing configuration or data.

Read [host integration](../.shared/host-integration.md) once for the imported resource bundles.

| Task | Read |
|---|---|
| Select data structures, key conventions, TTLs, or atomic operations | [Core behavior](references/core/guide.md) |
| Diagnose clients, pools, multiplexing, pipelining, or timeouts | [Connections](references/connections/guide.md) |
| Work on hash slots, multi-key operations, or replicas | [Clustering](references/clustering/guide.md) |
| Review or change authentication, TLS, ACLs, or network exposure | [Security](references/security/guide.md) |
| Investigate memory, latency, connections, or slow commands | [Diagnostics](references/diagnostics/guide.md) |
| Implement text, aggregation, vector, or hybrid retrieval | [Redis Search](references/search/guide.md) |

Each procedure keeps its complete nested references and client guidance. Read only the branches needed by the task. Redis Search requires the actual supported server and client features.

Use application-cache-change for application-level invalidation and failure semantics. A Redis command change does not itself define the application's cache contract. Preserve unrelated data and existing access policy.

