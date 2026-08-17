---
name: design-web-api
description: Design or change production HTTP and event-facing APIs. Use for endpoints, schemas, errors, pagination, idempotency, authentication, authorization, compatibility, versioning, rate limits, webhooks, and API tests.
---

# Design Web API

## Workflow

1. Identify consumers, use cases, trust boundaries, latency and consistency needs, and compatibility constraints.
2. Define the contract before implementation using the project's schema format. Use stable domain terms and standard HTTP semantics where applicable.
3. Specify validation, status codes, structured errors, pagination, filtering, sorting, concurrency control, idempotency, retry, timeout, and webhook verification as relevant.
4. Authenticate identities and authorize every protected action and object server-side. Bound input and output, rate-limit abuse paths, and avoid leaking sensitive details.
5. Evolve contracts additively when possible. Inventory consumers before removals and provide an explicit deprecation and migration path.
6. Add contract, integration, authorization, failure, compatibility, and retry tests. Document examples that are executable or verified.
7. Add safe observability for latency, failures, saturation, and consumer-visible outcomes.

Do not invent custom protocol behavior when an established standard fits. Do not expose persistence models as accidental public contracts.

Read [API practices](references/practices.md) for standards and security guidance.
