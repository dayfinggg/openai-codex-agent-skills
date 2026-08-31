# Security testing and delivery

- Derive security tests from the threat model and acceptance criteria, including unauthorized access, tenant isolation, malicious input, secret redaction, resource limits, and recovery.
- Use static analysis, dependency and secret scanning, dynamic analysis, fuzzing, and targeted review where each can detect a relevant class of defect. No single scanner establishes security.
- Keep test environments free of unapproved production data and give test identities the least privileges their scenarios require.
- Review dependency additions, lockfile changes, build scripts, generated artifacts, provenance, and release configuration as part of the executable supply chain.
- Record verifiable provenance that binds the artifact hash to source, dependencies, toolchain, build command, environment, version, and applicable policy.
- Verify the provenance is authentic and matches the built artifact, then enforce one deployment policy choke point. Exercise dry-run, staged rollout, post-deployment reevaluation, rollback, revocation, and audited break-glass paths.
- Treat security findings by root cause. Add a regression test or systemic guard when one defect reveals a repeatable class of mistakes.
- Use the repository's security baseline or a versioned standard such as OWASP ASVS when a product needs auditable verification criteria.
