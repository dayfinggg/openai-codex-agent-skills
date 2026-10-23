# Unreal Engine 5

Read the engine version from the `.uproject` file and follow that version's documentation.

## C++ and Blueprints

- Follow Epic's coding standard, with prefixes `A` for actors, `U` for other UObjects, `F` for structs and plain classes, `E` for enums, `I` for interfaces, `T` for templates, and `b` for booleans. Output parameters start with `Out`.
- Hold UObject references in `UPROPERTY()` members as `TObjectPtr<T>` so garbage collection tracks them. Use `TWeakObjectPtr` for references that must not keep an object alive, and `TSoftObjectPtr` or `TSoftClassPtr` for assets loaded on demand.
- Use Unreal containers and smart pointers (`TArray`, `TMap`, `TSharedPtr`, `TUniquePtr`) in engine-facing code.
- Create components in the constructor with `CreateDefaultSubobject`, and do gameplay setup in `BeginPlay`.
- Set `PrimaryActorTick.bCanEverTick = false` unless the actor needs ticking, and prefer timers or events.
- Check pointers with `IsValid()`, and log with `UE_LOG` on a project log category.
- Put systems and performance-critical logic in C++, expose tunables with `UPROPERTY(EditAnywhere, BlueprintReadOnly, Category = "...")` and logic with `UFUNCTION(BlueprintCallable)`, and let designers build content in Blueprints derived from those bases.
- Use Enhanced Input with Input Actions and Input Mapping Contexts. For multiplayer, replicate state with `Replicated` or `ReplicatedUsing` and validate client requests on the server.

## Asset naming

Prefixes from Epic's recommended naming conventions.

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

Move and rename assets only inside the editor, because references break otherwise.

## Materials

- Build a few master materials with parameters and use material instances for variations.
- Use static switches sparingly, because each combination compiles a new shader permutation.
- Use Substrate, the layered material framework, when the project has it enabled.

## Rendering features

- **Nanite** suits high-polygon static meshes and, in recent versions, foliage, replacing manual LODs for them.
- **Lumen** provides dynamic global illumination and reflections. Lumen Lite, in beta in 5.8, is about twice as fast as Lumen high quality.
- **MegaLights**, production-ready in 5.8, allows many shadowed dynamic lights.
- **Virtual Shadow Maps** pair with Nanite.
- Pick features per target platform, and check the scalability settings for each.

## Importing

- Import at correct scale with transforms applied in the source tool, and check next to the mannequin.
- Set normal map compression to `Normalmap`, and flip the green channel for OpenGL-convention sources.
- Use the Interchange import framework where the project uses it, with saved presets.

## Editor scripting

- Use the Python editor scripting plugin for batch asset work, such as `unreal.EditorAssetLibrary` and `unreal.EditorAssetSubsystem`, and Editor Utility Widgets for tools artists run.
- Run scripts on a copy or under source control, because asset changes are hard to undo.

## Performance

- Profile with `stat unit`, `stat gpu`, and Unreal Insights before changing anything.
- Use HLODs and World Partition for large worlds, and instanced static meshes for repeated objects.
