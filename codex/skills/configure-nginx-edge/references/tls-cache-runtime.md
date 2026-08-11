# NGINX TLS, cache, and runtime control

**Reviewed:** 2026-08-11
**Scope:** Current NGINX Open Source and administration documentation. Use current organizational TLS policy and installed-version directives.

## TLS and secrets

- Validate the certificate chain, names, validity, key match, file ownership, and reload path in the target environment without exposing private material.
- Use supported TLS versions and policy-approved ciphers. Verify upstream certificates and names when proxying over TLS.
- Assign redirect and HSTS ownership once across edge layers. Do not enable long-lived HSTS without authority and a recovery plan.

## Cache and limits

- Build cache keys from every response-varying dimension, including authorization and tenant context where caching is allowed.
- Define bypass, no-cache, validity, stale, locking, purge or invalidation ownership, storage bound, and failure behavior.
- Never cache authenticated, personalized, set-cookie, or otherwise private responses by default.
- Define rate and connection keys from trusted attributes. Avoid unbounded zones and ensure shared clients are not unintentionally grouped.

## Validation, reload, and rollback

1. Resolve the actual binary and configuration root.
2. Render all templates and includes using the deployment path.
3. Run the installed syntax and configuration test. Inspect the complete effective configuration only in a way that does not leak secrets.
4. Test representative routes in isolation, including failures, large or streaming bodies, timeouts, cache variation, and WebSocket paths where applicable.
5. Save or identify the prior immutable artifact and verify the rollback action.
6. Reload only with explicit authorization. Observe master and worker status and error logs, then verify routes and TLS.
7. Roll back on predefined health failure or ambiguous worker state.

## Official sources

- [Configuring HTTPS servers](https://nginx.org/en/docs/http/configuring_https_servers.html)
- [ngx_http_ssl_module](https://nginx.org/en/docs/http/ngx_http_ssl_module.html)
- [Content caching](https://docs.nginx.com/nginx/admin-guide/content-cache/content-caching/)
- [Controlling NGINX](https://nginx.org/en/docs/control.html)
- [Command-line parameters](https://nginx.org/en/docs/switches.html)
