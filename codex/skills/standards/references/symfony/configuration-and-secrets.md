# Configuration and secrets
- Use environment variables for machine-specific infrastructure values and parameters for application behavior.
- Store sensitive values in Symfony's Secrets system or the deployment secret store.
- Keep committed `.env` values safe for local development and keep `.env.local` files out of version control.
- Avoid reading `$_ENV`, `$_SERVER`, or environment variables throughout application services.
- Use one configuration style consistently, and prefer attributes when route or listener metadata belongs beside the code.
- Inspect environment resolution with `debug:dotenv` and verify production secrets are not exposed by profiler or diagnostics.
