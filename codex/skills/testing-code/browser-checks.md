# Checking a page in a browser

Check changed page behavior or layout in a real browser when available. Use the session's browser tools or existing Playwright setup and the project's own startup scripts. Choose checks relevant to the changed surface. If the browser or app cannot run, state what remains unverified.

## What to check

- Widths: a phone at about 390 pixels and a desktop at 1280 pixels or more, plus a tablet width when the layout changes between them. In Playwright, use `devices['iPhone 13']` or `page.setViewportSize({ width: 390, height: 844 })`.
- Overflow: at phone width the page must not scroll sideways. `document.documentElement.scrollWidth > document.documentElement.clientWidth` is true when it does.
- Console and network: no new errors or warnings in the console and no failed requests caused by the change. In Playwright, collect them with `page.on('console')`, `page.on('requestfailed')` and responses whose status is 400 or higher.
- States: loading, empty, error, a very long text, many items and a single item, whichever the component can reach.
- Keyboard: every control can be reached with Tab, focus is visible, Enter and Space activate buttons, and Escape closes dialogs and menus.
- Color schemes and languages the project supports: dark mode through `colorScheme: 'dark'`, and the longest translation when the interface is localized.
- Accessibility: use the project's existing axe checks when available. Do not install `@axe-core/playwright` solely for a small edit. Automated checks cover only part of accessibility, so check relevant keyboard interactions too.

## Compare with the request

Take a screenshot at each width and compare it with what the user asked for, element by element. Zoom in on small details such as icons, alignment and truncated text. Say what does not match rather than describing the page as done.

## Proof

Report which widths and states you checked and what you found. Never say a page looks right without a screenshot or page read from the current turn. Add a lasting visual regression test with `toHaveScreenshot` only when the project already uses them.
