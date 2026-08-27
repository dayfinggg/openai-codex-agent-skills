# Visual foundations

Read this reference when defining or changing the visual system, layout, typography, color, density, responsiveness, or localization behavior.

## Build from context and hierarchy

- Start with the user's task, content, and reading order. The visual hierarchy should expose the primary decision or action, then supporting context, then optional detail.
- Group by meaning and workflow. Use proximity, alignment, shared backgrounds, borders, or whitespace only as much as needed to make relationships visible.
- Keep first-screen content useful. Product surfaces should reveal current state and the next action before explanatory or promotional material.
- Use familiar control shapes and platform conventions. Novel visual treatment must not make a common action harder to recognize.
- Preserve user control through clear exits, undo where practical, predictable navigation, and visible system status.

## Use a compact visual system

- Reuse the existing product tokens and components first. If no system exists, define only the roles needed for this interface: canvas and raised surfaces, primary and secondary text, border, accent, success, warning, danger, focus, spacing steps, type roles, radius, and elevation.
- Use a consistent spacing scale, commonly based on four or eight CSS pixels, but adapt the scale to the product's established density. Use smaller steps inside controls and larger steps between semantic groups.
- Establish a real grid with content width, margins, columns, and gutters. Align text and controls to shared edges and baselines. Do not use arbitrary per-section widths to create false variety.
- Let whitespace express hierarchy, not emptiness. Dense operational tools may need compact rows and persistent context; infrequent consumer flows may need more separation and fewer simultaneous decisions.
- Use borders, shadows, and surface changes sparingly. If every region is elevated or outlined, none of them establishes hierarchy.

## Typography

- Choose type for readability, platform fit, content, and brand. Use the existing family when one is established. Otherwise use one primary family and add a second only when it creates a necessary editorial or brand distinction.
- Define a limited semantic type ramp. Differentiate levels through a controlled combination of size, weight, line height, and color rather than many unrelated sizes.
- Keep body text comfortably readable and avoid light weights for small text. Use sentence case. Reserve uppercase for short labels when the product language requires it.
- Keep running text at a readable measure. Let headings wrap naturally when needed instead of shrinking body content or clipping localized strings.
- Verify the font that actually rendered. A CSS declaration is not proof that the webfont loaded; inspect computed `font-family`, font requests, fallback behavior, weight availability, and `document.fonts`.

## Color and contrast

- Begin with neutral hierarchy and add color for action, state, data, or brand. Avoid using accent or semantic colors as decoration.
- Give each semantic color one stable meaning. Pair color with text, shape, iconography, or position so meaning survives color-vision differences and monochrome rendering.
- Measure contrast for text, icons, controls, focus indicators, borders that carry meaning, and every interaction state. Check light, dark, disabled, hover, focus, selected, and error variants rather than only default colors.
- Do not solve weak hierarchy by adding more colors. Use typography, spacing, alignment, and content order first.
- Use gradients only when the product's brand or content requires a continuous scale. A decorative gradient is not a default background.

## Responsive composition

- Design breakpoints around content failure, not device names alone. Resize continuously and find where line length, controls, columns, or navigation stop working.
- Reflow, reorder, collapse, or progressively disclose content instead of uniformly shrinking a desktop layout. Preserve the primary task and essential context at every width.
- Use flexible dimensions with deliberate minimum and maximum sizes. Prevent controls, charts, tables, and media from forcing horizontal page overflow.
- At narrow widths, stack related fields and actions in reading order, keep targets easy to activate, and avoid fixed-height containers around wrapping text.
- Verify the widths immediately before and after each structural breakpoint, plus representative desktop and mobile sizes.

## Localization and adaptable text

- Keep user-visible strings externalizable and avoid composing sentences from fragments. Use locale-aware dates, times, numbers, currencies, units, and plural rules.
- Allow labels, buttons, navigation, tables, and errors to expand horizontally and vertically. Do not depend on English word length or fixed text boxes.
- Use logical start and end alignment instead of hard-coded left and right where direction can change. Mirror layout and directional controls for RTL while preserving graphs, media controls, and content whose direction must not flip.
- Declare language and direction correctly. Test long-string pseudolocalization, a real RTL locale, large text, and mixed-script content when localization is in scope.
- Avoid text baked into imagery. Check icons, colors, gestures, and examples for cultural meaning rather than assuming they translate unchanged.
