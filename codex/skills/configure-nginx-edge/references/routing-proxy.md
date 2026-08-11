# NGINX routing and proxying

**Reviewed:** 2026-08-11
**Scope:** Current NGINX Open Source documentation. Resolve installed version, build switches, modules, and vendor packaging first.

## Selection and URI behavior

- Verify listen-address, SNI or host, server-name, and location selection with the exact normalized and rewritten URI. Prefix, exact, regex, and nested locations have distinct precedence.
- Keep internal and external redirects bounded. Test encoded paths, duplicate slashes, traversal attempts, query strings, and trailing-slash behavior relevant to the application.
- Preserve static-file root or alias semantics. Validate filesystem permissions and prevent unintended directory or file exposure.

## Reverse proxy

- Set upstream `Host`, client address, scheme, and forwarding headers according to a defined trusted-proxy chain. Clear or replace spoofable inbound values.
- Define connect, send, and read timeouts from expected upstream behavior. A timeout is not a total request deadline unless the directive semantics prove it.
- Configure buffering, request buffering, maximum body size, temporary files, and streaming from payload and backpressure needs.
- Handle WebSocket or other protocol upgrades with explicit supported headers and idle behavior.
- Define retry conditions only for operations safe to replay. Do not retry non-idempotent requests blindly.
- Bound upstream connections and account for keepalive, load-balancing policy, health behavior, and failure amplification.

## Official sources

- [NGINX request processing](https://nginx.org/en/docs/http/request_processing.html)
- [NGINX reverse proxy guide](https://docs.nginx.com/nginx/admin-guide/web-server/reverse-proxy/)
- [ngx_http_proxy_module](https://nginx.org/en/docs/http/ngx_http_proxy_module.html)
- [WebSocket proxying](https://nginx.org/en/docs/http/websocket.html)
- [HTTP load balancing](https://nginx.org/en/docs/http/load_balancing.html)
