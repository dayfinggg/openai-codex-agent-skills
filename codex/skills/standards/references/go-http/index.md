# Go HTTP backend

This reference covers framework-independent Go HTTP services built on net/http.
Use it as the baseline for chi, Gin, and Echo applications.
Keep boundaries where they provide independent ownership, replacement, persistence, or focused testing.

## Reference map

- [Router and server](router-and-server.md)
- [Handler boundary](handler-boundary.md)
- [Panic recovery and middleware](panic-recovery-and-middleware.md)
- [Context, validation, and JSON](context-validation-and-json.md)
- [Errors and database](errors-and-database.md)
- [Concurrency, security, and operations](concurrency-security-and-operations.md)
- [Testing](testing.md)
- [Sources](sources.md)
