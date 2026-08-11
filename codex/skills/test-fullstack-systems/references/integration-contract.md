# Integration and contract testing

**Reviewed:** 2026-08-11
**Scope:** Testcontainers for Node.js, Pact concepts, OpenAPI, and project-native integration tools. Resolve installed language, runner, library, protocol, and engine versions first.

## Real boundaries

- Use the real adapter and protocol when correctness depends on serialization, SQL or NoSQL semantics, transactions, filesystem, queue, cache, or network behavior.
- Start isolated dependencies with exact versions and explicit configuration. Wait for meaningful readiness, not only an open port.
- Give each test or worker isolated schema, database, namespace, topic, bucket, keys, or tenant. Clean up through lifecycle hooks even after failure.
- Bound startup, polling, requests, retries, and teardown. Preserve logs for failures without leaking secrets.

## Contracts

- Identify the contract owner and consumers. Test request or message shape, required and optional fields, defaults, nullability, ordering, errors, idempotency, timeout, retry, versioning, and compatibility.
- Use consumer-driven contracts only when provider verification and publication ownership exist. Do not let stale generated examples become the source of truth.
- Validate OpenAPI or schema descriptions and the real implementation. Include invalid, unauthorized, too-large, and partial-failure cases.
- For asynchronous messages, test duplicate, out-of-order, delayed, poison, and partial processing behavior where the delivery contract permits them.

## Migrations

Test old application with expanded schema, new application before and after backfill, migration pause and resume, reconciliation, rollback or roll-forward, and mixed-version overlap relevant to rollout.

## Official sources

- [Testcontainers for Node.js](https://node.testcontainers.org/)
- [Pact documentation](https://docs.pact.io/)
- [OpenAPI Specification 3.2.0](https://spec.openapis.org/oas/v3.2.0.html)
- [Prisma testing guidance](https://www.prisma.io/docs/orm/prisma-client/testing)
