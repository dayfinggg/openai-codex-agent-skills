---
name: frontend-ui
description: Design, implement, or review accessible web interfaces and visual styling. Use for HTML and CSS interactions, Tailwind CSS, shadcn/ui, keyboard and focus behavior, responsive layouts, motion, Core Web Vitals, or a page that needs a specific visual direction. For React or Next.js implementation details, also use the matching framework skill.
license: MIT AND Apache-2.0
metadata:
  source: "Includes material from Google Chrome Modern Web Guidance 1.0."
---

# Front-end interface work

Inspect the existing design system, dependencies, browser targets, and available preview workflow before changing interface code. Match the project rather than introducing a new stack or visual language. Confirm version-specific APIs and browser support against the installed package documentation and authoritative platform documentation before relying on them.

Read [references/modern-web-platform.md](references/modern-web-platform.md) when choosing native HTML or CSS behavior, browser fallbacks, forms, overlays, motion, or platform features. Read [references/tailwind-v4.md](references/tailwind-v4.md) when changing Tailwind v4 styles, configuration, or a v3 migration. Read [references/accessibility.md](references/accessibility.md) when implementing or auditing accessibility, input, keyboard, focus, zoom, or forced-colors behavior. Read [references/web-vitals.md](references/web-vitals.md) when measuring or addressing page performance. Read [references/visual-design.md](references/visual-design.md) when creating or restyling a page or component.

Prefer semantic native controls and platform features when they meet the supported-browser target. Use progressive enhancement or a tested fallback when they do not. Keep interactive controls usable without hover, visible focus, reduced-motion support, readable states, and content that remains usable at narrow widths and zoom.

For a visual change, inspect the result in the browser when available, including relevant responsive, theme, loading, empty, error, and interaction states. For a performance change, measure the named metric before and after with a comparable field or lab method. Report only what the evidence supports.

The references include dated compatibility examples from the source release. Treat those as leads, and confirm changing standards, thresholds, browser support, and library APIs against the current official documentation and the project's actual target before applying them.
