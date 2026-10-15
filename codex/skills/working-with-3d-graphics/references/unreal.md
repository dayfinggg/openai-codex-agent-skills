# Unreal Engine 5

Read the engine version from the `.uproject` file and follow that version's documentation. Unreal works in centimeters, Z up, left-handed.

## Contents

- C++ conventions
- C++ and Blueprints
- Gameplay structure
- Asset naming and folders
- Materials
- Rendering features
- Importing assets
- Editor scripting
- Performance

## C++ conventions

- Follow Epic's coding standard. Type prefixes are `A` for actors, `U` for other UObjects, `F` for structs and plain classes, `E` for enums, `I` for interfaces, `T` for templates, and `b` for booleans.
- Hold UObject references in member variables with `UPROPERTY()` and `TObjectPtr<T>`, so garbage collection tracks them.
- Use `TWeakObjectPtr` for references that must not keep an object alive, and `TSoftObjectPtr` or `TSoftClassPtr` for assets loaded on demand.
- Use Unreal containers and smart pointers (`TArray`, `TMap`, `TSharedPtr`, `TUniquePtr`) instead of the standard library equivalents for engine-facing code.
- Prefix output parameters with `Out`, and pass large structs by const reference.
- Create components in the constructor with `CreateDefaultSubobject`, and do gameplay setup in `BeginPlay`.
- Disable ticking (`PrimaryActorTick.bCanEverTick = false`) unless the actor needs it, and prefer timers or events.
- Check pointers with `IsValid()` before use, and log with `UE_LOG` on a project log category.
- Keep headers light with forward declarations, and include what each file uses.

## C++ and Blueprints

- Put systems, performance-critical logic, and reusable base classes in C++.
- Expose tunable values with `UPROPERTY(EditAnywhere, BlueprintReadOnly, Category = "...")` and callable logic with `UFUNCTION(BlueprintCallable)`.
- Let designers build content, layouts, and one-off behavior in Blueprints derived from C++ bases.
- Avoid heavy logic on Blueprint Tick and long Blueprint graphs, and move them into C++ or into functions.

## Gameplay structure

- Use the Gameplay Framework classes for their purpose, such as GameMode for rules on the server, GameState and PlayerState for replicated state, PlayerController for input, Pawn or Character for the controlled body.
- Use Enhanced Input with Input Actions and Input Mapping Contexts, not the legacy input bindings.
- Prefer components and interfaces over deep actor inheritance.
- For multiplayer, decide authority per feature, replicate state with `Replicated` or `ReplicatedUsing`, and validate client requests on the server.

## Asset naming and folders

Use prefixes from Epic's recommended naming conventions.

| Prefix | Asset |
|---|---|
| `SM_` | Static mesh |
| `SK_` | Skeletal mesh |
| `M_` | Material |
| `MI_` | Material instance |
| `MF_` | Material function |
| `T_` | Texture, with suffixes such as `_D` base color, `_N` normal, `_ORM` packed maps |
| `BP_` | Blueprint |
| `ABP_` | Animation Blueprint |
| `AS_` / `AM_` | Animation sequence / montage |
| `NS_` | Niagara system |
| `WBP_` | Widget Blueprint |

Group content by feature or asset family under the project folder, and never move or rename assets outside the editor, because references break.

## Materials

- Build a few master materials with parameters and use material instances for variations, which keeps shader compilation and draw cost down.
- Use material functions for shared logic.
- Use static switches sparingly, because each combination compiles a new shader permutation.
- Pack grayscale maps into ORM textures and set data textures to linear.
- Substrate is the newer layered material framework. Use it when the project has it enabled, and follow the project's choice.

## Rendering features

- **Nanite** virtualized geometry suits high-polygon static and, in recent versions, foliage meshes, removing manual LODs for them.
- **Lumen** provides dynamic global illumination and reflections. Lumen Lite in 5.8 trades quality for roughly double speed on weaker hardware.
- **MegaLights**, production-ready in 5.8, allows many shadowed dynamic lights.
- **Virtual Shadow Maps** pair with Nanite for detailed shadows.
- Pick features per target platform, and check the scalability settings for each.

## Importing assets

- Import meshes at correct scale with transforms applied in the source tool, and check them next to the mannequin.
- Set normal map compression to `Normalmap` and flip the green channel when the source uses the OpenGL convention.
- Use the Interchange import framework where the project uses it, and keep import settings consistent with saved presets.

## Editor scripting

- Use the Python editor scripting plugin for batch asset work, such as `unreal.EditorAssetLibrary` and `unreal.EditorAssetSubsystem`.
- Use Editor Utility Widgets or Blueprints for tools artists run themselves.
- Run scripts on a copy or under source control, because asset changes are hard to undo.

## Performance

- Profile with `stat unit`, `stat gpu`, and Unreal Insights before changing anything.
- Watch draw calls, shader complexity, overdraw from translucency, and the number of dynamic shadow casters.
- Use HLODs and World Partition for large worlds, and instanced static meshes for repeated objects.
