# Color and Surfaces

## Build semantic palettes

Define roles before values: `canvas`, `surface`, `surface-raised`, `text`, `text-muted`, `border`, `interactive`, `focus`, `success`, `warning`, `danger`, and matching `on-*` colors. Components consume roles rather than raw color names.

Start with one accent family and a compact neutral scale. Add a second accent only when brand or data semantics requires it. Brand, focus, error, warning, and success should not all share one hue.

Use a perceptual space such as OKLCH to derive consistent steps, but provide an sRGB fallback when required by supported browsers. Change lightness most for neutral hierarchy, then chroma. Check every rendered foreground and background combination rather than trusting token names.

## Palette recipes

Treat these as structure, not copyable brand palettes:

| Direction | Canvas and surfaces | Text | Accent behavior |
|---|---|---|---|
| Quiet editorial | Warm near-white canvas, one paper surface, dark warm ink | Strong primary, restrained warm muted | One earthy or cultural accent used sparingly |
| Neutral product | Cool or neutral canvas, white or slightly raised surfaces, clear borders | Near-black primary, medium neutral secondary | One saturated action hue plus semantic states |
| Dark technical | Deep neutral canvas, slightly lighter layers, visible borders | Near-white primary, cool muted secondary | One luminous but controlled accent |
| Natural commerce | Material-derived warm neutrals and honest product photography | Dark neutral copy with strong price and state roles | A brand accent tied to craft or material |
| Health or calm | Low-chroma light surfaces with high legibility | Dark blue, green, or neutral ink rather than weak gray | Controlled reassuring accent, never color alone |

Do not default to blue-purple mesh gradients, neon glow, pure black, or low-contrast gray. A minimal palette still needs clear focus, selection, error, and chart states.

## Meet contrast and state needs

WCAG 2.2 normally requires 4.5:1 for regular text, 3:1 for large text, and 3:1 for essential interface graphics and boundaries. Verify text over images, gradients, translucent layers, disabled controls, placeholders, charts, hover, selected, and focus states. Color is never the only state cue.

Muted text must remain readable. Do not create it by lowering opacity without testing the resulting composite. Focus should be more visible than an ordinary border and remain visible against every adjacent color.

Design dark mode as a separate palette. Avoid mechanical inversion. Reduce large-area contrast, preserve text clarity, control accent chroma, and retest shadows, images, charts, and disabled states.

## Shape, borders, and elevation

Start with no enclosed surfaces. Add a container treatment only for an independently actionable or movable unit, a meaningful group that cannot be expressed by alignment and spacing, a floating overlay, or a real elevation change. A section, metric, table region, toolbar, or form group does not automatically need its own rectangle.

Choose one radius family, such as `none`, `sm`, `md`, and `full`. For a restrained web interface, start with square panels, 4–8px controls, and larger values only for a deliberate material or brand. Pill shapes belong to tags, segmented controls, avatars, or a defined brand element, not ordinary buttons, filters, and containers.

Use spacing and alignment first, tonal contrast second, partial dividers third, and a full border only when the entire boundary matters. Avoid stacking bordered rectangles inside bordered rectangles. Use shadow only for actual elevation, overlap, or focus. One or two soft elevation levels are enough. Avoid glow as a generic highlight. Keep border width, radius, and shadow behavior consistent.

Use blur and translucency only for a functional overlay on complex content. Ensure readable fallback surfaces, contrast, and acceptable rendering cost. Use gradients and texture to support hierarchy, atmosphere, data, or material, not to make an empty layout appear designed.

Perform a surface audit before completion. If most regions are boxed, rounded, tinted, or shadowed, remove treatments until the hierarchy still works through typography, spacing, grid, and a few deliberate separators.

Sources: [WCAG contrast](https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum), [WCAG non-text contrast](https://www.w3.org/WAI/WCAG22/Understanding/non-text-contrast), [Carbon themes](https://carbondesignsystem.com/elements/themes/overview/), [Carbon color accessibility](https://carbondesignsystem.com/guidelines/accessibility/color/), [GOV.UK colour](https://design-system.service.gov.uk/styles/colour/), [Apple materials](https://developer.apple.com/design/human-interface-guidelines/materials), [Atlassian design tokens](https://atlassian.design/foundations/tokens/design-tokens/).
