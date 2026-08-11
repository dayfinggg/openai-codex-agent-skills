# Browser core

**Reviewed:** 2026-08-11
**Scope:** Current web platform, WCAG 2.2, WAI-ARIA APG, Fetch, and Core Web Vitals guidance. Project browser targets and local tools remain authoritative.

## Semantics and accessibility

- Start with semantic HTML and native controls. Every interactive element needs an accessible name, keyboard operation, visible focus, and state communicated through native semantics or correct ARIA.
- Keep DOM order aligned with reading and focus order. Do not repair a visual reorder with arbitrary positive `tabindex` values.
- Associate labels, descriptions, validation errors, and status messages with the relevant control. Move focus only when the interaction requires it and users can predict the result.
- Use ARIA patterns only with their complete keyboard and state contract. An ARIA role does not add behavior.

## Browser trust and lifecycle

- Treat URL parameters, storage, cross-window messages, HTML, Markdown, clipboard, files, and service-worker messages as untrusted.
- Validate `postMessage` origins and message schemas. Encode output for its DOM context and avoid unsafe HTML sinks.
- Keep secrets out of client bundles and browser storage. Follow the application's cookie, CSP, CSRF, CORS, and session model.
- Release listeners, observers, timers, streams, object URLs, and in-flight requests according to lifecycle.

## Fetch and performance

- Handle status, content type, body parsing, cancellation, timeout policy, retry safety, and stale completion explicitly. A fulfilled fetch does not imply an HTTP success status.
- Measure LCP, INP, CLS, JavaScript cost, network requests, image behavior, and route-specific user timings where material.
- Compare lab results under fixed conditions and field data where available. Do not claim user impact from one synthetic run.

## Official sources

- [WCAG 2.2](https://www.w3.org/TR/WCAG22/)
- [WAI-ARIA Authoring Practices](https://www.w3.org/WAI/ARIA/apg/)
- [MDN Fetch API](https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API)
- [MDN Web performance](https://developer.mozilla.org/en-US/docs/Web/Performance)
- [Core Web Vitals](https://web.dev/articles/vitals)
