# Analyzers, formatters, and CI

- Enable the SDK's .NET analyzers and select an analysis level appropriate for the repository's migration stage.
- Configure style and severity in version-controlled `.editorconfig` or global analyzer configuration files.
- Escalate agreed correctness, reliability, security, and API-contract rules to build failures in CI.
- Do not blanket-suppress diagnostics. Scope each suppression and record its reason in the narrowest supported configuration or source directive; do not add prose comments when the tool or configuration can express the exception.
- Run `dotnet format` locally and `dotnet format --verify-no-changes` in CI when formatting is a repository contract.
- Treat formatter output as mechanical; review analyzer fixes for changed behavior before committing them.
- Use the verified dotnet/runtime layout and `Directory.Build.props` as examples, not as a universal configuration to copy unchanged.
- A normal validation pass is `dotnet restore`, `dotnet build`, `dotnet test`, and formatter verification.
