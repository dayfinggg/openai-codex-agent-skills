# Configuration and options

- Use `appsettings.json` for non-secret defaults and environment-specific files only for environment differences.
- Remember that later configuration providers override earlier values; the standard order places environment variables and command-line arguments above JSON files.
- Use `__` for hierarchical environment-variable keys when portability matters.
- Bind related settings to typed options classes instead of reading arbitrary string keys throughout the codebase.
- Validate required options with data annotations or `IValidateOptions<T>` and call `ValidateOnStart()` when invalid startup configuration should fail fast.
- Keep configuration access near the service that owns the setting and expose only the values that service needs.
- Never commit passwords, tokens, certificates, or production secrets to configuration files or source control.
- Use Secret Manager for development and a suitable managed secret store or environment mechanism for deployment.
