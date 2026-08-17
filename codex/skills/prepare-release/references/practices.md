# Release Practices

Separate building an artifact from deploying it. A release should identify the exact source, dependencies, configuration, artifact digest, migrations, and evidence used for the decision. Promote the same immutable artifact through environments.

Choose rollout stages and abort thresholds before exposure. Rollback must account for schema and externally visible contract changes; when rollback is unsafe, rehearse forward repair. Supply-chain provenance increases confidence only when build identity and verification are enforced.

Primary sources:

- [Google SRE release engineering](https://sre.google/sre-book/release-engineering/)
- [SLSA specification](https://slsa.dev/spec/v1.0/)
- [Semantic Versioning](https://semver.org/)
- [NIST Secure Software Development Framework](https://csrc.nist.gov/pubs/sp/800/218/final)
