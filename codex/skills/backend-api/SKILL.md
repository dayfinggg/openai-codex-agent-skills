---
name: backend-api
description: Design or review HTTP API contracts, retries, idempotency, rate limits, pagination, deprecation, webhooks, and Stripe integrations. Use for REST or OpenAPI changes, queued API work, webhook delivery, Stripe Checkout or webhooks, and HTTP status or header decisions.
license: MIT
---

# HTTP APIs and reliability

This skill covers HTTP contracts and failure handling for APIs and their background jobs. Its standards and provider details are a dated reference, not a substitute for checking the active draft, API version, installed package, and project conventions. The named IETF drafts are not RFCs unless the current IETF record says otherwise. When they differ, follow the current standard and provider documentation.

## References

Open the full reference before the first step it covers, even when that step comes later in the task.

- [references/webhooks.md](references/webhooks.md): read when building a webhook sender, a webhook receiver, signature verification, or delivery retries for customer URLs.
- [references/stripe.md](references/stripe.md): read when integrating Stripe Checkout, PaymentIntents, subscriptions, Stripe webhooks or event destinations, Stripe idempotency or rate limits, or upgrading a Stripe SDK or API version.

## Check first

- Read the existing contract before adding to it: the OpenAPI document (`openapi.yaml` or `openapi.json` and its `openapi` version), the error body shape, the pagination style, auth, and any idempotency table or middleware. Match them.
- Find every layer that already retries (SDK defaults, HTTP client options, queue redelivery, the caller's own retries) before adding one.

## Contract

- Error bodies follow RFC 9457, which obsoletes RFC 7807, served as `application/problem+json`: `type` as a URI, `title`, `status`, `detail`, `instance`, plus extension members such as an `errors` array for field validation.
- Use the QUERY method (RFC 10008, June 2026) for searches too large or too sensitive for the URL. It is safe, idempotent and cacheable, and `Accept-Query` advertises the accepted body types. Proxies, CDNs, frameworks and clients may not support it yet, so confirm the whole path and keep a POST fallback.
- OpenAPI 3.2 (3.2.0 in September 2025, 3.2.1 in September 2026) adds a `query` operation, `additionalOperations` for other methods, `itemSchema` for sequential media types such as `text/event-stream` and `application/jsonl`, and `$self`. Move a document to 3.2 only when its generators and validators support it.
- Page large or changing collections with an opaque cursor that encodes the sort key plus a unique tiebreaker (`created_at` and `id`), a `limit` with a server maximum, and `next_cursor` or `has_more`. Offset paging skips and repeats rows under concurrent writes. Leave total counts out unless required, since they often need a full count query.
- Announce deprecation with the RFC 9745 `Deprecation` header, whose value is a structured-field date in Unix seconds, a `Link` with `rel="deprecation"`, and the RFC 8594 `Sunset` header with an HTTP date. `Deprecation: true` and HTTP-date values come from early drafts and are wrong now.

```http
Deprecation: @1688169599
Link: </docs/deprecations/v1>; rel="deprecation"; type="text/html"
Sunset: Sat, 01 May 2027 00:00:00 GMT
```

## Idempotency keys

- A write that clients may retry (payment, order, email, provisioning) accepts an `Idempotency-Key` header. The client creates one random key per intent (UUID v4), persists it, and sends the same key on every retry, including after a restart.
- The draft defines the value as a structured-field String, so it is sent quoted: `Idempotency-Key: "8e03978e-40d5-43e8-bc93-6894a57f9324"`. Status codes from the draft are 400 for a missing key when one is required, 422 when the same key carries a different payload, and 409 while the first request is still running. Each response has a problem details body.
- The server claims the key with one atomic insert under a unique constraint, not a SELECT then INSERT, storing a request fingerprint and an in-progress state, then stores the final status and body and replays them for later attempts.
- Publish how long keys live, and keep them longer than the longest redelivery path (client retries, dead-letter replay, provider retry windows). A 24-hour key table behind a 7-day dead-letter replay charges twice.

## Retries and unknown outcomes

- Every remote call ends in success, failure or unknown. A timeout, a reset connection or a 5xx after the request left is unknown, because the effect may have happened. Retry with the same key and parameters, or read the resource to reconcile.
- Retry only idempotent methods and keyed POSTs, at one layer only, with exponential backoff, full jitter, a cap and a per-request budget. Retry 408, 429, 502, 503, 504 and connection errors, not other 4xx. `Retry-After` holds either seconds or an HTTP date.
- Record the intent in your own database before calling out (a transactional outbox), so a crash between the call and its response leaves a row to reconcile.
- A database transaction that fails with SQLSTATE 40001 (serialization failure) or 40P01 (deadlock) was rolled back. Rerun the whole transaction, including the reads that chose its values. A connection lost during `COMMIT` is unknown instead, so reconcile before rerunning a relative write such as `balance = balance - 100`.
- Queue consumers ack after the side effect commits and stay idempotent, since delivery is at least once. Keep the visibility timeout or lease above the worst processing time, and dead-letter poison messages after a fixed number of attempts.

## Rate limits

- Return 429 with `Retry-After` when rate limiting. Keep the project's existing header convention if it has one.
- The RateLimit draft uses two structured fields: `RateLimit-Policy` (stable, with `q` quota, `w` window in seconds, optional `qu` unit and `pk` partition key) and `RateLimit` (current state, with `r` remaining and `t` seconds left). It replaces the de facto `X-RateLimit-*` headers and the draft's own earlier `RateLimit-Limit`, `RateLimit-Remaining` and `RateLimit-Reset`.

```http
RateLimit-Policy: "default";q=100;w=60
RateLimit: "default";r=50;t=30
```

- When both are sent, `Retry-After` must not point earlier than the end of the effective window. A positive `r` is not a promise that the next request is served.

## Gotchas

- A duplicate that arrives while the first attempt still runs gets a 409, a bounded wait or a 202 with a status URL, never a second execution because the first "seems stuck".
- A response type can list a field that the query projection, the serializer or DTO, or the OpenAPI schema drops, and the type check still passes. When adding or renaming a field, assert on a real serialized response.
- Retrying at two layers multiplies attempts: three SDK retries inside three job retries is nine calls per message, and more under a queue redelivery.
- A client that retries a POST without an idempotency key after a timeout creates a duplicate whenever the first request succeeded.

Related skills: use `$database` for database transactions and migrations, `$web-security` for endpoint access control and SSRF, and `$testing` or the language skill for focused checks.
