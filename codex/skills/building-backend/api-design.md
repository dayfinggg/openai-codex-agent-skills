# HTTP API design

- Resources are plural nouns (`/orders/{id}`). The HTTP method carries the action.
- Status codes: 200 for a read or an update that returns a body, 201 with a `Location` header for a create, 202 for accepted background work, 204 for a delete, 400 for malformed input, 401 when not authenticated, 403 when not allowed, 404 when missing, 409 for a conflict, 422 for validation errors and 429 when rate limited.
- Errors use RFC 9457 problem details with media type `application/problem+json` and the members `type`, `title`, `status`, `detail` and `instance`, plus an `errors` member for field messages.
- Paginate every list. Prefer cursor pagination with an opaque `next` cursor over page numbers for large or changing data. Return an empty list, never 404, for no results.
- Make retried requests safe. PUT and DELETE are idempotent by design. For POST that creates payments or orders, accept an idempotency key header and return the first result for a repeated key.
- Use ETags with `If-Match` to prevent lost updates when two clients edit the same resource.
- Accept and return JSON with consistent field naming, ISO 8601 timestamps with a time zone, and money as integer minor units or decimal strings, never floats.
- Version a public API from the first release, in the path (`/v1`) or a header, and never break a published version.
