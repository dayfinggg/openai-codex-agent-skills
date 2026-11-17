# Tailwind CSS v4 migration notes

Verify the installed Tailwind version and current official upgrade guide before using migration details.

## Common v3 to v4 changes

| Tailwind v3 pattern | Tailwind v4 pattern |
|---|---|
| `@tailwind base/components/utilities` | `@import "tailwindcss"` |
| `theme.extend` in JavaScript configuration | `@theme` CSS variables |
| Hand-maintained content globs | Automatic detection, with `@source` for explicit paths |
| `@layer utilities` for custom utilities | `@utility` |
| `darkMode: 'class'` | `@custom-variant` |
| `theme(colors.red.500)` | CSS variables such as `var(--color-red-500)` |
| `resolveConfig()` in runtime JavaScript | Read generated custom properties from computed styles when runtime access is needed |
| `outline-none` as a replacement for a visible outline | `outline-hidden` plus a visible focus treatment |
| Opacity utilities on text and background colors | Slash-opacity forms such as `bg-black/50` |
| Sass, Less, or Stylus with Tailwind stylesheets | Use the supported CSS integration |

## Migration checks

- Read the installed major version, integration package, and configuration before changing syntax. In v4, configuration is primarily in CSS, and a JavaScript config must be explicitly loaded.
- Check source detection in monorepos and component packages. Files ignored by the project or outside scanned paths may need an explicit source declaration.
- Replace dynamic utility-string construction with a map of complete class strings so the scanner can discover each class.
- Check changed defaults for outline, ring, border, divide, spacing, gradients, placeholders, button cursors, and hidden elements.
- Review important and arbitrary-value syntax against the exact installed release, then run the project's build and inspect the rendered result in a browser.
- Treat codemod output as a proposal. Review its full diff and preserve local configuration and styles.
