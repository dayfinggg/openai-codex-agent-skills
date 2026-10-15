# 3D examples

These examples are illustrative. Check them against the versions the project uses.

## Contents

- three.js scene with WebGPU and glTF
- TSL material
- Blender headless export script
- Unreal actor in C++

## three.js scene with WebGPU and glTF

```javascript
import * as THREE from "three/webgpu";
import { GLTFLoader } from "three/addons/loaders/GLTFLoader.js";
import { KTX2Loader } from "three/addons/loaders/KTX2Loader.js";
import { MeshoptDecoder } from "three/addons/libs/meshopt_decoder.module.js";
import { RoomEnvironment } from "three/addons/environments/RoomEnvironment.js";
import { OrbitControls } from "three/addons/controls/OrbitControls.js";

export async function createViewer(container, modelUrl) {
  const renderer = new THREE.WebGPURenderer({ antialias: true });
  renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
  renderer.toneMapping = THREE.AgXToneMapping;
  container.append(renderer.domElement);
  await renderer.init();

  const scene = new THREE.Scene();
  const pmrem = new THREE.PMREMGenerator(renderer);
  scene.environment = pmrem.fromScene(new RoomEnvironment()).texture;

  const camera = new THREE.PerspectiveCamera(45, 1, 0.1, 100);
  camera.position.set(2, 1.5, 3);
  const controls = new OrbitControls(camera, renderer.domElement);
  controls.enableDamping = true;

  const ktx2 = new KTX2Loader().setTranscoderPath("/basis/").detectSupport(renderer);
  const loader = new GLTFLoader().setKTX2Loader(ktx2).setMeshoptDecoder(MeshoptDecoder);
  const gltf = await loader.loadAsync(modelUrl);
  scene.add(gltf.scene);

  const resize = () => {
    const { clientWidth: width, clientHeight: height } = container;
    renderer.setSize(width, height);
    camera.aspect = width / height;
    camera.updateProjectionMatrix();
  };
  const observer = new ResizeObserver(resize);
  observer.observe(container);
  resize();

  renderer.setAnimationLoop(() => {
    controls.update();
    renderer.render(scene, camera);
  });

  return function dispose() {
    renderer.setAnimationLoop(null);
    observer.disconnect();
    controls.dispose();
    scene.traverse((object) => {
      if (!object.isMesh) return;
      object.geometry.dispose();
      for (const material of [object.material].flat()) {
        for (const value of Object.values(material)) {
          if (value?.isTexture) value.dispose();
        }
        material.dispose();
      }
    });
    scene.environment.dispose();
    pmrem.dispose();
    ktx2.dispose();
    renderer.dispose();
    renderer.domElement.remove();
  };
}
```

The viewer lights PBR materials with an environment map, caps pixel ratio, decodes compressed assets, and releases every GPU resource when disposed.

## TSL material

```javascript
import * as THREE from "three/webgpu";
import { color, mix, positionLocal, sin, time, uniform } from "three/tsl";

const speed = uniform(1.5);
const material = new THREE.MeshStandardNodeMaterial({ roughness: 0.4 });
const wave = sin(positionLocal.y.mul(6).add(time.mul(speed))).mul(0.5).add(0.5);
material.colorNode = mix(color("#1d4ed8"), color("#f59e0b"), wave);
```

The same material renders through WebGPU or the WebGL fallback, and `speed.value` changes the animation from JavaScript.

## Blender headless export script

```python
import sys
from pathlib import Path

import bpy


def parse_output_path() -> Path:
    args = sys.argv[sys.argv.index("--") + 1:] if "--" in sys.argv else []
    if len(args) != 1:
        raise SystemExit("Usage: blender -b file.blend --python export.py -- out.glb")
    return Path(args[0]).resolve()


def check_scene() -> None:
    problems = []
    for obj in bpy.data.objects:
        if obj.type != "MESH":
            continue
        if any(abs(s - 1.0) > 1e-4 for s in obj.scale):
            problems.append(f"{obj.name}: unapplied scale {tuple(obj.scale)}")
        if not obj.data.uv_layers:
            problems.append(f"{obj.name}: no UV map")
    if problems:
        raise SystemExit("Scene check failed:\n" + "\n".join(problems))


def export_glb(path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    bpy.ops.export_scene.gltf(
        filepath=str(path),
        export_format="GLB",
        export_apply=True,
        export_yup=True,
    )


output = parse_output_path()
check_scene()
export_glb(output)
print(f"Exported {output}")
```

Run it with `blender -b scene.blend --python export.py -- dist/scene.glb`. The script stops with a clear message instead of exporting a broken asset.

## Unreal actor in C++

```cpp
#pragma once

#include "CoreMinimal.h"
#include "GameFramework/Actor.h"
#include "RotatingPickup.generated.h"

class UStaticMeshComponent;
class USoundBase;

UCLASS()
class MYGAME_API ARotatingPickup : public AActor
{
    GENERATED_BODY()

public:
    ARotatingPickup();

protected:
    virtual void Tick(float DeltaSeconds) override;

    UFUNCTION()
    void HandleOverlap(AActor* OverlappedActor, AActor* OtherActor);

    UPROPERTY(VisibleAnywhere, Category = "Pickup")
    TObjectPtr<UStaticMeshComponent> Mesh;

    UPROPERTY(EditAnywhere, BlueprintReadOnly, Category = "Pickup", meta = (ClampMin = "0"))
    float RotationDegreesPerSecond = 90.f;

    UPROPERTY(EditAnywhere, Category = "Pickup")
    TSoftObjectPtr<USoundBase> PickupSound;
};
```

```cpp
#include "RotatingPickup.h"

#include "Components/StaticMeshComponent.h"
#include "Kismet/GameplayStatics.h"
#include "Sound/SoundBase.h"

ARotatingPickup::ARotatingPickup()
{
    PrimaryActorTick.bCanEverTick = true;
    Mesh = CreateDefaultSubobject<UStaticMeshComponent>(TEXT("Mesh"));
    SetRootComponent(Mesh);
    Mesh->SetGenerateOverlapEvents(true);
    OnActorBeginOverlap.AddDynamic(this, &ARotatingPickup::HandleOverlap);
}

void ARotatingPickup::Tick(float DeltaSeconds)
{
    Super::Tick(DeltaSeconds);
    AddActorLocalRotation(FRotator(0.f, RotationDegreesPerSecond * DeltaSeconds, 0.f));
}

void ARotatingPickup::HandleOverlap(AActor* OverlappedActor, AActor* OtherActor)
{
    if (!IsValid(OtherActor) || !OtherActor->IsA<APawn>())
    {
        return;
    }
    if (USoundBase* Sound = PickupSound.LoadSynchronous())
    {
        UGameplayStatics::PlaySoundAtLocation(this, Sound, GetActorLocation());
    }
    Destroy();
}
```

The component is tracked by garbage collection through `TObjectPtr`, designers tune the speed in the editor, and the sound loads only when needed.
