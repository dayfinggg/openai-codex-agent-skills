# Project layout and build files

- A useful default layout is `src/` for production projects, `tests/` for test projects, and `docs/` or `eng/` for supporting material.
- Keep one clear responsibility per project; keep unit tests separate from integration or end-to-end tests.
- Put repository-wide `.editorconfig`, `Directory.Build.props`, and `Directory.Build.targets` at the intended common root.
- Remember that MSBuild applies the first applicable `Directory.Build.props` found while walking upward, so keep nested overrides explicit.
- Use SDK-style projects and rely on the SDK's default source globs unless a deliberate include or exclude is needed.
- Do not duplicate implicit `Compile`, resource, or content items; duplicate globs can fail the build.
- Keep project references directional: tests may reference production, while production should not reference tests.
- Pin or document the SDK and target frameworks, and update them deliberately with CI and dependency checks.
