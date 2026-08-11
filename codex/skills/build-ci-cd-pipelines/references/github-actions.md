# GitHub Actions fit

**Reviewed:** 2026-08-11
**Scope:** Current GitHub Actions documentation. Resolve GitHub Enterprise or hosted version, runner images, action versions, and repository settings first.

## Events and permissions

- Distinguish `pull_request`, `pull_request_target`, push, workflow dispatch, workflow call, release, and scheduled trust. Never run untrusted checkout with privileged `pull_request_target` credentials.
- Set `permissions` explicitly at workflow or job scope and grant only required operations. Treat environment approval and branch protection as external configuration that must be inspected rather than assumed.
- Use OIDC with audience, subject, environment, branch or tag, repository, and role conditions narrow enough for the deployment.

## Expressions and commands

- Treat context values as untrusted. Pass them through environment variables or structured inputs rather than interpolating into a shell program.
- Pin third-party actions to full commit identities where policy requires it and verify the publisher and update path.
- Bound job and step timeouts, concurrency groups, cancellation, artifact retention, and matrix size.
- Keep reusable workflow inputs, secrets, permissions, and outputs as an explicit public contract.

## Verification

Review the expanded workflow, event filters, job conditions, permissions, action identities, environment bindings, cache keys, artifacts, and script injection paths. Use a non-privileged test event or authorized sandbox run before relying on deployment behavior.

## Official sources

- [Secure use reference](https://docs.github.com/en/actions/reference/security/secure-use)
- [OIDC in cloud providers](https://docs.github.com/en/actions/concepts/security/openid-connect)
- [Deployment environments](https://docs.github.com/en/actions/reference/deployments-and-environments)
- [Dependency caching](https://docs.github.com/en/actions/using-workflows/caching-dependencies-to-speed-up-workflows)
- [Artifact attestations](https://docs.github.com/en/actions/security-for-github-actions/using-artifact-attestations)
