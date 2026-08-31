# Security
- Use one firewall unless the application has legitimately separate authentication systems.
- Use `access_control` for coarse path or role rules and voters or `IsGranted` for object-level decisions.
- Enforce authorization in the use case or voter, not only in templates or navigation.
- Use the Security component's CSRF support for login and state-changing forms.
- Use the `auto` password hasher and let Symfony migrate hashes as algorithms change.
- Enable login throttling with the Rate Limiter component to reduce brute-force attempts.
- Keep secure session cookies and authentication configuration enabled for the deployment model.
- Never log plaintext credentials, tokens, secret values, or full sensitive request payloads.
- Validate uploaded files by size, type, storage destination, and content handling.
