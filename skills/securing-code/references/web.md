# Web flaws

## Browser

Server-side escaping misses script that writes to the page. Look for `innerHTML`, `document.write`, `eval`, `setTimeout` with a string, `javascript:` URLs in `href`, `dangerouslySetInnerHTML` and `v-html`. Sanitise as the last step with a current sanitiser, since HTML can change meaning when parsed again. A Content Security Policy with `unsafe-inline`, a wildcard or a host serving user files protects little, so use nonces with `strict-dynamic`, and Trusted Types where the browsers in use support them.

Prototype pollution starts in a recursive merge or path setter that accepts `__proto__` or `constructor`, and a gadget elsewhere turns it into code execution or a bypass, in browsers and in Node.js.

A `postMessage` handler checks the sender's origin, and a sender names a target origin. A CORS policy that reflects the request origin with credentials gives every site the user's session.

## Sessions and requests

Cross-site request forgery survives `SameSite=Lax` through a state-changing `GET`, a sibling subdomain and the short window after a cookie is set. Use a token for state changes and keep them on non-`GET` methods. Session cookies get `Secure`, `HttpOnly` and `SameSite`, a new identifier at login, and a scope that sibling subdomains cannot set. Set `frame-ancestors` against clickjacking, and treat an open redirect in a sign-in flow as token theft.

## Tokens and sign-in

For a JWT, fix the accepted algorithm in code, take the key from configuration rather than the token header, and check issuer, audience and expiry. For OAuth and OpenID Connect, match redirect addresses exactly, use PKCE, bind `state` to the session and use the authorisation code flow. Test error responses, reused codes and tokens issued for another client. Reset, email change and invitation flows leak through tokens in URLs, links built from the host header and messages that reveal whether an account exists.

## Proxies and caches

Request smuggling needs a front end and back end that disagree on where a request ends, through mixed `Content-Length` and `Transfer-Encoding`, HTTP/2 downgraded to HTTP/1.1, or lenient back ends. Use one protocol end to end where possible and reject ambiguous requests at the edge.

Cache poisoning stores a response shaped by an unkeyed input such as a forwarded host header. Cache deception stores a private response because a suffix or delimiter makes the path look static to the cache and dynamic to the application. Mark private responses `Cache-Control: no-store`, key on every input that changes the response, and align path rules between cache and application.

## Uploads

Decide the type from the content and an allow-list. Store uploads outside the web root or on a separate origin, serve them with `X-Content-Type-Options: nosniff` and a download disposition, and generate the stored name.

## WebSockets and GraphQL

A WebSocket handshake carries cookies outside the same-origin policy, so check `Origin` and authorise every message. In GraphQL, authorise in each resolver, limit depth and cost, and count aliases and batching as many attempts in one request.
