# Universal structure examples

These trees are illustrative. The toolchain and existing repository conventions decide the actual names and locations.

## Small project

```text
project/
  README
  project-manifest
  source-or-package/
  tests/
  docs/
  scripts/
  build-output/
```

Keep `build-output/` ignored or outside the repository. Omit directories that the project does not need.

## Multiple applications or packages

```text
project/
  workspace-manifest
  apps-or-commands/
    application-a/
    application-b/
  packages-or-libraries/
    shared-validation/
  tests-or-checks/
  docs/
```

Use this shape only when the applications or packages are independently buildable, testable, owned, or released. A repeated code fragment alone does not justify a shared package. Declare dependency direction in the workspace or build system.

## Feature slice

```text
feature/
  public-entrypoint
  domain-behavior
  external-adapter
  feature-tests
```

Use a feature slice when a change repeatedly crosses technical layers and keeping the related behavior together improves locality. Do not create empty layer folders for a feature that has one file.

## Derived files

```text
repository/
  source-of-truth/
  generated-output/
  build-cache/
external-secret-store/
```

The source of truth belongs in version control when required. Generated output and caches are ignored or external by default. Track generated output only when repository or distribution policy explicitly requires it, and never edit it manually. Live secrets stay in an external secret store. Reproducible output also depends on configuration, dependency versions, environment assumptions, and deterministic generation.
