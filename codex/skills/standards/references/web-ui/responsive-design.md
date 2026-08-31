# Responsive design

- Include the viewport metadata needed for a mobile user agent to lay out the page at the device width.
- Let content determine breakpoints; add a media query when the content or interaction actually needs a change.
- Build a usable narrow layout first, then add enhancements for wider space rather than maintaining device-specific copies.
- Prefer normal flow, intrinsic sizing, flexible tracks, `minmax()`, `clamp()`, `min()`, `max()`, and `fit-content()` over fixed canvas coordinates.
- Constrain reading measure with `max-inline-size` and keep widths, gaps, and padding flexible.
- Use `@media` for viewport or user-preference conditions and `@container` for a component's available space.
- Provide a useful fallback before a container-query or other modern feature, then gate the enhancement with `@supports` when necessary.
- Use logical properties and values such as `inline-size`, `block-size`, `margin-inline`, and `inset-block` when direction or writing mode can vary.
- Make replaced content shrink safely with an appropriate aspect ratio, `max-inline-size: 100%`, and `block-size: auto` where applicable.
- Avoid fixed heights for content containers; allow longer labels, translations, zoom, and user text to expand them.
- Test narrow, wide, tall, short, zoomed, touch, keyboard, RTL, and vertical-writing contexts when they are in scope.
- Keep responsive rules close to the component rules they modify so later changes do not drift from their owner.
