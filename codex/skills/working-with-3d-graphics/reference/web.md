# Web 3D

WebGPU is not yet on by default everywhere, Linux most of all, so keep a WebGL 2 fallback. three.js releases monthly and renames APIs often, so read the version in `package.json` and its migration notes.

## Choosing a library

- **three.js** for custom scenes and the widest ecosystem.
- **React Three Fiber** with drei when the app is built in React.
- **Babylon.js** or **PlayCanvas** for game-like apps that want physics, an inspector, and an editor.
- **model-viewer** to show a single product model.
- Raw **WebGPU** only for compute or rendering that libraries cannot express.

## three.js setup

- Import from `three/webgpu` and create `WebGPURenderer`, which falls back to WebGL 2 by itself. Use `WebGLRenderer` when the project depends on GLSL `ShaderMaterial` or WebGL-only add-ons.
- Call `await renderer.init()` before the first WebGPU render, and drive frames with `renderer.setAnimationLoop`.
- Cap pixel ratio with `renderer.setPixelRatio(Math.min(devicePixelRatio, 2))`.
- Set `texture.colorSpace = THREE.SRGBColorSpace` on manually loaded color textures. GLTFLoader sets color spaces itself.
- Light PBR materials with an environment map, for example `RoomEnvironment` through `PMREMGenerator`, because they look flat without one.
- Resize with a `ResizeObserver` on the canvas container, and render static viewers only on change.

## Shaders with TSL

Write custom shaders in TSL from `three/tsl`, which compiles to WGSL for WebGPU and GLSL for WebGL. Assign nodes to node material properties such as `colorNode` and `positionNode`, and use TSL compute nodes for GPU simulations. GLSL `ShaderMaterial` works only on `WebGLRenderer`.

```javascript
import * as THREE from "three/webgpu";
import { color, mix, positionLocal, sin, time, uniform } from "three/tsl";

const speed = uniform(1.5);
const material = new THREE.MeshStandardNodeMaterial({ roughness: 0.4 });
const wave = sin(positionLocal.y.mul(6).add(time.mul(speed))).mul(0.5).add(0.5);
material.colorNode = mix(color("#1d4ed8"), color("#f59e0b"), wave);
```

## Loading glTF

- Attach decoders to `GLTFLoader`, `DRACOLoader` for Draco, `KTX2Loader` with `detectSupport(renderer)` for KTX2, and `MeshoptDecoder` for meshopt.
- Serve decoder files from the app's own static path or a pinned CDN version.
- Show progress with `LoadingManager` and a visible message on load errors.
- Clone loaded assets instead of loading again, with `SkeletonUtils.clone` for skinned meshes.

## Optimizing assets

- Optimize every GLB before shipping with glTF Transform (`npx @gltf-transform/cli optimize`), and check `--help` for the flags of the installed version.
- Prefer KTX2 with Basis Universal for textures, because it stays compressed on the GPU, while WebP and AVIF only shrink downloads. Texture sizes are often 1024 or 2048 pixels at most.
- Ratified extensions three.js reads include `KHR_materials_*` (transmission, clearcoat, sheen, iridescence, anisotropy, emissive strength), `KHR_texture_transform`, `KHR_lights_punctual`, `KHR_mesh_quantization`, `KHR_texture_basisu`, and `EXT_meshopt_compression`. Check loader support before relying on Gaussian splats (`KHR_gaussian_splatting`).

## Resource management

GPU resources are not garbage collected. Call `dispose()` on geometries, materials, their textures, render targets, the PMREM generator, and loaders when removing them, and dispose the renderer and stop the animation loop with `setAnimationLoop(null)` when the canvas goes away. Growing geometry and texture counts in `renderer.info` reveal leaks.

## React Three Fiber

- Mutate refs inside `useFrame` instead of calling `setState` per frame.
- Load models with `useGLTF`, preload them, and wrap them in `Suspense`.
- Use `frameloop="demand"` for static scenes and call `invalidate()` on change.
- Use drei helpers such as `Instances`, `Environment`, and `Bvh`.

## Performance

- `InstancedMesh` for many copies of one mesh, `BatchedMesh` for many meshes sharing a material.
- Tight shadow camera bounds, few shadow-casting lights, and baked shadows or ambient occlusion for static scenes.
- `three-mesh-bvh` for raycasting on complex meshes.
- Lower pixel ratio, shadows, and post-processing on weak devices based on measured frame time, and test on a mid-range phone.
