# Web runtime and interaction

## Integrate the existing renderer

Identify who owns the canvas, scene, camera, render loop, application state, and GPU resources. Follow the existing framework's mount/update/unmount model. Avoid a second renderer or competing animation loop. Keep core and addon imports on the project's installed version and existing module conventions.

For Three.js, consult [WebGLRenderer](https://threejs.org/docs/pages/WebGLRenderer.html) and [WebGPURenderer](https://threejs.org/docs/pages/WebGPURenderer.html). Current WebGLRenderer targets WebGL 2. WebGPURenderer can choose WebGPU or a WebGL 2 backend. Check initialization, device support, shader/material compatibility, and actual backend for the installed release. Do not silently drop a requested WebGPU-only behavior through fallback or force a migration for an ordinary scene.

Create spatial scene objects with intentional units, parent transforms, origins, and camera framing. Keep near/far clipping appropriate to the scene. Resize from the canvas container, update the camera projection, and distinguish CSS size from drawing-buffer size. Handle zero-size containers and device pixel ratio changes without recreating the scene.

Track loading and failure for real assets, including dependent images and decoders. Keep paths, content types, cross-origin permissions, and asset licensing correct. Do not mask a failed asset with a placeholder and call the requested model complete.

## Implement requested interaction

Choose only interactions the task needs: orbit, navigation, picking, dragging, configuration, or scene-specific actions. Preserve page scrolling and touch behavior outside the canvas. Provide focus, keyboard alternatives, and accessible descriptions for meaningful actions when applicable. Do not assume a game needs physics unless its behavior requires it.

For Three.js picking, map pointer coordinates using the canvas bounds, not window dimensions, and use [Raycaster](https://threejs.org/docs/pages/Raycaster.html) with the active camera. Filter targets deliberately and translate hit objects into stable application identities. Test selection after camera changes, resize, and nested transforms.

Use [OrbitControls](https://threejs.org/docs/pages/OrbitControls.html) only for a requested or appropriate camera interaction. Its damping and auto-rotation require updates. Avoid camera automation fighting direct user control, and verify limits and reset behavior.

## Animate real state

Use elapsed time or delta seconds, not frame counts, for time-based motion. Respect the existing loop and avoid frame-by-frame framework rerenders for every transform. Clamp or reset large resume deltas. Use fixed-step simulation only where the behavior needs consistent integration.

For imported clips, check names, durations, target bindings, loop modes, and transitions. [AnimationMixer](https://threejs.org/docs/pages/AnimationMixer.html) advances animation through `update(deltaTime)` in seconds. Verify changing transforms, bone poses, morph weights, or meaningful scene state at distinct times, plus requested pause/resume and transitions. A rotating camera does not prove the model animates.
