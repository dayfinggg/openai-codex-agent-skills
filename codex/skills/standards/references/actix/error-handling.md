# Error handling

- Return `Result<T, E>` from handlers when `E` can convert to `actix_web::Error` and implements `ResponseError` for custom status mapping [B4].
- Use error helpers or a bounded `ResponseError` implementation for validation, authentication, conflict, timeout, and dependency failures [B4].
- Keep public error bodies generic while retaining causes and safe context for logs [S1].
- Actix logs errors at `WARN`; use `RUST_LOG` and `RUST_BACKTRACE` deliberately and avoid sending those diagnostics to clients [B4].
- Log each failure at one ownership boundary with request ID, route, status, and source fields.
- Do not use panics as request control flow, and keep response conversion separate from domain error construction.
- Review `ResponseError` status and body changes as API compatibility changes [L1].
