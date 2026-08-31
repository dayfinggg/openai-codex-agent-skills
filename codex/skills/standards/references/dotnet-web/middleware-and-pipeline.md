# Middleware and pipeline

- Middleware runs in registration order on the request and reverse order on the response, so order is part of the behavior.
- Put production exception handling first, then configure trusted forwarded headers before any component that consumes scheme, host, or client-IP data.
- Place HTTPS handling and public static-file handling according to the deployment topology and data sensitivity.
- With endpoint routing, use `UseRouting`, then `UseCors`, `UseAuthentication`, and `UseAuthorization` in that order when those components are present.
- Place antiforgery middleware after authentication and authorization, and before form-writing endpoints that require it.
- Call endpoint-specific rate limiting after routing; global-only limiters can be placed earlier when appropriate.
- Use middleware for application-wide concerns and endpoint filters for behavior local to a route or route group.
- A middleware may short-circuit deliberately, but document the skipped downstream behavior and test the branch.
- Keep early, global middleware fast because it runs for every request.
