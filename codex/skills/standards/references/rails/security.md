# Security

- Authenticate and authorize every sensitive action, including actions reachable through guessed or changed IDs.
- Scope lookups through the current account or user instead of loading a global record and checking later.
- Use strong parameters at the controller boundary with `params.expect` when strict shape and required keys are useful.
- Use `permit` deliberately for accepted attributes and never pass the entire parameter hash to a model.
- Keep CSRF protection enabled for cookie-backed browser sessions and do not disable it globally to fix one client.
- Give API clients an explicit authentication and CSRF strategy that matches their credential transport.
- Rely on Rails output escaping and treat `html_safe`, `raw`, and user-supplied HTML as security-sensitive.
- Never interpolate request data into SQL, shell commands, file paths, redirects, or template code.
- Prefer parameterized queries, allowlists, safe URL generation, and vetted upload handling.
- Hash passwords with the supported password facility and never store plaintext credentials.
- Encrypt or sign sensitive cookie values and keep secrets in credentials or the deployment secret manager.
- Filter passwords, tokens, authorization headers, and other secrets from logs and exception reports.
- Use a Content Security Policy and prefer nonces over `unsafe-inline` when inline scripts remain necessary.
- Validate upload type, size, name, and storage location, and do not serve untrusted files as executable content.
- Add regression tests for authorization, parameter overposting, unsafe redirects, and injection-shaped input.
