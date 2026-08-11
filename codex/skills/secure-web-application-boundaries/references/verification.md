# Verification and threat modeling

**Reviewed:** 2026-08-11
**Scope:** OWASP ASVS 5.0.0, OWASP Top 10:2025, OWASP API Security, and NIST SSDF 1.1. Select only requirements applicable to the system and assurance target.

## Threat model record

1. Name the system boundary, actors, assets, data classifications, entry and exit points, identities, privileges, dependencies, and deployment trust zones.
2. Draw or list concrete data flows and where trust changes.
3. State attacker capability and preconditions for each abuse case.
4. Identify the authoritative prevention, detection, response, and recovery control.
5. Define a negative test or other observable evidence and the residual risk owner.

## Verification discipline

- Map selected ASVS requirements to the exact component, implementation evidence, test, environment, and status.
- Use OWASP Top 10 and API Security as risk taxonomies, not proof that a system is secure or a complete test plan.
- Verify exact framework and identity-provider behavior through installed-version documentation and local configuration.
- Distinguish design review, source review, static findings, dynamic tests, dependency findings, configuration review, and production telemetry. One does not substitute for all others.
- Validate scanner findings for reachability and exploit conditions before changing code. Treat scanner input and output as untrusted.
- Never execute exploit code or active scanning against a target outside explicit authorization and bounds.

## Official sources

- [OWASP ASVS](https://owasp.org/www-project-application-security-verification-standard/)
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [OWASP API Security](https://owasp.org/API-Security/)
- [NIST SSDF 1.1](https://csrc.nist.gov/pubs/sp/800/218/final)
- [OWASP Threat Modeling Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Threat_Modeling_Cheat_Sheet.html)
