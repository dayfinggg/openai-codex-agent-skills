# Configuration and secrets
- Use environment variables for deployment-specific infrastructure values and named config for application behavior.
- Read `env()` only from configuration files and use `config()` from application code.
- Verify `config:cache` in deployment because cached configuration stops loading `.env` values during requests.
- Keep secrets in the deployment secret store, encrypted environment, or a dedicated secret service.
- Never commit production keys, tokens, database passwords, or diagnostic dumps.
