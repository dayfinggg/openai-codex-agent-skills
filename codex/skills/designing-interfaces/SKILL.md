---
name: designing-interfaces
description: Design or restyle web and app interfaces, including layout, typography, color, interaction and supporting UI graphics. Preserve an existing design system. Skip unrelated code fixes and standalone image-generation requests.
---

# Designing interfaces

## Direction and scope

Identify the audience, primary task, content hierarchy, platform and supplied references. Follow existing components, tokens and brand assets before inventing a new visual system. A review or design explanation does not authorize implementation. A narrow restyle does not authorize replacing the navigation, framework or product behavior.

For a new direction, choose typography, spacing, composition, color roles and imagery from the product's identity. Make the hierarchy and main action clear before polishing surfaces. Avoid repeating a generic hero, card grid, glow or decorative motion unrelated to the content. Distinctiveness does not require unusual fonts, inaccessible controls or a banned-color list.

Read [visual-craft.md](visual-craft.md) for composition, typography, tokens and graphics. Read [interaction-and-accessibility.md](interaction-and-accessibility.md) for interaction states, responsive behavior, accessibility and verification. Load only what the changed surface needs.

## Implementation and evidence

Use real copy and meaningful assets. Do not fabricate metrics, testimonials or brand claims. Keep controls recognizable, preserve native semantics and expose reachable loading, empty, error and success states. Reuse components when their responsibility and behavior actually match, not merely their appearance.

Choose additional implementation, graphics, 3D or testing workflows from the current available descriptions and tools. Do not hardcode another skill's name or introduce a design tool, component library or renderer just to follow this guide.

Inspect the changed surface in the real browser, app or supported preview when available. Scale verification to the change: check contrast for color changes, layout at affected sizes, and interaction or keyboard paths when their behavior changes. Use current screenshots to inspect visual details, not as proof of interaction or performance. Fix mismatches within scope and state any unavailable verification. Do not claim accessibility compliance or a working prototype from a build or attractive screenshot alone.
