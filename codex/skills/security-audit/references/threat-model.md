# Threat model

Model durable risk rather than individual bugs. If one patch makes an entry disappear, record it as evidence of a threat instead of the threat itself.

## Build the model

1. Establish the system, revision, scope and known deployment assumptions. For an existing checkout, bootstrap from source, manifests, architecture notes, relevant change history and authorized advisory data. For a design without code, interview its owner. Refine a code-grounded draft with the owner when a deployment fact affects a decision.
2. Inventory assets, actors, entry points, privilege changes and operations identities. Include file parsing, network routes, local interfaces, persistence, plugin loading, builds and supply chain where they cross real trust boundaries. Mark claims attested by the owner separately from code-verified facts.
3. Link each threat to an actor, entry point and asset. Consider confidentiality, integrity and availability, and check infrastructure for privilege growth, unmanaged grants, stale access and controls outside the checkout. Use known defects as evidence, not as the only source of possible threats.
4. Record checked controls, remaining impact and likelihood, and what evidence would settle each gap. Keep accepted risks and scope exclusions with an owner and reason. Prefer controls that address the class of weakness over individual fixes.
5. Check that each in-scope entry point has a threat row or an explicit rationale. Keep threat IDs stable across updates. Pass the boundary assumptions and priority areas to discovery and triage.

## Owner questions

Ask only questions that change the result. Establish what the system protects, what can go wrong, what controls exist and whether the resulting model matches the owner's experience. Note a claim that cannot be independently verified and the check it needs. Do not turn an inference about deployment into an observed fact.

## Artifact

Write `THREAT_MODEL.md` only when requested or allowed by the task's artifact convention. Include system context, assets, entry points and trust boundaries, threats, deprioritized items, open questions, provenance and recommended mitigations. For each threat record an ID, actor, surface, asset, impact, likelihood, status, controls and evidence. Put the revision and date in provenance. Keep private architecture detail within the authorized destination.
