# Checking a page in a browser

Any change to something a person sees is checked in a real browser before it is reported as done. Use the browser tools the session provides, or Playwright when there are none. Start the app with the project's own scripts.

## What to check

- Widths: a phone at about 390 pixels and a desktop at 1280 pixels or more, plus a tablet width when the layout changes between them. In Playwright, use `devices['iPhone 13']` or `page.setViewportSize({ width: 390, height: 844 })`.
- Overflow: at phone width the page must not scroll sideways. `document.documentElement.scrollWidth > document.documentElement.clientWidth` is true when it does.
- Console and network: no new errors or warnings in the console and no failed requests caused by the change. In Playwright, collect them with `page.on('console')`, `page.on('requestfailed')` and responses whose status is 400 or higher.
- States: loading, empty, error, a very long text, many items and a single item, whichever the component can reach.
- Keyboard: every control can be reached with Tab, focus is visible, Enter and Space activate buttons, and Escape closes dialogs and menus.
- Color schemes and languages the project supports: dark mode through `colorScheme: 'dark'`, and the longest translation when the interface is localized.
- Accessibility: run `@axe-core/playwright` with `new AxeBuilder({ page }).withTags(['wcag2a', 'wcag2aa', 'wcag21a', 'wcag21aa']).analyze()` when the project can install it. Automated checks catch only part of the problems, so the keyboard check still runs.

## Compare with the request

Take a screenshot at each width and compare it with what the user asked for, element by element. Zoom in on small details such as icons, alignment and truncated text. Say what does not match rather than describing the page as done.

## Proof

Report which widths and states you checked and what you found. Never say a page looks right without a screenshot or page read from the current turn. Add a lasting visual regression test with `toHaveScreenshot` only when the project already uses them.
