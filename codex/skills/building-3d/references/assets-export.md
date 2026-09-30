# Models, geometry, and export

## Author usable geometry

Choose procedural geometry, edited meshes, or existing licensed assets from the task and available tools. Model silhouette, proportions, and medium-scale forms before surface detail. Use topology appropriate to deformation, bevels, subdivision, or static rendering rather than enforcing one topology everywhere.

Inspect normals, winding, smoothing boundaries, tangent space, UV seams, texel density, transforms, pivots, and bounds. Remove accidental duplicate surfaces and unsupported degenerate elements without destroying intended open surfaces. Verify UVs with a checker and inspect texture seams at expected viewing distance. Treat manifold geometry as necessary for fabrication or volumes, not a universal condition for every visual asset.

For Three.js procedural data, [BufferGeometry](https://threejs.org/docs/pages/BufferGeometry.html) covers positions, indices, normals, UVs, groups, and bounds. Refresh affected attributes and bounds after edits. Preserve intentional hard edges instead of blindly recomputing smoothing. Check exported vertex counts because seams and material boundaries can split vertices.

## Blender source and materials

Inspect the installed Blender version and existing `.blend` conventions. Preserve source data, modifiers, action slots, rig relationships, and asset names unless the request changes them. Apply or bake transforms and modifiers only when required by the target, after checking their effects on rigs and shape keys. Keep editable source when it is part of the deliverable.

Use export-compatible materials or bake unsupported procedural shading into appropriate texture maps. Keep base color/emission separate from linear data maps. Check roughness, metalness, tangent-space normal orientation, alpha behavior, and channel packing against the target loader. Test the target renderer, not only Blender's viewport.

## Export for the actual consumer

Read the matching [Blender glTF manual](https://docs.blender.org/manual/en/latest/addons/scene_gltf2.html) and [glTF 2.0 specification](https://registry.khronos.org/glTF/specs/2.0/glTF-2.0.html). Blender's glTF exporter triangulates mesh faces. Export-compatible node arrangements and animation options vary by version. Do not assume arbitrary Blender shaders, constraints, simulations, or light setups round-trip unchanged.

Choose GLB or separate glTF resources according to deployment needs. Verify axes, units, texture dependencies, inclusion filters, material slots, camera framing, skin weights, morph targets, and clips. Export actions with the intended version-specific action/slot/NLA settings. Bake unsupported motion when necessary and confirm the exported result, not just the source animation.

Enable compression or extensions only when the consuming runtime supports them and provides any required decoder. [GLTFLoader](https://threejs.org/docs/pages/GLTFLoader.html) documents Three.js loader capabilities. Use the available [Khronos glTF Validator](https://github.com/KhronosGroup/glTF-Validator) to inspect errors, warnings, and asset statistics when possible. Structural validity does not prove visual fidelity or animation correctness.

Reimport or load the exported asset in the actual consumer. Compare silhouette, orientation, materials, transparency, scale, clip playback, and dependencies with the intended source. Report unsupported extensions or unavailable validation rather than claiming a successful pipeline.
