# Security

- Separate authentication, which establishes identity, from authorization, which decides access.
- Configure supported authentication schemes explicitly and call `UseAuthentication` before code that depends on `HttpContext.User`.
- Prefer policy-based authorization with requirements and handlers for reusable rules, and apply policies to endpoints or controllers.
- Enforce object-level ownership and business authorization in application or domain code, not only at the route role check.
- Require TLS in production; use HTTPS redirection and HSTS for web apps when the edge does not already enforce them.
- An API receiving sensitive data should not rely on an HTTP redirect that a non-browser client may ignore.
- Behind a proxy, process forwarded headers only from configured known proxies or networks and restrict accepted hosts.
- Treat cookie-authenticated browser writes as CSRF-sensitive and use antiforgery tokens for applicable form or state-changing endpoints.
- Configure CORS with the smallest explicit origin, method, and header set; never combine wildcard origins with credentials.
- Rate-limit public or expensive endpoints, choose partitions and limits from resource cost, and load-test the policy before deployment.
- Use DTOs and allow-lists to prevent over-posting and accidental exposure of server-only fields.
- In a multi-instance deployment, persist and protect a shared Data Protection key ring so cookies and antiforgery tokens work across nodes.
- Keep OpenAPI, diagnostics, and management endpoints private or authorized unless their exposure is intentional.
