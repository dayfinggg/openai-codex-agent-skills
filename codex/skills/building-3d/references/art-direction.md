# Art direction and visual quality

## Establish the visual language

Derive the style from the requested scene, references, audience, and existing product. Support realistic, stylized, sculptural, architectural, scientific, cinematic, low-poly, abstract, and expressive work. Do not reduce all requests to glossy primitives, a generic gradient background, or a single photorealistic preset.

Choose a clear subject, silhouette, hierarchy, palette, scale relationships, and mood. Use foreground, middle ground, and background only where they help the composition. Review the most important camera views at the actual delivery size. Make spatial depth legible through perspective or orthographic composition, occlusion, form, contrast, and illumination, not gratuitous motion.

## Refine form and surfaces

Build recognizable proportions and structural detail before noise and ornament. Use bevels, thickness, surface breakup, and asymmetry where the subject calls for them. Balance authored variation with readable shapes. Avoid both accidental repetition and random detail that weakens the design.

Use physically based rendering (PBR) when it suits the result, or intentional toon, unlit, painted, or custom shading when appropriate. Distinguish surfaces through roughness, metalness, normal detail, reflectance, and texture scale, not only color. Keep material behavior coherent across assets and respect the installed renderer's color-management pipeline. Do not double-convert texture colors or apply output transforms twice.

## Compose light and camera

Use light or environment illumination to describe volume, separate the subject, and establish mood. Balance broad illumination with selective accents and contact cues. Inspect exposure, highlight clipping, reflections, shadow artifacts, and dark-area readability. Add shadow-casting lights, environment maps, or post-processing only when they improve the requested result at an acceptable cost.

Choose perspective or orthographic projection intentionally. Adjust framing, focal length or field of view, target, camera height, clipping, and navigation limits for the subject. Avoid distorted proportions unless deliberately stylized. Keep the initial view meaningful, and ensure requested alternate views reveal real geometry rather than hidden shortcuts.

## Review the final scene

Inspect representative close, distant, and interactive views where relevant. Look for floating objects, intersections, faceting, UV stretches, texture seams, incorrect transparency, z-fighting, aliasing, distracting bloom, and composition failures after resize. Compare with the user's visual references without claiming an exact match from memory.

Capture evidence of visual appearance only after assets load and lighting stabilizes. Separate aesthetic judgments from measured performance and tested behavior. Remove temporary helpers and debugging overlays. Do not add mandatory widgets, model editors, menus, gameplay, or extra deliverables to demonstrate sophistication.

## Sources

Reviewed on 2026-10-01. Artistic choices remain subject to the brief rather than a mandatory rendering style.

- [Three.js MeshStandardMaterial](https://threejs.org/docs/pages/MeshStandardMaterial.html) documents the physically based material model and surface parameters.
- [Three.js Texture](https://threejs.org/docs/pages/Texture.html) documents texture color-space annotation and resource ownership APIs. Confirm behavior against the installed release.
