# Web flaws

## Browser

Server-side escaping does not cover script that writes to the page. Look for DOM sinks such as `innerHTML`, `document.write`, `eval`, `setTimeout` with a string, a `javascript:` URL in `href`, and framework escapes such as `dangerouslySetInnerHTML` and `v-html`. Sanitised HTML can change meaning when the browser parses it again, so sanitise as the last step and keep the sanitiser current. A Content Security Policy with `unsafe-inline`, a wildcard source or a host that serves user files gives little protection. Prefer nonces with `strict-dynamic`, and Trusted Types where the browsers in use support them.

Prototype pollution starts in a recursive merge or a path setter that accepts `__proto__` or `constructor`. It turns into code execution or a bypass through a gadget elsewhere, on the client and in Node.js.

A `postMessage` handler needs a check of the origin of the sender, and a sender needs a target origin. A CORS policy that reflects the request origin with credentials gives every site the user's session.

## Sessions and requests

Cross-site request forgery survives `SameSite=Lax` on a state-changing `GET`, through a sibling subdomain, and in the short window after a cookie is set. Use a token for state changes and keep them off `GET`. Set `Secure`, `HttpOnly` and a `SameSite` value on session cookies, issue a new session identifier at login, and scope cookies so that a sibling subdomain cannot set them.

Clickjacking needs `frame-ancestors`. Open redirects become token theft in a sign-in flow.

## Tokens and sign-in

For a JWT, fix the accepted algorithm in code, never take the key or the algorithm from the token header, and check the issuer, the audience and the expiry. For OAuth and OpenID Connect, match the redirect address by exact string comparison, use PKCE, bind the `state` value to the session, and do not use the implicit flow. Test the unhappy paths, such as an error response, a reused code and a token issued for another client.

Password reset, email change and invitation flows leak through tokens in URLs, through host header values used to build links, and through messages that reveal whether an account exists.

## Proxies and caches

A front-end server and a back-end server that disagree about where a request ends allow request smuggling. Look for mixed handling of `Content-Length` and `Transfer-Encoding`, for HTTP/2 downgraded to HTTP/1.1, and for back ends that accept ambiguous requests. Use the same protocol end to end where you can and reject ambiguous requests at the edge.

Cache poisoning stores a response that was shaped by an input outside the cache key, such as a forwarded host header or an unkeyed parameter. Cache deception makes the cache store a private response because the path looks static to the cache and dynamic to the application, for example through a suffix or a delimiter that the two parse differently. Mark private responses `Cache-Control: no-store`, key the cache on every input that changes the response, and make the cache and the application agree on path rules.

## Uploads

Decide the type of an upload from its content and an allow-list, not from the name or the declared type. Store uploads outside the web root or on a separate origin, serve them with `X-Content-Type-Options: nosniff` and a download disposition, and generate the stored name.

## WebSockets and GraphQL

A WebSocket handshake carries cookies and is not covered by the same-origin policy, so check the `Origin` header and authorise every message. For GraphQL, authorise in each resolver and not at the route, limit depth and cost, and remember that aliases and batching multiply one request into many attempts.
