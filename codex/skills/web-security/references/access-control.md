# Access control and tenant isolation

Verify framework APIs and existing repository policy before assessing a control.

## Object-level authorization

For every resource action, ask whether a caller who knows another user's or tenant's identifier can read, change, delete, list, count, export, or subscribe to that object. Trace identifiers from routes, queries, bodies, headers, and job payloads into the lookup and action. Inspect base classes, middleware, scoped managers, decorators, and every bypass.

Lookups by an ID alone may omit ownership. A verified parent does not prove a separately fetched child belongs to it. Check bulk, list, search, autocomplete, GraphQL global lookup, file-download, presigned-link, WebSocket, webhook, and background-job paths as applicable. Unguessable identifiers are not an access-control check.

Authorization counts only if it compares the caller's authority with the specific object or operation. Authentication, role presence, or an existence check alone does not prove ownership. Compare against explicit allowed roles; a check that only rejects one denied role may allow an unknown role value.

## Property-level authorization

- Do not accept owner, tenant, role, privilege, or other protected fields from a request body without an explicit allowlist.
- Return an explicit response shape when the caller should not see every field of the underlying record.
- Check include, expand, fields, and serializer options that can expose related or privileged data beyond the primary object's authorization check.

## Tenant isolation

- Re-check tenant membership and object scope on every request, including server functions, file access, queues, and administrative operations reachable from a user path.
- Inspect unscoped query APIs and raw SQL for paths that bypass automatic tenant scoping.
- Include the tenant or user in cache, index, rate-limit, file-prefix, and message keys when data is scoped that way.
- Ensure concurrent request context does not use shared mutable module state or thread-local state in an asynchronous runtime.
- Check unique lookups and error differences that may reveal records belonging to another tenant.

## Review evidence

For a confirmed finding, identify the actor, entry point, object, missing comparison, and impact. For a regression test, use separate actors with separate object ownership and assert both the expected denial and that protected data is absent. Keep the test local and non-destructive.
