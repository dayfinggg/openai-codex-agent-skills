# Web control families

**Reviewed:** 2026-08-11
**Scope:** OWASP Cheat Sheet Series and browser security standards. Resolve framework and browser support before selecting a mechanism.

## Browser sessions and requests

- Use secure, HTTP-only, appropriately scoped and same-site cookies for session identifiers where the architecture uses cookies.
- Rotate sessions after authentication and privilege change, expire and revoke them intentionally, and protect state-changing browser requests against CSRF.
- Configure CORS for named trusted origins, methods, headers, and credential behavior. CORS is not server-side authorization.
- Deploy CSP as a tested defense in depth with nonce or hash strategy where required. Do not use it as a substitute for contextual output handling.

## Input, output, and remote access

- Use contextual output encoding and safe DOM APIs. Sanitize only when the product intentionally accepts rich markup.
- Validate uploaded type from content and required format, randomize storage names, isolate processing, bound size and decompression, and keep uploads outside executable web roots.
- For outbound requests, allow-list schemes, destinations, ports, redirect behavior, DNS and IP ranges where possible. Revalidate after redirects and resolution, and block internal metadata or control planes.
- Use supported serializers and parsers with type allow-lists and resource bounds. Never deserialize untrusted native objects or evaluate input as code.

## Abuse and failure

- Rate-limit by the smallest trustworthy identity and action scope, with safe behavior for shared networks and distributed state.
- Make login, recovery, invitation, verification, search, export, and expensive parsing resistant to enumeration and resource exhaustion.
- Keep security errors generic to an attacker but diagnosable through redacted internal events.

## Official sources

- [OWASP Session Management Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Session_Management_Cheat_Sheet.html)
- [OWASP CSRF Prevention Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Cross-Site_Request_Forgery_Prevention_Cheat_Sheet.html)
- [OWASP XSS Prevention Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Cross_Site_Scripting_Prevention_Cheat_Sheet.html)
- [OWASP SSRF Prevention Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Server_Side_Request_Forgery_Prevention_Cheat_Sheet.html)
- [OWASP File Upload Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/File_Upload_Cheat_Sheet.html)
