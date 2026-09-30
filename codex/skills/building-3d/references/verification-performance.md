# Verification, performance, and lifecycle

## Verify the real changed path

Run existing project checks and exercise the scene in its actual runtime when available. Check asset requests, console and shader errors, canvas resize, camera framing, and supported device/backend behavior. For exported models, validate structure and load the real artifact in its intended consumer.

Test requested input and assert observable outcomes: selected identity, changed material or configuration, camera transform, animation pose, or scene state. Observe movement at multiple times, including pause/resume, reset, and transitions where requested. Test touch or keyboard paths when they are part of the requirement. Screenshots are visual evidence, not proof that these behaviors work.

## Measure before optimizing

Use the user's target or project budgets, not invented universal polygon or FPS limits. Record runtime version, browser, device/GPU where available, backend, viewport, pixel ratio, quality settings, workload, warm-up, and sampling duration. Measure a representative loaded scene during relevant motion and interaction, not only an empty or idle view.

Separate loading, decode, upload, shader compilation, CPU update, frame intervals, and GPU execution. Report distributions or percentiles and stutters when useful, not just an average FPS. A `requestAnimationFrame` interval reflects frame pacing, not isolated GPU duration. CPU timing around a render submission does not measure completed GPU work. Use supported asynchronous GPU timing tools only when available, handle invalid/disjoint samples, and state when GPU time is unknown.

[WebGLRenderer](https://threejs.org/docs/pages/WebGLRenderer.html) exposes `info` counters for draw calls, triangles, textures, and geometries. Account for all passes when collecting counters. These counts do not equal total GPU memory bytes or frame time. A screenshot, successful build, or subjective smoothness cannot establish a performance improvement.

Compare before/after under equivalent conditions and change the measured bottleneck: draw-call batching or instancing, culling and level of detail, geometry complexity, texture resolution/compression, allocations, shadow cost, pixel ratio, transparency overdraw, or post-processing. Preserve requested appearance and behavior. Do not add a benchmark harness unless the task calls for it.

## Own and release resources

Track shared versus exclusively owned resources. Scene removal alone does not release GPU allocations. Stop the owned render loop, remove listeners, disconnect observers, and dispose controls, owned geometries, materials, textures, render targets, and renderer resources using the installed engine's API. Release mixer bindings after stopping actions. Do not dispose shared assets still used elsewhere.

Prevent asynchronous loads from updating an unmounted scene. Cancel work where supported, otherwise discard and safely release late results. Pause unnecessary work when hidden if compatible with the task, and handle resume deltas. Test repeated mount/unmount or scene replacement for duplicate loops, listeners, and growing resource counts. Distinguish legitimate caches from leaks instead of demanding every counter reach zero.

Report what was checked, the measurements actually collected, and unavailable browser, GPU, authoring, or validation capabilities. Do not replace missing evidence with a claim of success.
