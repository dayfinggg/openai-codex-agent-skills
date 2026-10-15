# Blender

Blender 5.x bundles Python 3.13 (from 5.1). Check `bpy.app.version` and the release notes of that version, because major releases remove old APIs.

## Contents

- Scripting rules
- Changes in Blender 5.0 to know
- Add-ons as extensions
- Running headless
- Geometry nodes and procedural work
- Export

## Scripting rules

- Prefer the data API (`bpy.data`, object and mesh properties, `bmesh`) over operators (`bpy.ops`). Operators depend on context, selection, and mode, and are slow in loops.
- When an operator is unavoidable, give it the context it needs with `bpy.context.temp_override(...)`.
- Create meshes with `mesh.from_pydata(vertices, edges, faces)` followed by `mesh.update()`, or with `bmesh` for editing, then `bm.to_mesh(mesh)` and `bm.free()`.
- Link new objects to a collection, as in `collection.objects.link(obj)`.
- Use `foreach_get` and `foreach_set` with NumPy arrays for bulk vertex or attribute work.
- Read evaluated data, such as modifiers applied, through `obj.evaluated_get(depsgraph)`.
- Never keep Python references to Blender data across undo or file reload, look items up again by name.
- Register classes in `register()` and unregister them in reverse order in `unregister()`.
- Define custom properties with `bpy.props` on types, and access them as attributes, not with dictionary syntax.

## Changes in Blender 5.0 to know

- Properties defined with `bpy.props` are no longer reachable through dictionary syntax such as `scene["cycles"]`.
- The `bgl` module is gone, use the `gpu` module for drawing.
- The EEVEE engine identifier is `BLENDER_EEVEE`.
- `scene.node_tree` for the compositor is replaced by `scene.compositing_node_group`.
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

- Build the package with `blender --command extension build` inside the add-on folder, and validate with `blender --command extension validate`.
- Bundle third-party Python packages as wheels listed in the manifest, never install them into Blender's Python at runtime.
- Declare permissions such as `files` or `network` when the add-on needs them, with a reason.
- Use relative imports inside the package.

## Running headless

```bash
blender -b scene.blend --python script.py -- --output out.glb
```

- `-b` runs without UI. Arguments after `--` reach the script through `sys.argv`.
- Render a still with `-o //render_ -F PNG -f 1`, and inspect the image to verify the result.
- Exit with a non-zero code on failure, so pipelines notice errors.

## Geometry nodes and procedural work

- Prefer geometry nodes over Python for procedural geometry the artist will tweak, because they stay editable and non-destructive.
- Expose meaningful inputs on the node group interface with clear names, defaults, and ranges.
- Use named attributes to pass data between nodes and to export.
- Script the creation of node groups only when they must be generated, and keep the generated layout readable.

## Export

- glTF through `bpy.ops.export_scene.gltf`, with `export_format='GLB'`, `export_apply=True` to apply modifiers, and Y-up conversion left on.
- FBX for Unreal with apply transform and correct unit scale, then check size in the engine.
- Check that materials export as Principled BSDF with image textures connected directly, because complex node setups do not survive export. Bake them to textures when needed.
- Pack or relativize texture paths so exports do not reference local absolute paths.
