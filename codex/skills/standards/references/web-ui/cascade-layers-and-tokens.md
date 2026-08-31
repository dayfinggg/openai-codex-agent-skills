# Cascade, layers, and tokens

- Reason about cascade origin, importance, layer order, specificity, scoping proximity, and source order in that sequence.
- Declare an intentional layer order, such as reset, base, components, utilities, and overrides, before rules grow numerous.
- Keep selector specificity low so a component can be changed without `!important` or selector escalation.
- Prefer classes, attributes, and state pseudo-classes over IDs and long descendant chains for styling.
- Use `:where()` to keep a shared selector easy to override and `@scope` when a supported subtree boundary expresses ownership more clearly.
- Keep third-party CSS in a named low-priority layer when it must be included, and document any deliberate exception.
- Avoid network `@import`; use stylesheet links or the build system so dependencies are visible and loadable earlier.
- Keep declarations, media queries, and feature queries near the rule or component they own.
- Use custom properties for repeated, meaningful design decisions such as color roles, spacing steps, radii, and type scales.
- Name tokens by purpose, such as `--surface-raised` or `--space-3`, rather than by a temporary color or component location.
- Define global tokens at `:root`, override them at a clear theme or component boundary, and supply fallbacks where support or inheritance can fail.
- Do not create a token for every one-off value; a token should represent a repeated decision or a stable customization point.
