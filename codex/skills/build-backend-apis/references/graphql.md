# GraphQL contracts

**Reviewed:** 2026-08-11
**Scope:** Current GraphQL specification and GraphQL over HTTP draft or adopted project contract. Resolve server, client, and schema-tool versions locally.

## Schema and resolver behavior

- Treat field names, arguments, nullability, enum values, directives, errors, and deprecation as public contracts. Prefer compatible additive evolution when supported clients overlap.
- Validate variables and authorization independently of static schema typing. Enforce object and field ownership in resolvers or the trusted data layer.
- Account for null propagation and partial data. Do not hide an unauthorized field as a successful value unless that is the documented contract.
- Bound query depth, breadth, aliases, fragments, list sizes, batching, and execution time using the capabilities of the installed stack.
- Inspect resolver query behavior for N+1 and overfetching. Batch only compatible requests and preserve tenant, authorization, cache-key, and error boundaries.
- Define pagination and ordering explicitly. Stable opaque cursors should bind to the same filter and authorization context.
- Treat introspection and persisted queries as deployment and threat-model decisions, not universal toggles.

## Verification

Validate the schema, compare public schema changes, test resolvers through the real execution engine, include unauthorized and complexity cases, and measure representative resolver and data-source behavior.

## Official sources

- [GraphQL specification](https://spec.graphql.org/)
- [GraphQL over HTTP](https://graphql.github.io/graphql-over-http/draft/)
- [GraphQL Foundation security guidance](https://graphql.org/learn/security/)
