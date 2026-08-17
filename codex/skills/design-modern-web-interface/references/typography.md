# Typography

These are production defaults and heuristics, not universal laws. Preserve a mature project type system. Otherwise select type from content, language, density, brand, platform, and performance needs.

## Choose families

Verify glyph coverage, punctuation, numerals, x-height, width, available weights, variable axes, fallback metrics, license, and file size. Test real Cyrillic, Latin, accents, currency, dates, and tabular data when required.

Prefer one versatile family. Add a second family only for a clear editorial or display role. Load only the weights and styles used. For a design-led public page, do not fall back to Georgia, Times, Arial, or another browser default as the main brand voice unless the editorial direction deliberately calls for it. Avoid automatic choices that make unrelated pages converge, including Inter, Manrope, Space Grotesk, Prata, Playfair Display, or a serif italic without a product reason.

Useful directions to evaluate:

| Need | Candidates to evaluate | Notes |
|---|---|---|
| Global neutral UI | system UI, Noto Sans, IBM Plex Sans, Source Sans 3 | Strong fallback and language options |
| Cyrillic-first product UI | Golos Text, Onest, IBM Plex Sans, Inter | Verify current font files and numerals |
| Technical or data | IBM Plex Sans with Plex Mono, Source Sans 3 with Source Code Pro | Use tabular figures for aligned numbers |
| Accessible reading | Atkinson Hyperlegible Next, Noto Sans, Source Sans 3 | Confirm language coverage before use |
| Editorial contrast | IBM Plex Sans with Plex Serif, Noto Sans with Noto Serif, a supported sans with Literata | Keep the second family to a defined role |
| Brand display | A licensed display or variable family selected for the product | Never sacrifice readability or required glyphs |

Do not claim a font supports a language without inspecting the actual file or authoritative specimen. Use a system stack when external loading, licensing, privacy, or performance is uncertain.

## Establish roles

Start with a 16px root and relative units. Typical roles:

| Role | Starting range | Line height | Use |
|---|---:|---:|---|
| Metadata | 12–13px | 1.35–1.5 | Secondary, noncritical text only |
| Dense product text | 14–16px | 1.4–1.6 | Tables, navigation, compact tools |
| General body | 16–18px | 1.45–1.7 | Most product and marketing copy |
| Intro or lead | 18–24px | 1.35–1.55 | Short explanatory passages |
| Small heading | 20–28px | 1.2–1.35 | Card, panel, subsection |
| Major heading | 28–48px | 1.1–1.25 | Page and section hierarchy |
| Display | 40–72px | 0.98–1.15 | Short primary marketing message |

Text below 12px is not acceptable. Dense interfaces may use a 14px body only with strong contrast, spacing, and zoom behavior. Display text above roughly 72px needs a clear composition reason. About 96px is a practical exceptional ceiling for short wide-screen copy, not a target. Narrow-screen display text usually belongs around 36–56px.

Use a coherent scale near 1.2–1.333 or a hand-tuned equivalent. Do not make every heading fluid. Body and controls usually benefit from stable `rem` tokens. For fluid display type, use zoomable bounds and a modest viewport term:

```css
font-size: clamp(2.5rem, calc(2.1rem + 2vw), 4.5rem);
```

Keep the maximum reasonably close to the minimum and test zoom. Never use `vw` alone for text.

## Typeset content

Keep sustained reading lines around 45–90 characters, with roughly 60–75 as a strong working range and about 66 as a useful target. Larger display copy needs a shorter measure. Do not justify ordinary web prose.

Use tighter tracking only for large display text. Use modest positive tracking for short uppercase labels. Avoid long uppercase passages, letter spacing above what the font supports, repeated eyebrow labels, and artificial line breaks that fail with translation.

Do not fix container heights around user-facing text. Verify 200% text enlargement, 400% zoom where relevant, long translations, right-to-left layout when supported, and WCAG text-spacing overrides without clipped, hidden, or overlapping content.

## Load fonts

Use `font-display: swap` or an intentionally chosen alternative. Preload only a critical local font. Subset by script carefully and retain required symbols. Use `size-adjust`, ascent, descent, and line-gap overrides when they materially reduce layout shift. Prefer a variable font when it replaces several static files, but do not ship unused axes.

Sources: [USWDS typography](https://designsystem.digital.gov/components/typography/), [Carbon typography](https://carbondesignsystem.com/elements/typography/type-sets/), [Apple typography](https://developer.apple.com/design/human-interface-guidelines/typography), [web.dev typography](https://web.dev/learn/design/typography/), [web.dev font practices](https://web.dev/articles/font-best-practices), [WCAG text spacing](https://www.w3.org/WAI/WCAG22/Understanding/text-spacing).
