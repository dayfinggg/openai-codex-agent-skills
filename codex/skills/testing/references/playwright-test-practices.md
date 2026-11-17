# Playwright test practices

This reference summarizes practices in Playwright 1.65. Check the project's installed version and the [official release notes](https://playwright.dev/docs/release-notes) before using a version-specific option.

- Prefer role, label, and test-id locators. Use web-first assertions such as `toBeVisible()`, `toHaveText()`, and `toHaveURL()` so the assertion waits for the state.
- Use `expect.poll()` for conditions outside the DOM. Avoid fixed sleeps and `networkidle` waits; wait for a user-visible condition or the relevant response.
- Route third-party calls or states that the app cannot reliably produce. Keep the application's own backend real when its behavior is part of the contract.
- Treat stored browser state as credentials. Keep authentication state outside source control and prefer a dedicated test account and isolated browser profile.
- Use test locks only when the installed Playwright version supports them and tests share an external resource. Prefer a narrow lock over disabling parallelism for the full suite.
- Retries can conceal flaky tests. When the CI gate needs to reject flaky results, use a documented option such as `failOnFlakyTests` only if the installed version supports it.
- Capture traces on failures or retries when they help diagnose behavior. Check the console and page errors after a browser check.
- Review snapshot changes with the related test and the observed page. A regenerated snapshot alone is not a reason to accept a behavior change.
