# Visual direction and craft

## Establish a product-specific composition

Start with the actual information and the action people need to take. Decide what should be noticed first, what supports it and what can be disclosed later. Use alignment, proximity, whitespace and deliberate differences in scale to express those relationships. Not every section needs a card, border, badge or background panel.

Choose the composition from the content: a dense workbench, an editorial story and a product catalog need different reading patterns. Preserve useful platform conventions. Adapt Apple guidance to the target platform rather than applying Apple-specific materials or navigation to every website.

Inspect supplied screenshots or design files before implementing. Reuse available component states, spacing and asset proportions. Do not claim to have read a Figma document when only its screenshot is available. Resolve unspecified visual details from the brief and surrounding interface without requiring a mood board or approval step for every small edit.

## Typography and spacing

Define meaningful text roles such as page title, section title, body, label and supporting detail. Use existing text styles and a restrained scale, adjusting line height to the role and actual font. Large multi-line headings should not use the same line-height rule as dense body text. Check wrapping, optical alignment, numerals, missing glyphs and the scripts the product supports.

Select fonts for legibility, tone, language coverage, licensing and loading cost. An appropriate system font or existing brand family is better than adding a display face solely to look different. Use a spacing rhythm while allowing optical adjustments. A grid is a useful guide, not a demand that every measured dimension be a multiple of eight.

Use semantic color roles and consistent reusable styles or tokens where the project supports them. Separate text hierarchy from color-only meaning. Evaluate dark and light surfaces independently when both exist. Do not install a token pipeline or publish a shared design library for an isolated change.

## Graphics and material detail

Use a consistent icon family, stroke treatment and optical size. Give photography and illustration a clear role and preserve aspect ratios, subject placement and contrast behind text. Choose editable vector or code-native graphics for simple deterministic shapes. Use available generation or editing capabilities for richer raster imagery only when that asset serves the task. Keep source assets and licensed attribution when required.

Add gradients, texture, depth and motion to explain a hierarchy, material or interaction, not to fill empty space. A 3D viewer requires actual geometry and a working renderer when requested; a static render is suitable only for an explicitly static asset. Avoid unnecessary heavy graphics on content-first screens.

Common template symptoms include identical card treatment for unrelated content, unexplained accent words, invented statistics, meaningless numbered sections and the same glow or entrance animation everywhere. These are reasons to reconsider the design, not evidence that a particular font, color or radius is inherently wrong. Honor an explicitly requested style.

## Review the composition

Check spacing, baseline alignment, image crops, text truncation, focus states and the main action in the rendered result. Check real long copy and relevant empty or error states. Remove unnecessary decoration only within the requested scope. Reuse a component only when the responsibilities and state contracts are shared; visual similarity alone does not justify a universal component with many flags.

## Sources

Reviewed on 2026-10-01. These principles do not depend on a fixed library version. Confirm platform-specific APIs in the target project.

- [Apple HIG: Layout](https://developer.apple.com/design/human-interface-guidelines/layout). The readable [official document data](https://developer.apple.com/tutorials/data/design/human-interface-guidelines/layout.json) covers hierarchy, grouping and adaptation.
- [Apple HIG: Typography](https://developer.apple.com/design/human-interface-guidelines/typography). The readable [official document data](https://developer.apple.com/tutorials/data/design/human-interface-guidelines/typography.json) covers text roles and text-size support on applicable platforms.
- [Figma: Typography systems](https://www.figma.com/best-practices/typography-systems-in-figma/) covers role-specific line height, font selection and practical scales.
- [Figma: Components, styles and shared libraries](https://www.figma.com/best-practices/components-styles-and-shared-libraries/) covers reusable visual foundations and component organization.
