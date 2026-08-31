# Security

- Configure `CorsLayer` with an explicit origin, method, and header policy; do not allow credentials with a wildcard origin [H6] [S1].
- Apply body limits to every route that accepts untrusted input, including file uploads and custom streaming extractors [A6] [H3].
- Authenticate in a focused extractor or middleware, then authorize the resource, owner, method, and workflow transition in application code [A10] [S1].
- Keep tokens, API keys, and passwords out of URLs, and do not log request bodies or secrets [S1] [H4].
- Reject unsupported methods and content types with semantically correct 4xx responses [S1].
- Add rate or concurrency limits to expensive and credentialed endpoints, and return 429 when policy rejects excess traffic [S1] [A11].
- Terminate TLS at a trusted edge or use a maintained TLS integration, and treat forwarded headers as untrusted until the proxy is configured.
- Return generic error messages and use browser security headers only when the API's browser context benefits from them [S1].
