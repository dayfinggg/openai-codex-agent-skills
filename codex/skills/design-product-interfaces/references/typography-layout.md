# Typography, Layout, and Responsive Composition

Use this reference to define a readable information hierarchy that survives real content and changing space.

## Define semantic type roles

1. Choose type roles from content function: display, page title, section title, body, label, metadata, numeric data, and code only as needed.
2. Limit hierarchy tiers to those the content can justify. Differentiate roles with a coordinated mix of family, size, weight, width, leading, spacing, and color rather than size alone.
3. Choose the typeface for language coverage, legibility, available styles, numeral behavior, brand voice, loading constraints, and platform rendering. Use a system face or Inter only when it wins that evaluation.
4. Set body size and leading by typeface metrics, viewing distance, platform, density, and user settings. Test text at actual size; do not transfer values mechanically between web, mobile, desktop, and spatial interfaces.
5. Treat line measure recommendations as heuristics. A roughly 45–90-character measure can be a useful starting range for continuous Latin-script prose, but language, typeface, column purpose, viewport, and accessibility needs decide the final measure.
6. Avoid clipping, truncation, and fixed-height text containers unless loss is intentional and recoverable. Test long translations, large text, dense data, and narrow widths.

## Compose by relationships

1. Derive spacing from semantic proximity: keep labels close to their controls, related items closer than unrelated groups, and major regions separated clearly.
2. Use a restrained spacing vocabulary expressed as semantic tokens. Allow exceptions when typography, optical alignment, touch geometry, or content requires them; record the reason.
3. Align to reveal relationships and reading order. Break alignment deliberately only to create useful emphasis.
4. Balance density against task frequency and decision cost. Operational tools may be compact; learning, onboarding, and high-risk decisions often need more breathing room.
5. Prefer flow layout and intrinsic sizing over fixed coordinates. Use containment only when it clarifies ownership, interaction, or independent movement.

## Adapt instead of scaling

1. Choose breakpoints where content, controls, or navigation stop working, not from a universal device list. When representative content or a resizable artifact is unavailable, specify named layout transitions and leave numeric thresholds undecided until an observed failure justifies them.
2. Define what reflows, wraps, stacks, collapses, moves, becomes scrollable, or changes navigation mode. Preserve task priority and context across sizes.
3. Use compact, regular, and expanded arrangements when helpful, but derive their boundaries from the product and platform.
4. Test minimum and maximum content, localization, right-to-left layout when relevant, browser zoom, text resizing, display scaling, safe areas, virtual keyboards, and pointer or touch input.
5. Keep controls and information available after reflow. Do not solve narrow space by hiding essential actions or forcing page-level horizontal scrolling.

## Tokenize decisions

1. Name tokens by semantic role rather than literal appearance: `text-primary`, `surface-raised`, `space-related`, or repository-equivalent names.
2. Separate primitive values from semantic aliases when the existing system supports that distinction.
3. Define modes only for meaningful contexts such as theme, contrast, density, platform, or brand. Avoid multiplying modes to compensate for weak component structure.
4. Reuse established tokens first. Add a token only when repeated use and a stable semantic purpose justify it.

## Evidence classes

1. Follow platform typography and layout guidance for the target platform.
2. Treat typography books and visual-design principles as contextual heuristics, not compliance rules.
3. Treat exact sizes, line heights, spacing values, grids, and breakpoints as project decisions unless a governing standard or platform explicitly requires them.

## Sources

1. [Apple HIG: Typography](https://developer.apple.com/design/human-interface-guidelines/typography)
2. [Apple HIG: Layout](https://developer.apple.com/design/human-interface-guidelines/layout)
3. [Apple UI Design Dos and Don'ts](https://developer.apple.com/design/tips/)
4. [Practical Typography: Line Length](https://practicaltypography.com/line-length.html)
5. [Practical Typography: Summary of Key Rules](https://practicaltypography.com/summary-of-key-rules.html)
6. [Nielsen Norman Group: Visual Design Principles](https://media.nngroup.com/media/articles/attachments/Principles_Visual_Design-A4.pdf)
7. [Material Design 3](https://m3.material.io/)
8. [Microsoft Fluent 2](https://fluent2.microsoft.design/)
