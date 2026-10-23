---
name: working-with-3d-graphics
description: Builds and reviews 3D work in Blender, Unreal Engine 5, three.js, React Three Fiber, Babylon.js, and glTF. Use for scenes, shaders, materials, models, animation, rendering, or a scene that looks or runs wrong.
---

# Working with 3D graphics

APIs here change quickly. Before writing code, read the version in use, such as `bpy.app.version`, the engine version in the `.uproject`, or `three` in `package.json`, and follow that version's documentation rather than recalled APIs.

## Coordinates and units

| Tool | Up axis | Handedness | Unit |
|---|---|---|---|
| Blender | Z | Right-handed | 1 unit = 1 meter by default |
| glTF 2.0 | Y | Right-handed, front faces +Z | Meters |
| three.js, Babylon.js (glTF loaded) | Y | Right-handed | Meters by convention |
| Unreal Engine | Z | Left-handed | 1 unit = 1 centimeter |

Model at real-world scale in meters and let exporters convert. Check imported size against a known reference, such as a 1.8 meter human or the UE mannequin. Apply rotation and scale before export, and place pivots where the object rotates or rests.

## Materials and color

- Use the metallic-roughness model. Metallic is 0 or 1 for almost every surface, with values between only for transitions such as dirt on metal.
- Base color of non-metals stays roughly between 30 and 240 in sRGB.
- Vary roughness with texture, since it carries most of the realism.
- glTF and three.js read occlusion, roughness, and metallic from the red, green, and blue channels (ORM).
- Color textures (base color, emissive) are sRGB. Data textures (normal, roughness, metallic, occlusion, height) are linear, called Non-Color in Blender and sRGB unchecked in Unreal.
- Normal maps use the OpenGL convention (green up) in Blender, glTF, and three.js, and DirectX (green down) in Unreal. Flip the green channel or set the importer option when moving between them.
- Tone map HDR lighting with AgX in Blender, ACES, AgX, or Neutral in three.js, and the default filmic tone mapper in Unreal, and keep one choice per project.

## Performance and exchange

- Set budgets for the target device before building, and profile with the tool's own profiler first, such as Unreal Insights, the browser performance panel, or three.js `renderer.info`.
- Size textures to their on-screen size, with power-of-two dimensions, mipmaps, and GPU compression, KTX2 with Basis Universal on the web and BC formats in engines.
- Use GLB for web and real-time delivery, compressed with meshopt or Draco geometry and KTX2 textures. FBX stays common for meshes and animation into Unreal, and OpenUSD suits large layered studio scenes.
- Keep source files separate from exports, and make export repeatable with a script or saved settings.

## Verify visually

A 3D change is checked only when its image is. Render or screenshot the result with a headless Blender render to PNG, a browser screenshot, or a high resolution screenshot from Unreal, compare it with the expected look, check the frame rate on the target device class, and say what was and was not verified.

## Reference files

Read the file for the tool in use before the first change.

- [reference/blender.md](reference/blender.md) for bpy scripting, Blender 5.0 API changes, extensions, headless runs, and export.
- [reference/unreal.md](reference/unreal.md) for UE5 C++ and Blueprints, asset naming, materials, rendering features, and editor scripting.
- [reference/web.md](reference/web.md) for three.js with WebGPU and TSL, React Three Fiber, glTF loading and optimization, and resource disposal.
