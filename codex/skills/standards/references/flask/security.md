# Security

- Serve authenticated traffic over HTTPS and make reverse-proxy trust explicit.
- On Flask 3.1+, set `TRUSTED_HOSTS` and configure trusted proxy values; on older versions, enforce allowed hosts at a trusted proxy or explicit early middleware. [L8] [L10]
- Keep Jinja autoescaping enabled, review `|safe` and generated HTML, and add a suitable Content Security Policy. [L10]
- Use CSRF protection for cookie sessions; Flask leaves this responsibility to the application or an extension. [L10]
- Set `SESSION_COOKIE_SECURE=True`, `SESSION_COOKIE_HTTPONLY=True`, and `SESSION_COOKIE_SAMESITE` to an appropriate value for deployed sessions. [L8] [L10]
- Set a long random `SECRET_KEY`, keep it out of source control, and rotate it according to the session policy. [L8]
- Configure exact CORS origins, methods, headers, and credentials when browser clients are cross-origin; CORS is not authentication.
- Apply request, upload, decompression, response-size, rate, and timeout limits at the edge and in the app.
- Treat uploaded files, unsafe redirects, raw SQL, and user-provided HTML as security-sensitive inputs.
