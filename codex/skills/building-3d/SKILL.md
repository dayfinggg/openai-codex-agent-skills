---
name: building-3d
description: Build or change genuine 3D scenes, models, materials, lighting, cameras, animation, and interactions in existing web runtimes or Blender. Covers Three.js, WebGL/WebGPU, glTF asset pipelines, measured rendering performance, and resource lifecycle. Use for requested 3D work, not ordinary CSS depth, 2D illustration, or a raster mockup alone.
---

# Building 3D

## Scope and runtime

Establish the requested artifact, visual direction, interactions and target from the request and project. Inspect the relevant rendering code, assets, dependencies and authoring tools. Keep the existing stack when it can deliver the result. Do not require Three.js, Blender, WebGPU or a framework wrapper just because this skill mentions them. Ask before materially changing the requested outcome or stack.

Use actual spatial geometry, materials, a camera and appropriate illumination when the scene needs them. Deliberate unlit styles are valid. A flattened image, CSS perspective or stacked sprites do not replace a genuine 3D deliverable. Use 2.5D techniques only when requested or sufficient for an explicitly non-3D task.

Choose complementary authoring, inspection, graphics, accessibility and testing capabilities from current descriptions and tools, not fixed skill names. Report a missing capability rather than delivering a mockup that only appears to work.

## Selective references

Load only the relevant reference sections, adding another file when the task crosses that boundary.

- Read [web runtime](references/web-runtime.md) for rendering, scene integration, interaction, and animation.
- Read [assets and export](references/assets-export.md) for geometry, UVs, Blender modeling, rigs, and glTF delivery.
- Read [art direction](references/art-direction.md) for composition, materials, light, camera, and visual refinement.
- Read [verification and performance](references/verification-performance.md) for real behavioral checks, measured optimization, and lifecycle.

Inspect the project's actual engine and Blender versions before using version-sensitive APIs, imports, shader syntax, exporter options, or extensions. Open official documentation matching those versions. The reference links are starting points, not a requirement to upgrade or proof that the installed version supports a feature.

## Build and verify

Develop the requested composition and 3D behavior together. Resolve applicable scale, coordinate conventions, asset ownership, loading, sizing and teardown before final polish. Do not force photorealism or add unrelated editors, control panels, debug widgets or game mechanics.

Exercise the changed runtime or exported asset when available. Verify requested movement and state transitions through real input and observations across time. A screenshot proves neither interaction nor animation nor frame time. Keep visual inspection, behavioral evidence, asset validation and performance measurements separate.

Use existing checks and focused regression coverage when practical. Compare performance under equivalent conditions before claiming improvement. Report verified behavior and meaningful limitations. A build alone does not prove visual quality or runtime reliability.
