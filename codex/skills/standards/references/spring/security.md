# Security
- Use Spring Security request rules for coarse access and method security for fine-grained checks.
- Add a catch-all request rule because unannotated methods are not secured by method annotations alone.
- Enforce ownership or tenant checks in the application layer, not only in URL matching.
- Configure an OAuth2 resource server with an issuer or explicit decoder and verify scopes or authorities.
- Keep CSRF protection for browser-session applications and disable it only for genuinely non-browser clients.
- Use `DelegatingPasswordEncoder` or a supported adaptive encoder, never `NoOpPasswordEncoder`.
- Restrict Actuator exposure and protect management endpoints with their own authorization rules.
