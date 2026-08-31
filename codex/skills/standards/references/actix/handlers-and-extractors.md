# Handlers and extractors

- Actix handlers are async functions whose parameters implement `FromRequest` and whose result implements `Responder` [B2].
- Use typed `web::Path`, `web::Query`, headers, `web::Json`, `web::Form`, and `web::Data` to make the request contract visible.
- Only the first body-reading extractor can consume a request; use `Either` when the endpoint intentionally accepts fallback body types [B2].
- Configure `JsonConfig`, `FormConfig`, `PathConfig`, or `PayloadConfig` at the app, scope, or resource boundary [B2] [B7].
- Give JSON and form routes explicit size and content-type policies instead of inheriting a permissive default [B7].
- Treat raw `web::Payload` as an advanced boundary and use `to_bytes_limited` rather than unbounded buffering [B8].
- Write a focused custom extractor for authentication or reusable validation, and return a stable rejection before application code runs.
- Validate lengths, ranges, formats, content types, and allowed values before invoking a use case [S1].
- Keep extractor failures free of database, parser, filesystem, and stack-trace details.
