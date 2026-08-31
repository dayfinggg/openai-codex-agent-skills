# Security

- Treat all user-controlled input as untrusted and validate it before application work. [D11]
- Keep CSRF protection enabled for cookie-authenticated state changes and avoid `csrf_exempt` unless the threat model requires it. [D11]
- Keep template autoescaping enabled, review `safe` and `mark_safe`, and use a suitable CSP for content that needs stronger isolation. [D11]
- Prefer queryset parameterization and review `RawSQL`, custom SQL, and `extra()` carefully. [D11]
- Set `ALLOWED_HOSTS` and use Django's host validation rather than reading an untrusted `Host` header directly. [D11] [D14]
- Enforce site-wide HTTPS for authenticated traffic, enable secure session and CSRF cookies, and configure HSTS where appropriate. [D11] [D14]
- Keep `DEBUG` false in production because debug responses disclose source, settings, local variables, and library details. [D14]
- Treat uploaded media as untrusted content, prevent execution by the web server, and consider serving it from a separate origin. [D11] [D14]
