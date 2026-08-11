# Browser and end-to-end testing

**Reviewed:** 2026-08-11
**Scope:** Current Playwright and Testing Library guidance. Resolve installed test runner, browser versions, application router, and CI environment first.

## User-observable behavior

- Start from a critical user task and expected states. Locate controls by role, accessible name, label, text, or stable user-visible contract before test IDs.
- Use web-first assertions for visibility, enabled state, value, URL, focus, and rendered outcome. Avoid sleeps and internal component selectors.
- Exercise navigation, reload or deep link, loading, empty, error, retry, unauthorized, stale, offline, and cancellation states that are material.
- Verify keyboard path, focus movement, accessible names, form errors, narrow viewport, and supported engines when the flow requires them.

## Isolation and effects

- Give each test a unique account, tenant, data namespace, browser context, and non-deliverable destination.
- Use storage state only with lifecycle, expiry, and isolation safeguards. Never commit real credentials or personal data.
- Stub a network boundary only when the test is not meant to verify that integration. Keep a smaller set of real-stack flows for critical contracts.
- Capture trace, screenshot, video, console, and network diagnostics on failure according to retention and privacy policy.
- Clean up through APIs or fixtures with bounded retries. Do not make production calls or external purchases.

## Reliability and performance

- Run tests independently and in random or alternate order when diagnosing shared state.
- Use retries only as temporary diagnostic evidence. A test that passes after retry remains flaky until the cause is fixed.
- Keep end-to-end coverage focused because browser tests are slower and have more failure surfaces than component or integration tests.

## Official sources

- [Playwright best practices](https://playwright.dev/docs/best-practices)
- [Playwright auto-waiting](https://playwright.dev/docs/actionability)
- [Playwright test isolation](https://playwright.dev/docs/browser-contexts)
- [Testing Library guiding principles](https://testing-library.com/docs/guiding-principles/)
