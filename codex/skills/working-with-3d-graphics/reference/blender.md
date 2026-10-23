# Blender

Blender 5.x bundles Python 3.13 from 5.1. Check `bpy.app.version` and that version's release notes, because major releases remove APIs.

## Scripting rules

- Prefer the data API (`bpy.data`, object and mesh properties, `bmesh`) over `bpy.ops`, whose operators depend on context, selection, and mode and are slow in loops. Give an unavoidable operator its context with `bpy.context.temp_override(...)`.
- Create meshes with `mesh.from_pydata(vertices, edges, faces)` and `mesh.update()`, or edit with `bmesh`, then `bm.to_mesh(mesh)` and `bm.free()`. Link new objects with `collection.objects.link(obj)`.
- Use `foreach_get` and `foreach_set` with NumPy arrays for bulk vertex or attribute work.
- Read evaluated data, with modifiers applied, through `obj.evaluated_get(depsgraph)`.
- Look Blender data up again by name after undo or file reload instead of keeping Python references.
- Unregister classes in reverse order of registration.
- Define custom properties with `bpy.props` and access them as attributes.

## Changes in Blender 5.0

- Properties defined with `bpy.props` are no longer reachable through dictionary syntax such as `scene["cycles"]`.
- `bgl` is gone, so draw with the `gpu` module.
- The EEVEE engine identifier is `BLENDER_EEVEE`.
- The compositor's `scene.node_tree` is replaced by `scene.compositing_node_group`.
- The legacy action API (`action.fcurves`, `action.groups`) is removed. Animation data lives in layered actions, reached through channelbags, with helpers in `bpy_extras.anim_utils`.
- Several render pass names are spelled out, such as `Diffuse Color` instead of `DiffCol`.

## Add-ons as extensions

Since Blender 4.2, add-ons ship as extensions with a `blender_manifest.toml` next to `__init__.py`.

```toml
schema_version = "1.0.0"
id = "my_tool"
version = "1.0.0"
name = "My Tool"
tagline = "Short description of what it does"
maintainer = "Name <email@example.com>"
type = "add-on"
blender_version_min = "4.2.0"
license = ["SPDX:GPL-3.0-or-later"]
```

- Build with `blender --command extension build` inside the add-on folder, and validate with `blender --command extension validate`.
- Bundle third-party Python packages as wheels listed in the manifest instead of installing them into Blender's Python at runtime.
- Declare permissions such as `files` or `network` with a reason when the add-on needs them, and use relative imports.

## Running headless

```bash
blender -b scene.blend --python script.py -- --output out.glb
```

- Arguments after `--` reach the script through `sys.argv`.
- Render a still with `-o //render_ -F PNG -f 1` and look at the image.
- Exit with a non-zero code on failure, so pipelines notice.

## Geometry nodes

Prefer geometry nodes over Python for procedural geometry an artist will tweak, with named, ranged inputs on the group interface and named attributes for data passed between nodes and to export.

## Export

- glTF with `bpy.ops.export_scene.gltf(export_format='GLB', export_apply=True)`, with Y-up conversion left on.
- FBX for Unreal with apply transform and correct unit scale, then check size in the engine.
- Materials export as Principled BSDF with image textures connected directly. Bake complex node setups to textures.
- Pack or relativize texture paths so exports reference no local absolute paths.
