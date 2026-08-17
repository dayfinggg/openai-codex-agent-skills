# Motion

## Give motion a job

Use motion for orientation, feedback, continuity, causality, progressive disclosure, or one meaningful moment of emphasis. If removing an animation does not reduce understanding, feedback, or character, remove it.

Use productive motion for frequent actions and expressive motion for infrequent important moments. Never delay the primary action, block input until animation finishes, or animate every section into view.

## Start with tokens

Use the following as conditional starting points:

| Token | Range | Typical use |
|---|---:|---|
| Immediate | 70–120ms | Press, hover, toggle feedback |
| Small | 150–240ms | Tooltip, menu, small expansion, filter update |
| Large | 300–400ms | Drawer, modal, view transition, major reveal |
| Ambient | up to 700ms | Infrequent backdrop or large atmospheric change |

Scale duration with distance and size. A frequently used control should feel faster than a large page transition.

Use ease-out for entrances and direct feedback, ease-in for permanent exits, and a standard curve for elements visible throughout movement. Practical productive curves from Carbon are:

```css
--ease-standard: cubic-bezier(0.2, 0, 0.38, 0.9);
--ease-enter: cubic-bezier(0, 0, 0.38, 0.9);
--ease-exit: cubic-bezier(0.2, 0, 1, 0.9);
```

Avoid linear movement for interface transitions and avoid bounce, overshoot, elastic stretch, and sudden stops unless the product physics genuinely calls for them.

## Choreograph sparingly

Stagger only closely related elements when sequence helps orientation. Start around 20–60ms between items and keep the entire sequence near or below 500ms. Stop staggering after the first few meaningful items. Do not delay content below the fold.

Use shared-axis, fade-through, transform-origin, or matched-position continuity when it explains where an element came from or went. Use subtle opacity changes for secondary feedback. Do not attach `hover: scale(1.05)` or a translate effect to every card.

## Keep motion safe and fast

Prefer transform and opacity. Avoid animating layout geometry unless the interaction requires it. Reserve image dimensions, control font swaps, and monitor layout shift. Use `will-change` only shortly before a known animation, not globally.

Do not hijack scrolling. Parallax, scroll-linked reveals, cursor effects, and continuous ambient motion are decorative exceptions. They must not obscure content, harm input responsiveness, or become the only way information appears.

Honor `prefers-reduced-motion`. Replace nonessential movement with instant state changes or restrained opacity when appropriate. Preserve content, progress, spatial meaning, and feedback. Provide pause, stop, or hide controls for automatic movement that persists long enough to distract.

## Pattern guidance

Menus and tooltips should appear promptly with short entrance motion. Drawers and modals need spatial continuity and immediate focus management. Filtered lists should preserve item identity where possible instead of replaying a full-page entrance. Charts may animate a meaningful data transition once, but repeated updates should prioritize readability. Page transitions should remain brief and never conceal a slow load.

Sources: [Carbon motion](https://carbondesignsystem.com/elements/motion/overview/), [Carbon choreography](https://carbondesignsystem.com/elements/motion/choreography/), [Apple motion](https://developer.apple.com/design/human-interface-guidelines/motion), [Material 3 motion](https://m3.material.io/styles/motion/overview), [W3C interaction animation](https://www.w3.org/WAI/WCAG22/Understanding/animation-from-interactions), [W3C reduced-motion technique](https://www.w3.org/WAI/WCAG22/Techniques/css/C39), [web.dev animation performance](https://web.dev/articles/animations-guide).
