# Web and API security

Read this reference only for browser, HTTP, identity, session, API, upload, outbound-request, or user-content changes.

## Identity and access

- Prefer the project's established identity provider and maintained framework middleware over custom credential or token handling.
- Choose authentication strength from the consequence of account takeover. Prefer phishing-resistant authenticators for privileged, administrative, financial, or sensitive-data access when the product and platform support them.
- Store passwords only with the current password-hashing facility recommended by the deployed framework or platform. Allow long passwords, reject known-compromised choices when supported, and do not impose arbitrary periodic rotation.
- Prevent account enumeration through response bodies, status differences, and materially different timing when that threat matters. Rate-limit automated authentication and recovery attempts without creating an easy account-lockout denial of service.
- Require recent or stronger authentication for credential changes, recovery, payment details, privilege changes, destructive operations, and other high-impact actions.
- Enforce authorization server-side for every object, function, property, tenant, and state transition. Bind resource lookup to the authorized principal instead of loading by user-supplied identifier and checking later.
- Prevent mass assignment by mapping accepted request fields explicitly. Never trust client-supplied roles, ownership, price, approval, verification, or policy state.

## Sessions, OAuth, and tokens

- Use framework session management unless a verified requirement needs another model. Generate unpredictable identifiers, rotate them after authentication and privilege changes, invalidate them on logout, recovery, or revocation, and apply idle and absolute expiry appropriate to the risk.
- For browser sessions, use narrowly scoped cookies with `Secure`, `HttpOnly`, and an appropriate `SameSite` value. Prefer host-only scope and restrictive paths; do not expose bearer session material to JavaScript without a demonstrated need.
- For JWTs, pin acceptable algorithms and validate signature, issuer, audience, token type, time claims, and application-specific claims. Keep validation rules distinct for different token kinds. Do not trust a claim merely because the token parsed.
- For OAuth browser and native flows, use authorization code with PKCE, exact redirect matching, transaction-bound state or nonce, and current provider metadata. Do not use implicit flow or open redirectors. Restrict token audience, scope, lifetime, and replay impact.

## Inputs, execution, and output

- Validate syntax, type, length, range, cardinality, encoding, and business meaning on the server. Use allowlists for bounded domains; a denylist may supplement but cannot replace positive validation.
- Canonicalize once when required and validate the representation that the security decision actually uses. Reject ambiguous encodings and duplicate fields when framework behavior could differ across layers.
- Use parameterized queries for SQL and other query languages. Avoid invoking a shell; when unavoidable, pass fixed executables and structured arguments without interpolation. Apply the same separation to templates, LDAP, XPath, regular expressions, and expression engines.
- Render untrusted data through framework auto-escaping or context-specific encoding for HTML, attributes, URLs, JavaScript, and CSS. Use vetted sanitization only when user-authored markup is a requirement. Avoid dangerous DOM sinks and framework escape hatches.
- Return only fields the caller is authorized to see. Use explicit response models to prevent accidental data exposure. Keep public errors stable and nonsensitive; retain detailed diagnostics only in protected telemetry.

## Browser boundaries

- Treat CSP as defense in depth, not a replacement for safe rendering. Start restrictive and permit only required sources; avoid broad wildcards and unsafe script execution.
- Configure CORS from an explicit origin list. Never combine credentialed requests with wildcard origins, and allow only required methods and headers. Remember that CORS is a browser read policy, not authentication or network access control.
- Protect cookie-authenticated state changes against CSRF with maintained framework defenses, same-site cookies, origin validation, or transaction-bound tokens as appropriate. Do not use `GET` for state changes.
- Apply browser security headers according to the actual deployment and framework. Do not add conflicting headers or copy a generic header set without testing application behavior.

## Outbound requests and uploads

- Avoid accepting arbitrary destination URLs. When required, restrict schemes, hosts, ports, and resolved addresses; reject loopback, private, link-local, metadata, and disallowed networks. Revalidate after resolution, block redirects or validate every hop, and enforce egress controls, timeouts, response-size limits, and protocol restrictions.
- For uploads, allow only required formats and sizes. Validate extension, media type, signature, and decoded content as applicable; generate server-side names; prevent traversal and overwrite; store outside executable and public paths; apply access control; scan or transform risky content when justified.
- Serve untrusted files with safe content disposition and content type, preferably from a separate origin when active content is possible. Do not execute, import, or deserialize an upload because its filename or declared type looks safe.

## Abuse and availability

- Inventory exposed endpoints and versions. Remove debug, obsolete, and undocumented interfaces from production.
- Bound pagination, batch size, body size, query complexity, uploads, exports, webhook fan-out, retries, and expensive downstream calls.
- Rate-limit by the actor and resource that represent the abuse case, not only by IP. Protect login, recovery, signup, search, messaging, reservation, purchase, invitation, verification, and other automatable high-value flows.
- Use idempotency, replay protection, atomic state transitions, and conflict handling where duplicated or concurrent requests can create money, inventory, privilege, or inconsistent state.
