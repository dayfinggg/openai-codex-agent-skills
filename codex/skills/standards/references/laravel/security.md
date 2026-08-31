# Security
- Use `auth` middleware for authentication and policies or `can` middleware for object-level authorization.
- Protect cookie-authenticated POST, PUT, PATCH, and DELETE forms with Laravel's CSRF middleware and token helpers.
- Exempt a webhook from CSRF only when the endpoint authenticates the provider's signature and replay policy.
- Hash passwords with `Hash` or the configured authentication stack and never log plaintext credentials.
- Keep Eloquent mass-assignment allowlists and query bindings enabled for all user-controlled data.
- Escape rendered output by default and review deliberate raw HTML output as a security-sensitive boundary.
- Apply route rate limiters to login, password reset, expensive endpoints, and resource-amplifying actions.
- Use Sanctum's stateful SPA flow when same-site cookie authentication is the intended API model.
- Validate uploaded files by size, type, storage destination, and content handling rather than trusting names or MIME headers.
