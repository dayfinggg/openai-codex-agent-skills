# Web 3D

WebGPU is enabled by default in current Chrome, Edge, Safari, and Firefox on major platforms, but some devices and Linux setups still lack it, so keep a WebGL 2 fallback. three.js releases monthly and renames APIs often, so read the version in `package.json` and its migration notes.

## Contents

- Choosing a library
- three.js setup
- Shaders with TSL
- Loading glTF
- Optimizing assets
- Resource management
- React Three Fiber
- Performance

## Choosing a library

- **three.js** for custom scenes and the widest ecosystem.
- **React Three Fiber** with drei when the app is built in React.
- **Babylon.js** or **PlayCanvas** for game-like apps that want an engine with physics, inspector, and editor.
- **model-viewer** to show a single product model with minimal code.
- Raw **WebGPU** only for custom compute or rendering that libraries cannot express.

## three.js setup

- Import from `three/webgpu` and create `WebGPURenderer`, which falls back to WebGL 2 automatically. Use `WebGLRenderer` when the project depends on GLSL `ShaderMaterial` or WebGL-only add-ons.
- Call `await renderer.init()` before the first render with WebGPU, and drive frames with `renderer.setAnimationLoop`.
- Cap pixel ratio, as in `renderer.setPixelRatio(Math.min(devicePixelRatio, 2))`.
- Set `texture.colorSpace = THREE.SRGBColorSpace` on color textures loaded manually. Data textures stay linear. GLTFLoader sets these itself.
- Choose a tone mapping such as `THREE.AgXToneMapping` or `THREE.ACESFilmicToneMapping`, and light with an environment map, for example `RoomEnvironment` through `PMREMGenerator`, because PBR materials look flat without one.
- Resize the renderer and camera aspect on container resize, using a `ResizeObserver` on the canvas container.
- Render only when needed for static viewers, instead of every frame.

## Shaders with TSL

- Write custom shaders in TSL (three.js Shading Language), imported from `three/tsl`. It compiles to WGSL for WebGPU and GLSL for WebGL.
- Use node materials such as `MeshStandardNodeMaterial` and assign TSL nodes to properties like `colorNode` and `positionNode`.
- Use TSL compute nodes for GPU simulations such as particles instead of CPU loops.
- Keep `ShaderMaterial` with GLSL only on `WebGLRenderer`.

## Loading glTF

- Load with `GLTFLoader`, and attach decoders for compressed assets, `DRACOLoader` for Draco, `KTX2Loader` with `detectSupport(renderer)` for KTX2 textures, and `MeshoptDecoder` for meshopt.
- Serve decoder files from the app's own static path or a pinned CDN version.
- Show loading progress with `LoadingManager`, and handle load errors with a visible message.
- Reuse loaded assets by cloning (`SkeletonUtils.clone` for skinned meshes) instead of loading again.

## Optimizing assets

- Optimize every GLB before shipping with glTF Transform (`npx @gltf-transform/cli optimize`), which can deduplicate, weld, simplify, compress geometry with meshopt or Draco, and resize and compress textures. Check `--help` for the flags of the installed version.
- Prefer KTX2 with Basis Universal for textures, because it stays compressed on the GPU, while WebP and AVIF only shrink downloads.
- Keep texture sizes to what the screen needs, often 1024 or 2048 pixels at most.
- Ratified extensions three.js reads include `KHR_materials_*` (transmission, clearcoat, sheen, iridescence, anisotropy, emissive strength), `KHR_texture_transform`, `KHR_lights_punctual`, `KHR_mesh_quantization`, `KHR_texture_basisu`, and `EXT_meshopt_compression`. Gaussian splats in glTF (`KHR_gaussian_splatting`) are still a release candidate, so check loader support before relying on them.

## Resource management

- GPU resources are not garbage collected. Call `dispose()` on geometries, materials, textures, and render targets when removing them, and dispose the renderer when the canvas goes away.
- Remove event listeners and stop the animation loop on unmount.
- Check `renderer.info` for growing counts of geometries and textures, which reveal leaks.

## React Three Fiber

- Keep per-frame updates in `useFrame` that mutate refs, never `setState` per frame.
- Load models with `useGLTF` and preload them, and wrap them in `Suspense`.
- Use `frameloop="demand"` for static scenes and call `invalidate()` on change.
- Use drei helpers such as `Instances`, `Environment`, and `Bvh` rather than reimplementing them.

## Performance

- Use `InstancedMesh` for many copies of one mesh and `BatchedMesh` for many different meshes sharing a material.
- Merge static geometry and share materials to cut draw calls.
- Limit shadow-casting lights, set tight shadow camera bounds, and bake shadows or ambient occlusion into textures for static scenes.
- Use `three-mesh-bvh` for fast raycasting on complex meshes.
- Lower quality on weak devices, such as pixel ratio, shadows, and post-processing, based on measured frame time.
- Test on a mid-range phone, not only a desktop GPU.
