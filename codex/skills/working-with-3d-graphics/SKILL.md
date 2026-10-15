---
name: working-with-3d-graphics
description: Builds, scripts, and reviews 3D work in Blender, Unreal Engine 5, three.js, React Three Fiber, Babylon.js, and glTF. Use when writing or changing 3D scenes, shaders, materials, models, animation, or rendering code, or debugging how a scene looks or performs.
---

# Working with 3D graphics

3D work fails in ways code review does not catch, such as wrong scale, flipped normals, washed-out colors, or a scene that runs at ten frames per second. Get the shared conventions right, follow the target tool's current API, and look at the rendered result before calling the work done. Code quality rules from the writing-clean-code skill still apply.

## Check the versions first

APIs in this field change quickly. Before writing code, find the version in use, such as the Blender version, the engine version in the `.uproject`, or `three` in `package.json`, and follow that version's documentation. Do not use APIs recalled from older versions without checking them.

## Coordinate systems and units

| Tool | Up axis | Handedness | Unit |
|---|---|---|---|
| Blender | Z | Right-handed | 1 unit = 1 meter by default |
| glTF 2.0 | Y | Right-handed, front faces +Z | Meters |
| three.js, Babylon.js (glTF loaded) | Y | Right-handed | Meters by convention |
| Unreal Engine | Z | Left-handed | 1 unit = 1 centimeter |

- Model at real-world scale in meters, and let exporters and importers convert. Check imported size against a known reference, such as a 1.8 meter human or the UE mannequin.
- Apply rotation and scale on objects before export, so transforms are identity where the pipeline expects it.
- Place pivots where the object rotates or rests, such as the base of a prop or the hinge of a door.
- Name objects, meshes, materials, and textures clearly and consistently. Engines and code find assets by name.

## Physically based materials

- Use the metallic-roughness model, which Blender's Principled BSDF, glTF, three.js `MeshStandardMaterial` and `MeshPhysicalMaterial`, and Unreal all share.
- Metallic is 0 or 1 for almost every real surface. Values in between belong only to transitions such as dirt on metal.
- Base color of non-metals stays roughly between 30 and 240 in sRGB, never pure black or pure white.
- Roughness carries most of the realism, so vary it with texture rather than leaving one flat value.
- Pack grayscale maps into channels where the target expects it. glTF and three.js read occlusion, roughness, and metallic from the red, green, and blue channels (ORM).

## Color management

- Lighting math happens in linear space. Only the final image is converted for display.
- Color textures (base color, emissive) are sRGB. Data textures (normal, roughness, metallic, occlusion, height) are linear, called Non-Color in Blender and with sRGB unchecked in Unreal.
- Normal maps use the OpenGL convention (green up) in Blender, glTF, and three.js, and the DirectX convention (green down) in Unreal. Flip the green channel when moving between them, or set the importer option.
- Use a tone mapper for HDR lighting, such as AgX in Blender, ACES or AgX or Neutral in three.js, and the default filmic tone mapper in Unreal, and keep the choice consistent across a project.

## Geometry

- Keep normals facing outward and consistent, and recalculate them after boolean or mirror operations.
- Use quads for models that deform or get subdivided, triangles are fine for static game assets.
- Remove doubled vertices, interior faces, and zero-area faces before export.
- Every textured mesh needs a clean UV map without overlaps where lightmaps or baking need unique space.
- Provide level of detail versions or rely on Nanite or automatic simplification, matching the target.

## Real-time performance

Set budgets for the target device before building, then measure.

- **Draw calls.** Merge static meshes that share a material, and use instancing for repeated objects.
- **Triangles.** Spend them on silhouettes and close-up objects, and use normal maps for surface detail.
- **Textures.** Usually the largest memory cost. Use sizes that match on-screen size, power-of-two dimensions, mipmaps, and GPU compression such as KTX2 with Basis Universal on the web or BC formats in engines.
- **Lights and shadows.** Every shadow-casting light costs extra passes. Bake lighting where the scene is static.
- **Overdraw.** Limit large transparent surfaces and particles.
- Profile with the tool's own profiler before optimizing, such as Unreal Insights and `stat gpu`, the browser performance panel, or three.js `renderer.info`.

## Asset exchange

- **glTF 2.0 and GLB** is the standard for the web and real-time delivery. Use the binary GLB for a single file, and compress with meshopt or Draco geometry and KTX2 textures.
- **FBX** remains common for moving meshes and animation into Unreal.
- **OpenUSD** suits large scenes and film or studio pipelines with layered edits.
- Keep source files (`.blend`, project files) separate from exported assets, and make export repeatable with a script or saved settings.

## Verify visually

A 3D change is only checked when its image is checked. Render or screenshot the result and look at it, using a headless Blender render to PNG, a browser screenshot of the web scene, or a high resolution screenshot from Unreal. Compare it against the reference or the expected look, check the frame rate on the target device class, and state what was and was not verified.

## Workflow

1. Identify the tool, its version, the target platform, and the performance budget.
2. Read the existing project conventions for naming, folders, scale, and materials.
3. Read the reference file for the tool at hand.
4. Implement in small steps and render after each visible change.
5. Run the checklist.

## Checklist

- [ ] Scale, up axis, and pivots are correct in the target
- [ ] Color textures are sRGB and data textures are linear
- [ ] Normal map convention matches the target
- [ ] Materials use plausible metallic, roughness, and base color values
- [ ] Geometry has consistent normals and clean UVs
- [ ] Draw calls, triangles, and texture memory fit the budget
- [ ] Resources are released when no longer used
- [ ] The result was rendered and looked at

## Reference files

Read the one for the tool in use and the examples file before the first change.

- [references/blender.md](references/blender.md) covers the bpy Python API, add-ons as extensions, headless runs, geometry nodes, and export.
- [references/unreal.md](references/unreal.md) covers UE5 C++ and Blueprints, asset naming, materials, Nanite, Lumen, MegaLights, and editor scripting.
- [references/web.md](references/web.md) covers three.js with WebGPU and TSL, React Three Fiber, Babylon.js, glTF loading and optimization, and web performance.
- [examples.md](examples.md) has illustrative code for each tool.
