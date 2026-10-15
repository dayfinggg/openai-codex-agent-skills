---
name: designing-http-apis
description: Designs and reviews HTTP and REST JSON APIs by current standards for methods, status codes, errors, and OpenAPI contracts. Use when creating, changing, or reviewing endpoints, routes, controllers, request or response schemas, pagination, or OpenAPI specs.
---

# Designing HTTP APIs

An API is a contract that is expensive to change once clients depend on it, so design it for the client, keep it consistent, and evolve it without breaking callers. When the project already has API conventions or a style guide, follow them over this skill.

## Place in the architecture

The web is a delivery detail. Controllers parse and validate the request, call one use case, and map the result or error to an HTTP response. Business rules stay out of controllers, and request and response schemas are separate types from domain entities and database models, so the internal model can change without breaking clients. The applying-clean-architecture skill covers the layers.

## Resources and URLs

- Model nouns, not actions. Use plural collections and stable identifiers, as in `/orders` and `/orders/{orderId}`.
- Use lowercase kebab-case path segments. Nest at most one level for true ownership (`/orders/{orderId}/items`), and use filters for other relations.
- When an operation is not a natural create, read, update, or delete, model it as a sub-resource or an action endpoint, as in `POST /orders/{orderId}/cancel`, and keep such endpoints rare.
- Pick one casing for JSON fields across the whole API, usually camelCase, and keep it.

## Methods

| Method | Use | Safe | Idempotent |
|---|---|---|---|
| GET | Read a resource or collection | Yes | Yes |
| POST | Create in a collection, or run an action | No | No |
| PUT | Replace a resource completely at a known URL | No | Yes |
| PATCH | Partial update, preferably as JSON Merge Patch (`application/merge-patch+json`) | No | Not guaranteed |
| DELETE | Remove a resource | No | Yes |

GET never changes state. Make retried POST requests safe for operations such as payments by accepting a client-generated `Idempotency-Key` header and returning the stored result for a repeated key. This header is a widespread convention, and its IETF draft has expired without becoming a standard.

## Status codes

| Code | When |
|---|---|
| 200 OK | Successful read, update, or action with a body |
| 201 Created | Resource created, with a `Location` header pointing to it |
| 202 Accepted | Work started asynchronously, with a link to a status resource |
| 204 No Content | Success with no body, typical for DELETE |
| 304 Not Modified | Conditional GET matched the `ETag` |
| 400 Bad Request | Malformed syntax or invalid parameters |
| 401 Unauthorized | Missing or invalid authentication |
| 403 Forbidden | Authenticated but not allowed |
| 404 Not Found | Resource does not exist, or the caller may not know it exists |
| 409 Conflict | Request conflicts with current state, such as a duplicate |
| 412 Precondition Failed | `If-Match` did not match, meaning a concurrent edit |
| 422 Unprocessable Content | Well-formed body that fails validation rules |
| 429 Too Many Requests | Rate limit hit, with `Retry-After` |
| 500 Internal Server Error | Unexpected server fault, with no internal details exposed |

## Errors

Return errors as problem details (RFC 9457) with media type `application/problem+json`. Use `type` as a URI identifying the error kind, `title` as a short stable summary, `status`, `detail` for this occurrence, and `instance` for this request, and add extension members such as a list of invalid fields. Error bodies never contain stack traces, SQL, or internal identifiers of other users.

## Data formats

- Timestamps in RFC 3339 format with a time zone, preferably UTC, as in `2026-10-07T14:30:00Z`.
- Identifiers as strings, even when numeric inside, so the storage can change.
- Money as an integer of minor units or a decimal string, plus an ISO 4217 currency code, never as a float.
- Enumerations as stable string values. Clients must tolerate new values.
- Omit fields or use `null` consistently, and document which.

## Collections

- Paginate every collection that can grow. Prefer cursor pagination returning the items plus a `next` link or cursor, and omit it on the last page. Offset pagination is acceptable for small, stable data.
- Apply a default and a maximum page size.
- Offer filtering and sorting through query parameters with consistent names.

## Evolution and versioning

- Additive changes do not break clients. Adding optional request fields, response fields, endpoints, and enum values is safe when clients ignore unknown fields.
- Breaking changes include removing or renaming fields, changing types or meaning, adding required inputs, and changing status codes. Avoid them, and when unavoidable ship a new version alongside the old one with a deprecation period.
- Choose one versioning scheme for the API (a path prefix such as `/v1`, or a version header or query parameter) and use it everywhere.

## Concurrency and caching

Return an `ETag` for resources that clients update. Require `If-Match` on updates where lost writes matter and answer 412 on mismatch. Support `If-None-Match` on GET to answer 304.

## Security

These rules follow the OWASP API Security Top 10 2023. The writing-secure-code skill covers authentication, injection outside databases, secrets, and secure defaults in general.

- Use HTTPS only, with HSTS, and allow CORS only for explicit origins. Authenticate every endpoint unless it is deliberately public.
- Check authorization for every resource access, not only at login, because broken object level authorization is the first risk (API1).
- Check the caller's role for every function, and deny administrative and other privileged endpoints by default, even when they share a path prefix with ordinary ones (API5).
- Authorize at the property level. Return responses through explicit response schemas with only the fields the caller may see, and bind request bodies to explicit request schemas that list the writable fields, never directly to entities, so clients cannot set fields such as role, owner, or price (API3).
- Validate all input at the boundary, limit body sizes, page sizes, and upload sizes, and apply rate limits (API4).
- Protect sensitive business flows such as sign-up, checkout, booking, or posting comments from automated abuse with limits per account or device, beyond plain rate limits (API6).
- Treat URLs that clients supply, such as webhook targets or image links, as outbound URL sinks with an allow-list, as the writing-secure-code skill describes (API7).
- Keep an inventory. Every deployed version, host, and endpoint appears in the OpenAPI spec, and retired versions and debug endpoints are switched off (API9).
- Validate responses from third-party APIs as strictly as client input, and call them with timeouts and response size limits (API10).
- Never trust client-supplied identifiers of ownership.

## Contract

Describe the API in OpenAPI, using the version the project already uses. Keep the spec in version control, generate or validate code against it, and treat any change to it as an API change to review.

## Checklist

- [ ] URLs are plural nouns in kebab-case and the JSON casing is consistent
- [ ] Each method matches its semantics and GET has no side effects
- [ ] Status codes match the table and creates return `Location`
- [ ] Errors use problem details without internal information
- [ ] Collections are paginated with a maximum page size
- [ ] Timestamps, money, and identifiers follow the data formats above
- [ ] The change is additive, or versioned with a deprecation plan
- [ ] Authentication, per-resource and per-function authorization, and input validation are in place
- [ ] Request and response schemas list fields explicitly, so no mass assignment or overexposure is possible
- [ ] Client-supplied URLs, sensitive business flows, and third-party responses are guarded
- [ ] Controllers are thin and request schemas are separate from domain models
- [ ] The OpenAPI spec and tests are updated

## Reference files

Read the examples file before the first change to an endpoint, schema, or error response.

- [examples.md](examples.md) has illustrative requests and responses for creation, validation errors, pagination, partial updates, and conditional updates.
