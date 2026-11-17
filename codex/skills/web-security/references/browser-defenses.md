# Browser-side security defenses

This reference adapts selected material from Google Chrome Modern Web Guidance 1.0. Verify current browser support and official guidance before changing headers or defenses.

## Content Security Policy and Trusted Types

- Inventory scripts, styles, inline content, third-party resources, frames, popup flows, and required cross-origin callers before changing CSP.
- A report-only policy reports violations but blocks nothing. Do not count it as a mitigation.
- Prefer a policy built around nonces or hashes where compatible. Generate a fresh unpredictable nonce per response. Host allowlists can include unsafe redirect and script endpoints.
- Read every Trusted Types policy body. A policy that returns untrusted input unchanged adds no protection.
- Keep CSP reports free of secrets and personal data. Verify compatibility with framework-generated scripts and required integrations.

## HTML and third-party resources

- Insert untrusted text as text. Where rich HTML is required, use a maintained context-appropriate sanitizer at the boundary and review its allowlist.
- Do not sanitize HTML with regular expressions or string replacement. Sanitize server-rendered, email, and other client output where each context requires it.
- Pin third-party resource versions where possible. Use Subresource Integrity with the correct CORS configuration when the resource is immutable and the deployment supports it.
- Treat runtime hashing of a third-party response as trusting the same source being checked.

## Cookies, origins, and messaging

- Set session-cookie attributes explicitly for the application's deployment and authentication flows. Check `Secure`, `HttpOnly`, `SameSite`, path, and domain requirements together.
- Compare parsed origins rather than hostname prefixes or substring matches. Reject opaque `null` origins unless a specific design securely handles them.
- Validate `postMessage` origins with exact expected values, and use an explicit target origin when sending sensitive data.
- Review `Origin`, Fetch Metadata, CORS, and cross-origin isolation policies with webhooks, SSO, embeds, payments, and legacy browsers in scope.

## Security headers and passkeys

- Add or change HSTS gradually, because a mistaken long-lived policy can lock users out. Use `frame-ancestors` to set embedding policy and send accurate content types with `nosniff`.
- Use Permissions Policy to restrict capabilities the application does not need, after checking embedded content and delegated features.
- Passkey and WebAuthn checks must be performed by a maintained server-side implementation. Client-reported device hints are not authentication or authorization.

## Further guidance

For feature-specific details, consult the linked official guides in [Chrome Modern Web Guidance](https://developer.chrome.com/docs/modern-web-guidance) and current browser documentation. Preserve existing integration behavior unless the task intentionally changes it.
