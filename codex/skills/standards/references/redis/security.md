# Security

- Keep Redis on a private network, firewall the port, bind only required interfaces, and never expose an unauthenticated instance to the Internet.
- Protected mode is a safety net, not a substitute for network isolation and explicit authentication.
- Prefer Redis ACL users with least-privilege commands, key patterns, and Pub/Sub channel patterns.
- Key patterns do not restrict database-wide commands such as `FLUSHALL`, `FLUSHDB`, or `SWAPDB`. Deny those commands explicitly for application users.
- Use TLS for client traffic, replication links, the Cluster bus, and Sentinel connections when traffic crosses a trust boundary.
- When TLS client authentication is enabled, Redis uses mutual certificate authentication by default.
- Do not rely on legacy `requirepass` alone because authentication without TLS exposes credentials to network observers.
- Use client parameterization and binary-safe protocol arguments, and never build Lua source from untrusted input.
- Restrict `CONFIG`, `DEBUG`, `MONITOR`, `SAVE`, `SHUTDOWN`, scripting, and module administration to trusted operator roles.
- Run Redis as an unprivileged OS user with restricted persistence directories and backup access.
- Validate untrusted payload sizes and collection growth to reduce denial-of-service risk from expensive commands or oversized values.
- Rotate ACL secrets, audit `ACL LOG`, and test permissions against the exact commands and key patterns used by each service.
