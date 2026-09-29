---
name: building-frontend
description: Implement or change React, Next.js, Vue, Nuxt or Tailwind browser interfaces. Covers components, state, routing, forms, data fetching and styles.
---

# Building frontend

Check package versions and the existing rendering, routing and styling approach. Read only the relevant framework reference:
- React: [react.md](react.md).
- Next.js: [nextjs.md](nextjs.md), plus React guidance when the component behavior needs it.
- Vue or Nuxt: [vue.md](vue.md).
- Tailwind: [tailwind.md](tailwind.md).

Examples target named versions, not every installed project. Confirm version-sensitive APIs before using them. Do not replace working conventions, a router or a CSS setup just because the reference describes a newer default.

Keep state near its owner and derive values instead of duplicating them. Use semantic HTML and accessible controls. Handle loading, empty and error states that the changed view can actually reach. Use server rendering where the project's architecture supports it, keeping client boundaries as small as practical.

Follow the project's component boundaries, design system and localization. For a new visual direction, use designing-interfaces. For verification of a changed page, use testing-code's browser-checks.md when a browser is available.
