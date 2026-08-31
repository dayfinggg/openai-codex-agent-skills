# Security
- Install `Authentication` and select a provider per protected route or route group.
- For JWT, verify the algorithm, issuer, audience, expiry, signature, and required claims before creating a principal.
- Implement authorization as a route guard or plugin that calls application policy, not as duplicated route conditionals.
- Use TLS in deployment and rotate signing keys or shared secrets according to the identity system's policy.
- Configure CORS with explicit allowed hosts, methods, headers, and preflight behavior.
- Keep a CSRF strategy for browser-session applications and do not treat bearer tokens as a reason to ignore cookie risks.
- Never store JWT secrets, private keys, passwords, or database credentials as plaintext in committed configuration.
