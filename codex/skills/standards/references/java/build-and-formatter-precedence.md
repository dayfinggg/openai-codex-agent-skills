# Build and formatter precedence

- Inspect the project build files, wrapper, toolchain declaration, CI workflow, and formatter configuration before editing code.
- Use the repository's Maven or Gradle wrapper when one exists.
- For Maven, run the project-selected verification phase, commonly mvn verify.
- For Gradle, run the project-selected lifecycle, commonly check for verification and build for assembly plus verification.
- Attach custom test, lint, and formatter checks to the build lifecycle so CI runs them.
- Precedence is repository formatter and CI, project style guide, this reference, IDE settings, then personal preference.
- Pin formatter and analysis versions, and run them with a JDK that can parse the project's source level.
- Choose one formatter for Java source and do not mix competing formatters in the same module.
- Run format checks in CI and format only files intentionally changed by the task.
- Treat compiler warnings, tests, static analysis, packaging, and documentation checks as merge gates when the project does.
- Keep wrapper versions and toolchains reproducible, and document any local-only command.
- Add a narrow suppression only with a reason, owner, and removal condition.
