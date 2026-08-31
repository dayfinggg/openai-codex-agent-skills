# Threat modeling and trust boundaries

- Identify assets, actors, entry points, data flows, trust boundaries, privileged operations, and external dependencies before choosing controls.
- Ask what is being built, what can go wrong, what will mitigate it, and how the mitigation will be verified.
- Rank threats by plausible impact and exploitability in the actual deployment rather than by a generic vulnerability list alone.
- Treat browser, server, database, queue, plugin, build system, administrator, third-party service, and tenant boundaries as distinct when they have different trust.
- Include business-logic abuse, confused-deputy behavior, malicious insiders, compromised dependencies, and denial of service, not only malformed input.
- Model plausible attack progress from reconnaissance and entry through lateral movement, persistence, and the attacker's goal. Include first-party and third-party operators, related insiders, contributors, and compromised build dependencies where they can cross a trust boundary.
- Identify the security invariants and smallest trusted computing base for each protected operation. A caller is not trusted merely because it is internal or on the same network.
- Keep the threat model current when architecture, data sensitivity, identities, public surface, or deployment topology changes.
- Turn accepted mitigations into testable requirements with an owner. Record consciously accepted residual risk rather than silently omitting it.
