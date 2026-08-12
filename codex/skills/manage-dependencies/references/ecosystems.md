# Ecosystem Routing

Read the row for each ecosystem present. Prefer repository wrappers and declared tools over globally installed alternatives.

| Ecosystem | Sources of truth | Inspection and targeted change | Relevant validation |
| --- | --- | --- | --- |
| JavaScript and TypeScript | `package.json`, its `packageManager` field, workspace configuration, and the matching npm, Yarn, pnpm, or Bun lockfile | Use the declared manager to inspect the resolved graph and update only named packages | Reproducible install, lint, type checks, tests, and build configured by the repository |
| Python | `pyproject.toml`, `setup.cfg`, `setup.py`, requirement files, environment markers, and the configured lockfile | Use the configured Poetry, PDM, uv, pip-tools, pip, or framework workflow without introducing a second manager | Locked environment synchronization, package build when applicable, static checks, and tests |
| Rust | `Cargo.toml`, workspace metadata, feature declarations, and `Cargo.lock` according to repository policy | Use Cargo metadata and dependency-tree inspection; target named packages and deliberate feature changes | Cargo checks, tests, clippy or formatting when configured, and affected feature or target combinations |
| Go | `go.mod`, `go.sum`, `go.work`, replacements, exclusions, and toolchain directives | Inspect module versions and the module graph; avoid broad tidy or upgrade changes unless their full diff is intended | Module verification, repository tests, vet or static checks, and builds for affected targets |
| .NET | Project files, `Directory.Packages.props`, `global.json`, NuGet configuration, central version policy, and lockfiles | Use the repository's .NET or NuGet workflow and respect central package management | Restore, configured analyzers, build, tests, and runtime-specific checks |
| JVM | Maven POMs or Gradle settings and build files, wrappers, version catalogs, dependency constraints, and lock state | Use the checked-in wrapper when present; inspect dependency trees and update the narrow declaration or catalog entry | Dependency resolution, compilation, configured quality checks, tests, and packaging |
| Ruby | `Gemfile`, gem specifications, Ruby version declarations, Bundler configuration, and `Gemfile.lock` | Use Bundler to inspect and update only the named gems and required transitive dependencies | Locked install, configured static checks, tests, and application boot or packaging checks |
| PHP | `composer.json`, platform constraints, repository declarations, plugins, and `composer.lock` | Use Composer validation and a named-package update; include dependent packages only when required and reviewed | Locked install, configured analysis, tests, and application or package build checks |
| C and C++ | Existing vcpkg, Conan, CMake, Meson, Bazel, or repository-specific declarations and lock state | Preserve the selected dependency mechanism, profiles, triplets, toolchain files, and binary-source policy | Clean configure, compile, tests, and affected platform or ABI checks |

If an ecosystem is not listed, infer the same four anchors from repository evidence: declaration source, resolver state, targeted mutation mechanism, and reproducible validation path.
