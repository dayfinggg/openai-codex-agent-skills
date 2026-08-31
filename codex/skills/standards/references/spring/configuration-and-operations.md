# Configuration and operations
- Keep deploy-time values outside the artifact and provide safe defaults only for local development.
- Use external properties, YAML, environment variables, and command-line overrides intentionally.
- Bind related settings into typed `@ConfigurationProperties` objects and validate them during startup.
- Know property-source precedence before diagnosing an unexpected value.
- Store secrets in a secret manager or environment injection, never in committed configuration or logs.
- Expose only the management endpoints that operators need and secure sensitive endpoints separately.
- Keep Actuator management traffic on a controlled interface, port, or security chain when the deployment requires it.
