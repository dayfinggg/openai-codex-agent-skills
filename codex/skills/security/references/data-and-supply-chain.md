# Data and supply-chain security

Read this reference only for database, sensitive-data, secret, cryptography, logging, dependency, package, artifact, or CI changes.

## Data and databases

- Classify data by sensitivity and business need before choosing controls. Collect and retain the minimum fields for the minimum period; define deletion and subject-access behavior when required by product or law.
- Use separate database identities for workloads and administration. Grant only required operations and schemas. Keep tenant and ownership constraints in every data access path, including background jobs, exports, caches, and search indexes.
- Parameterize queries and identifiers supported by the driver. Map dynamic table, column, and sort choices from fixed application values rather than accepting database syntax from callers.
- Protect data in transit and at rest according to classification and threat model. Treat backups, replicas, exports, analytics stores, queues, caches, and local developer copies as part of the same data lifecycle.
- Make migrations preserve authorization, encryption, retention, and tenant invariants. Rehearse destructive or sensitive migrations and keep rollback or recovery evidence where the risk warrants it.

## Secrets and cryptography

- Keep secrets out of source, repository history, images, manifests, command-line arguments, URLs, logs, exceptions, telemetry, tests, and artifacts. A redacted display does not prove a value is absent from state or storage.
- Prefer workload identity, federation, or short-lived credentials over static keys. Retrieve secrets from the platform or approved secret manager at runtime with least-privileged access, auditing, revocation, expiry, and rotation.
- Scope each secret to one purpose and the smallest blast radius. Define ownership and emergency rotation. If exposure is possible, revoke or rotate first; deleting the plaintext from the latest commit is insufficient.
- Use maintained high-level cryptographic libraries and current platform guidance. Prefer authenticated encryption, secure random generation, and distinct keys for distinct purposes. Keep keys separate from ciphertext and record key identifiers or versions needed for rotation.
- Do not encrypt passwords reversibly. Use the platform's current password-hashing recommendation and parameter settings. Do not create custom token signing, key derivation, nonce, or random-number logic.
- Design crypto for algorithm and key rotation without silently accepting deprecated algorithms. Authentication or decryption failure must fail closed without oracle-like error detail.

## Logging and privacy

- Log security-relevant authentication, authorization, privilege, administrative, configuration, secret, sensitive-data, upload, export, and abuse events with actor, action, target, result, time, and correlation data when lawful and useful.
- Never record passwords, private keys, access or session tokens, full connection strings, recovery codes, raw payment data, or unnecessary personal data. Mask, tokenize, hash, or omit identifiers according to the investigation need and privacy risk.
- Sanitize untrusted values before structured logging to prevent log injection and parser confusion. Bound event size and protect logs from tampering, unauthorized reading, deletion, and retention beyond policy.
- Ensure public errors reveal no stack traces, query text, paths, internal hosts, credentials, or policy details. Preserve a correlation identifier for protected diagnostics.

## Dependencies and artifacts

- Add a dependency only when its value exceeds its attack surface and maintenance cost. Check the exact package and publisher, supported versions, maintenance, release history, vulnerability record, license, install scripts, native code, and transitive graph.
- Use lockfiles and the project's trusted registry or proxy. Review manifest and lockfile diffs together. Avoid unreviewed packages chosen only by similar names, popularity, or generated suggestions.
- Run the project's dependency and vulnerability checks when manifests change. Triage exploitability and reachability rather than treating every advisory equally, but do not suppress a finding without a recorded reason and review trigger.
- Generate or verify SBOM, provenance, attestations, signatures, and artifact digests when the project or delivery environment relies on them. Verify before deployment, not merely after publishing.
- Build releases in controlled CI from reviewed source. Minimize workflow token permissions, isolate untrusted pull-request code from secrets and write credentials, pin third-party workflow dependencies according to project policy, and prevent untrusted values from becoming executable scripts.
- Keep signing and publishing identities short-lived and separate from ordinary build steps. Protect artifacts between build, test, signing, and deployment; promote the same verified artifact instead of rebuilding it differently per environment.
