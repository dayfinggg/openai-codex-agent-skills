---
name: designing-http-apis
description: Designs and reviews HTTP JSON APIs with problem details errors and OpenAPI contracts. Use when adding, changing, or reviewing endpoints, routes, controllers, schemas, pagination, or OpenAPI specs.
---

# Designing HTTP APIs

The project's API conventions or style guide win over this skill.

## Shape

- Controllers validate, call one use case, and map the result. Request and response schemas are their own types, apart from entities and database models.
- Paths are plural nouns in lowercase kebab-case, nested at most one level for true ownership, as in `/orders/{orderId}/items`. A rare non-CRUD operation is an action endpoint, as in `POST /orders/{orderId}/cancel`.
- JSON fields use one casing across the API, usually camelCase.
- PATCH uses JSON Merge Patch, `application/merge-patch+json`.
- POST operations such as payments accept a client-generated `Idempotency-Key` and return the stored result for a repeated key. Its IETF draft is not yet an RFC.

## Status codes

Create returns 201 with `Location`, async work 202 with a status link. Malformed syntax is 400, a well-formed body that fails validation 422. Use 404 when the caller may not know the resource exists, 409 for a state conflict, 412 when `If-Match` fails, and 429 with `Retry-After`.

## Errors

Use RFC 9457 problem details, `application/problem+json`, with `type` as a URI, a stable `title`, `status`, `detail`, `instance`, and extension members such as the invalid fields. No stack traces, SQL, or other users' internal IDs.

## Data

- Timestamps in RFC 3339 with a zone, preferably UTC. IDs as strings, even when numeric.
- Money as integer minor units or a decimal string plus an ISO 4217 code, never a float.
- Enums as stable strings that clients expect to grow. Omitted fields and `null` follow one documented rule.
- Growing collections are paginated with a default and maximum page size, preferably by cursor with a `next` link omitted on the last page.

## Evolution and concurrency

Change additively. A breaking change ships as a new version beside the old one with a deprecation period, under one versioning scheme for the whole API. Updatable resources return an `ETag`, updates where lost writes matter require `If-Match`, and GET supports `If-None-Match` with 304.

## Security by OWASP API Security Top 10 2023

- Authorize every object access (API1) and every function, denying privileged endpoints by default even under a shared prefix (API5).
- Requests bind to schemas listing writable fields and responses to schemas listing visible fields, so clients cannot set role, owner, or price (API3). Ownership never comes from client-supplied IDs.
- Limit body, page, and upload sizes, rate limit (API4), and protect sign-up, checkout, booking, and posting per account or device (API6).
- Client-supplied URLs such as webhooks pass an allow-list (API7). Serve HTTPS only with HSTS, and allow CORS only for explicit origins.
- Every deployed version, host, and endpoint is in the spec, and retired versions and debug endpoints are off (API9).
- Third-party responses are validated like client input, with timeouts and size limits (API10).

## Contract

Keep the OpenAPI spec in version control in the project's OpenAPI version, generate or validate code against it, and review every change to it as an API change.

## Reference files

- [examples.md](examples.md) has the validation error and paginated collection shapes. Read it before writing an error response or a list endpoint.
