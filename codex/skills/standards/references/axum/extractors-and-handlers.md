# Extractors and handlers

- Use `Path`, `Query`, typed headers, `State`, `Json`, `Form`, and `Bytes` to make the request contract visible in the handler signature [A3].
- Put the one body-consuming extractor last because preceding extractors must implement `FromRequestParts` [A3].
- Never attempt to consume the request body twice; choose one decoded representation or explicitly buffer once.
- Return `Result<T, T::Rejection>` when one handler needs to customize an extractor rejection [A3].
- Write a custom `FromRequest` or `FromRequestParts` extractor when authentication, validation, or request context is reused across routes [A3] [A10].
- Keep extractor rejection bodies stable and avoid returning parser, database, or filesystem details to clients.
- Axum's default 2 MiB limit protects `Bytes`, `String`, `Json`, and `Form`, but an extractor that polls the body directly bypasses that local limit [A6].
- Add `RequestBodyLimitLayer` when a global limit must cover custom and third-party body consumers [A6] [H3].
- Validate content type, size, ranges, and formats before calling application services [S1].
