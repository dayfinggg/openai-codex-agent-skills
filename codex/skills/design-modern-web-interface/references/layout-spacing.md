# Layout and Spacing

## Build from content

Start from the smallest meaningful layout. Create a breakpoint when navigation wraps, labels collide, controls lose useful size, lines become unreadable, or columns create wasted space. Do not begin with device names.

Use media queries for the page shell and container queries for reusable components. Prefer intrinsic sizing, `minmax()`, `auto-fit`, wrapping, and flexible tracks over many breakpoint overrides. Recompose structure instead of shrinking a desktop screenshot.

Four columns are a useful narrow-screen start, eight for medium layouts, and twelve or sixteen for wide or data-rich layouts. Use fewer columns when the composition is simpler. Verify near 320–390px, 768–900px, 1280–1440px, split windows, long translations, and zoom-driven reflow.

## Size containers

Use these as starting heuristics:

| Element | Narrow | Medium | Wide |
|---|---:|---:|---:|
| Page gutter | 16–20px | 24–32px | 40–64px |
| Product container | full width | 60–80rem | 70–90rem when content needs it |
| Prose measure | 45–70ch | 60–75ch | 60–75ch |
| Grid gap | 12–20px | 16–24px | 20–32px |
| Section spacing | 48–80px | 56–96px | 64–120px |

Do not maximize width by default. Data tools may need a wider canvas. Reading, forms, and focused workflows usually need a narrower one.

## Use a spacing system

Choose one project scale. A practical 4/8-based scale is 4, 8, 12, 16, 24, 32, 48, 64, 96, and 128px. Map semantic tokens such as `xs`, `sm`, `md`, `lg`, `xl`, and `section` to it. Use fluid section or page gutters when helpful.

Use proximity to show relationships. Labels sit closer to their values than to the next group. Headings have more space above than below. Avoid identical 24px padding on every surface and unrelated arbitrary gaps.

## Size controls

Use about 40px minimum height for compact pointer-driven tools and 44–48px for general or touch interfaces. WCAG 2.2 AA defines a 24 by 24 CSS-pixel minimum target with exceptions and a spacing alternative. Comfortable touch design generally exceeds it.

An icon can be 18–24px while its hit area remains larger. Keep about 8–12px between adjacent touch targets. Use `min-block-size` and padding rather than fixed height when labels can wrap. Give icon-only controls an accessible name and visible explanation when the meaning is not universal.

## Match information shape

Use cards for independently actionable, selectable, movable, or comparable units. Use sections, lists, tables, dividers, timelines, canvases, and whitespace for other relationships. Do not hide essential data merely to fit a breakpoint. For genuinely two-dimensional data, provide a deliberate scroll, summary, detail view, or column-priority strategy.

Sources: [Carbon grid](https://carbondesignsystem.com/elements/2x-grid/overview/), [Carbon spacing](https://carbondesignsystem.com/elements/spacing/overview/), [USWDS design tokens](https://designsystem.digital.gov/design-tokens/), [GOV.UK spacing](https://design-system.service.gov.uk/styles/spacing/), [web.dev container queries](https://web.dev/learn/css/container-queries/), [WCAG reflow](https://www.w3.org/WAI/WCAG21/Understanding/reflow), [WCAG target size](https://www.w3.org/WAI/WCAG22/Understanding/target-size-minimum).
