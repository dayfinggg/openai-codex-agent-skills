# Secrets and cryptography

- Do not commit or embed passwords, tokens, private keys, certificates, production credentials, or recovery codes in source, fixtures, logs, images, or client bundles.
- Load secrets through the deployment's supported secret mechanism, expose them only to the component that needs them, and keep rotation possible without rebuilding unrelated code.
- Use maintained high-level cryptographic libraries and protocols. Do not invent algorithms, modes, key derivation, nonce handling, signatures, or token formats.
- Store user passwords with a password-hashing function intended for that purpose and parameters appropriate to the supported runtime. Rehash after successful verification when policy changes.
- Encrypt data only after defining the protected asset, attacker, key owner, rotation, revocation, backup, restore, deletion, and metadata-integrity requirements.
- Keep sensitive values out of errors, telemetry, crash dumps, snapshots, and debugging tools. Redact by field policy rather than by fragile string replacement.
- Test key and credential rotation end to end, including verified loss of access through the retired credential.
