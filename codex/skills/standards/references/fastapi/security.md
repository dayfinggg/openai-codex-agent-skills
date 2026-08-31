# Security

- Use FastAPI `Security` utilities and a documented OAuth2 or equivalent scheme for authentication and authorization. [F11]
- Treat OpenAPI security metadata as documentation and dependency wiring, not as enforcement by itself.
- Verify tokens, scopes, tenant access, and resource ownership in dependencies or application policy code.
- Enforce HTTPS at the proxy or platform, configure trusted proxy headers deliberately, and restrict accepted hosts.
- Configure CORS with exact allowed origins, methods, headers, and credentials; CORS is not authentication.
- Apply request, upload, decompression, and response-size limits at the edge and in the app.
- Hash passwords with a maintained password-hashing library, never log credentials, and never return a password field.
- Use parameterized database queries and treat raw SQL, unsafe redirects, file names, and HTML rendering as security-sensitive.
- Add rate limits and replay or idempotency defenses to authentication, password reset, and other high-impact endpoints.
