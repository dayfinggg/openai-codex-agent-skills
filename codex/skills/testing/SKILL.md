---
name: testing
description: Select verification for a change, or diagnose browser, CLI, API, contract, and flaky test problems.
license: MIT and Apache-2.0. The playwright folder is adapted from microsoft/playwright-cli and the chrome-devtools folder from ChromeDevTools/chrome-devtools-mcp, both Apache-2.0. The changes remove code comments, headings, and links to files not shipped, rewrite the prose to the plugin style, and add commands checked against the current source. the distribution LICENSE lists every source.
---

Choose the smallest test scope that can expose the relevant failure. Include an integration check when the behavior crosses a real boundary.
Read the reference for the check.
- Test design uses [good-tests.md](references/good-tests.md).
- CLI, HTTP, and API contracts use [cli-and-api.md](references/cli-and-api.md).
- Intermittent failures use [flaky-tests.md](references/flaky-tests.md).
- Browser flows use [playwright-cli.md](references/playwright/playwright-cli.md) or [chrome-devtools.md](references/chrome-devtools/chrome-devtools.md), subject to the active harness.
- Playwright suites use [playwright-tests.md](references/playwright/playwright-tests.md).
- Creating browser tests uses [test-generation.md](references/playwright/test-generation.md).
- Request interception uses [request-mocking.md](references/playwright/request-mocking.md).
- Browser traces use [tracing.md](references/playwright/tracing.md).

A regression check must fail for the original defect. A green check that bypasses the affected behavior is not evidence.
