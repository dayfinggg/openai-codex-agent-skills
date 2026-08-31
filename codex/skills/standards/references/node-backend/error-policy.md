# Error policy

Throw `Error` instances with a stable application code and, where useful, a `cause`.
Use Node error codes rather than matching mutable error messages. [N2]
Separate expected client errors, domain conflicts, dependency failures, and programmer defects.
Map known failures to deliberate HTTP statuses at one transport boundary.
Do not expose stack traces, SQL, file paths, tokens, or upstream credentials.
Log unexpected failures with the original error, route, request identifier, and safe context.
Do not catch an error merely to log it and continue in an invalid state.
Treat unhandled rejections as ownership defects, not as a background retry mechanism.
Use `uncaughtException` only for last-resort synchronous cleanup before process exit. [N3]
If response bytes have started, finish or abort the stream and never send a second response.
