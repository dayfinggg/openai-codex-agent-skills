# Async handlers and errors

Use `async` route handlers and return their promises.
Express 5 forwards rejected promises and thrown async errors to `next` automatically. [E2]
If a promise is not returned, Express cannot observe its rejection; attach `.catch(next)` or return it. [E2]
Use `next(err)` for errors that occur after an asynchronous callback begins.
Define error middleware with exactly four parameters, `(err, req, res, next)`, and register it last. [E1]
Map known validation, authentication, authorization, not-found, conflict, and dependency errors deliberately.
Treat unknown errors as internal failures and do not expose their stack, SQL, file paths, or secrets in production. [E2]
If headers were sent, delegate to the default handler or close the stream rather than writing a second response. [E2]
Never catch an error only to log it and continue with inconsistent state.
Use `Error` instances with stable codes and causes so handlers do not match mutable messages.
