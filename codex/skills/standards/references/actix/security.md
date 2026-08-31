# Security

- Configure TLS with a maintained Rustls or OpenSSL integration, or terminate TLS at a trusted edge [B1].
- Configure `actix-cors` with exact origins, methods, and headers when browser clients need cross-origin access [B5].
- Never combine credentialed CORS with a wildcard origin, and disable CORS when cross-origin calls are not required [B5] [S1].
- Set per-route JSON, form, payload, and upload limits, including limits for custom extractors [B7] [B8] [S1].
- Authenticate in middleware or an extractor, then authorize the requested resource, owner, method, and workflow transition on the server [S1].
- Keep tokens and API keys out of URLs, and redact credentials and personal data from request logs [S1].
- Reject unexpected methods and content types with semantically correct 4xx responses [S1].
- Treat forwarded host, scheme, and client-IP headers as untrusted until the proxy path is explicit.
- Add rate or concurrency limits to expensive and credentialed endpoints, and return 429 when policy rejects excess traffic [S1].
