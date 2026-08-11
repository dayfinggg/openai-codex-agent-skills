# GitLab CI fit

**Reviewed:** 2026-08-11
**Scope:** Current GitLab CI/CD documentation. Resolve GitLab edition and version, runner type, executor, and instance settings first.

## Configuration and rules

- Inspect the complete merged configuration including local, project, component, template, and remote includes. Pin external includes to an immutable identity where supported.
- Use `workflow:rules`, job `rules`, protected refs, and environments to define exactly which pipelines and deployments can run. Test merge request, branch, tag, schedule, and manual paths separately.
- Treat variables and merge request metadata as untrusted. Do not construct shell programs from them.

## Runners, identity, and artifacts

- Separate untrusted jobs from protected runners and credentials. Scope project, group, environment, file, masked, hidden, and protected variables to their actual trust boundary.
- Prefer short-lived identity federation where the target supports it. Restrict job tokens and downstream pipeline permissions.
- Use `needs` and stages to express the real graph. Bound timeouts, retries, interruptibility, resources, and parallel jobs.
- Keep caches mutable and scoped. Keep release artifacts immutable, checksummed, retained, and promoted without rebuilding.

## Verification

Use GitLab configuration validation or CI lint for the target version, inspect merged YAML, verify rules and protected settings, and run an authorized non-production pipeline. Static validity does not prove runner isolation or external environment protection.

## Official sources

- [GitLab CI/CD pipelines](https://docs.gitlab.com/ci/pipelines/)
- [CI/CD YAML syntax](https://docs.gitlab.com/ci/yaml/)
- [CI/CD variables security](https://docs.gitlab.com/ci/variables/)
- [Deployment safety](https://docs.gitlab.com/ci/environments/deployment_safety/)
- [Caching](https://docs.gitlab.com/ci/caching/)
