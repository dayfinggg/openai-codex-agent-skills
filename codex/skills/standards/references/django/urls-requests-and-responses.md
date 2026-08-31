# URLs, requests, and responses

- Use named URL patterns and `reverse()` instead of hardcoding URLs in Python or templates. [D2]
- Remember that URLconf matching does not inspect the HTTP method.
- Enforce allowed methods in the view or with a suitable method decorator. [D2]
- Keep request parsing, authorization, application calls, response selection, and status codes visible in the view boundary.
- Keep domain and persistence code independent of `HttpRequest`, `HttpResponse`, and template concerns where practical.
- Return the correct `HttpResponse`, `JsonResponse`, redirect, and status for each operation.
- Use root `handler400`, `handler403`, `handler404`, and `handler500` only when the default error views do not meet the contract. [D2]
- Keep middleware for cross-cutting request and response policy, not for business workflows tied to one model. [D9]
- Django middleware runs as an onion: request code follows declared order and response code runs in reverse order. [D9]
- Treat middleware order as a dependency contract, such as sessions before authentication middleware. [D9]
- Avoid unexpected middleware short-circuits, especially when they bypass authentication, CSRF checks, logging, or response cleanup. [D9]
