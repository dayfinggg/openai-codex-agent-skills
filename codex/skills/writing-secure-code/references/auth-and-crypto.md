# Authentication, sessions, tokens, and cryptography

Project conventions and the framework's built-in security features win over this file when they meet the same bar. The values here are minimums from the OWASP cheat sheets and the JWT RFCs, so take stronger settings from the project when it has them.

## Contents

- Authentication
- Passwords
- Sessions and cookies
- CSRF
- JSON Web Tokens
- Secrets
- Cryptography
- Cheat sheets

## Authentication

- Use the framework's identity system or an external identity provider through OAuth 2.0 and OpenID Connect. Never write login, password reset, remember-me, or MFA flows from scratch.
- Every function that changes data or reveals non-public data requires authentication, unless it is deliberately public and the code says so through the framework's explicit marker for public routes (CWE-306).
- Rate-limit login, registration, password reset, and MFA verification, and protect them against credential stuffing as the cheat sheet describes.
- Offer MFA where the product has accounts, and never ship default or shared passwords.

## Passwords

- Hash with Argon2id with at least 19 MiB of memory, 2 iterations, and a parallelism of 1.
- Where Argon2id is not available, use scrypt with a cost parameter of at least 2^17, a block size of 8, and a parallelism of 1.
- Keep bcrypt only for legacy systems, with a work factor of at least 10, and reject passwords longer than 72 bytes, because most bcrypt implementations accept no more.
- Use PBKDF2 only when FIPS-140 compliance is required, with HMAC-SHA-256 and at least 600,000 iterations.
- A pepper adds defense in depth but never replaces the adaptive hash.
- Upgrade legacy hashes by rehashing the password at the user's next login.

## Sessions and cookies

- Let the framework create session IDs. They need at least 64 bits of entropy.
- Set `Secure` and `HttpOnly` on session cookies, and `SameSite=Strict` where the flows allow it, otherwise `SameSite=Lax`. Never set `SameSite=None` without `Secure`.
- Name the session cookie with the `__Host-` prefix, which requires `Secure`, `Path=/`, and no `Domain` attribute.
- Renew the session ID after login and after every other privilege change.
- Give every session an idle timeout and an absolute timeout from the project's configuration. The cheat sheet cites idle timeouts of 2 to 5 minutes for high-value applications and 15 to 30 minutes for low-risk ones, and absolute timeouts of 4 to 8 hours.
- Invalidate the session on the server at logout and at expiry, not only in the browser.
- Never keep session IDs, JWTs, refresh tokens, or other credentials in `localStorage` or `sessionStorage`, where any script in the origin can read them.

## CSRF

- Turn on the framework's CSRF protection first.
- Stateful applications use the synchronizer token pattern. Stateless ones use the signed double-submit cookie, with the token bound to the session by an HMAC.
- `Sec-Fetch-Site` is the primary signal for rejecting cross-site state-changing requests, with a fallback to checking `Origin` for browsers that do not send Fetch Metadata.
- APIs called by scripts can require a custom request header, which forces a CORS preflight for cross-origin callers.
- `SameSite` cookies are defense in depth and never the only CSRF defense.
- GET requests never change state.
- XSS defeats every CSRF defense, so CSRF protection depends on the HTML rules in the sinks file.

## JSON Web Tokens

- Validate with a maintained library and pass the expected algorithms as a fixed list, as RFC 8725 requires. Never let the token header pick the algorithm, never accept `none`, and never accept both public-key and MAC algorithms for one key.
- Reject a token at or after its `exp` time and before its `nbf` time, allowing at most a few minutes of leeway for clock skew, as RFC 7519 describes. Require `exp` to be present.
- Check that `iss` is an issuer the deployment trusts, that the key belongs to that issuer, and that `aud` contains this service's own identifier.
- HMAC keys need at least 160 bits of entropy and are never passwords.
- Claims are readable by anyone holding the token and leak through logs, browser storage, and referrer headers, so put no sensitive data in them.
- Keep access tokens short-lived, and revoke earlier through a denylist or a Token Status List when the product needs it.

## Secrets

- Read secrets from a secret manager. Use environment variables only when no other method is possible, because every process and many crash dumps can see them.
- Never put secrets in source, committed configuration, `ENV` or `ARG` lines of a Dockerfile, URLs, logs, or error messages, and mask them when they must pass through output.
- Design for rotation, so that changing a secret needs no code change.
- When a secret has been committed or logged, tell the user it must be rotated, because removing it from the latest version does not remove the copies.
- The managing-dependencies-and-ci skill covers secrets in CI pipelines.

## Cryptography

- Use TLS for data in transit and the highest-level API the platform or a vetted library offers. Never design your own algorithm or protocol.
- Encrypt with AES using a key of at least 128 bits, preferably 256, in an authenticated mode such as GCM or CCM. Use CTR or CBC only with a separate MAC in encrypt-then-MAC order, and never use ECB.
- Generate tokens, keys, nonces, reset codes, and unguessable identifiers with a secure random generator.

| Language | Use | Never for security |
|---|---|---|
| Python | `secrets` module, such as `secrets.token_urlsafe(32)` | `random` |
| JavaScript and TypeScript | `crypto.randomBytes`, `crypto.randomInt`, `crypto.randomUUID` | `Math.random` |
| Java | `java.security.SecureRandom` | `java.util.Random`, `Math.random`, `ThreadLocalRandom` |
| C# | `RandomNumberGenerator` | `System.Random` |
| Go | `crypto/rand`, such as `rand.Text` from Go 1.24 | `math/rand` |
| C | `getrandom(2)` | `rand`, `random` |

- Rely on random UUIDs as secrets only when the implementation is known to use a secure generator.
- Compare secrets, MACs, and token hashes in constant time with `secrets.compare_digest` in Python, `crypto.timingSafeEqual` in Node, which throws a `RangeError` when lengths differ, `MessageDigest.isEqual` in Java, `CryptographicOperations.FixedTimeEquals` in C#, and `subtle.ConstantTimeCompare` in Go.
- Generate keys with a secure random generator, keep key-encryption keys separate from data-encryption keys, and store keys in an HSM, a cloud key vault, or a secret manager, apart from the data they protect.
- Plan key rotation before it is needed, including after a suspected compromise.

## Cheat sheets

- [Authentication](https://cheatsheetseries.owasp.org/cheatsheets/Authentication_Cheat_Sheet.html)
- [Password Storage](https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html)
- [Forgot Password](https://cheatsheetseries.owasp.org/cheatsheets/Forgot_Password_Cheat_Sheet.html)
- [Multifactor Authentication](https://cheatsheetseries.owasp.org/cheatsheets/Multifactor_Authentication_Cheat_Sheet.html)
- [Credential Stuffing Prevention](https://cheatsheetseries.owasp.org/cheatsheets/Credential_Stuffing_Prevention_Cheat_Sheet.html)
- [Session Management](https://cheatsheetseries.owasp.org/cheatsheets/Session_Management_Cheat_Sheet.html)
- [Cross-Site Request Forgery Prevention](https://cheatsheetseries.owasp.org/cheatsheets/Cross-Site_Request_Forgery_Prevention_Cheat_Sheet.html)
- [JSON Web Token](https://cheatsheetseries.owasp.org/cheatsheets/JSON_Web_Token_Cheat_Sheet.html)
- [OAuth2](https://cheatsheetseries.owasp.org/cheatsheets/OAuth2_Cheat_Sheet.html)
- [Secrets Management](https://cheatsheetseries.owasp.org/cheatsheets/Secrets_Management_Cheat_Sheet.html)
- [Cryptographic Storage](https://cheatsheetseries.owasp.org/cheatsheets/Cryptographic_Storage_Cheat_Sheet.html)
- [Key Management](https://cheatsheetseries.owasp.org/cheatsheets/Key_Management_Cheat_Sheet.html)
- [Transport Layer Security](https://cheatsheetseries.owasp.org/cheatsheets/Transport_Layer_Security_Cheat_Sheet.html)
- [HTTP Strict Transport Security](https://cheatsheetseries.owasp.org/cheatsheets/HTTP_Strict_Transport_Security_Cheat_Sheet.html)
- [RFC 8725, JSON Web Token Best Current Practices](https://www.rfc-editor.org/rfc/rfc8725.html)
- [RFC 7519, JSON Web Token](https://www.rfc-editor.org/rfc/rfc7519.html)
