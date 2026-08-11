# Recovery and handoff

**Reviewed:** 2026-08-11
**Scope:** Recovery verification, backlog and data reconciliation, temporary controls, and transition to diagnosis and learning.

## Recovery gates

- Verify representative user journeys from outside the failed component where possible.
- Compare error rate, latency, traffic, saturation, dependency health, queue age and depth, replication lag, data invariants, and security signals with a known healthy baseline.
- Account for hidden backlog, retries, duplicate effects, delayed jobs, cache convergence, expired leases, and partial regional or tenant recovery.
- Hold an observation window long enough to cover the failure cycle and traffic pattern. Do not close on one green probe.
- Verify that alerts clear for the right reason and that telemetry was not disabled or sampled away.

## Handoff

- Identify every temporary mitigation, changed limit, bypass, flag, route, credential, manual process, and increased capacity. Give each an owner and removal or review date.
- Preserve raw evidence and distinguish the causal hypothesis from established facts.
- Hand root-cause analysis to `diagnose-root-cause` after stabilization. Hand retained remediation to the relevant implementation skill.
- Use a blameless retrospective to improve system and response design, while keeping concrete action owners and measurable completion gates.

## Official sources

- [Google SRE emergency response](https://sre.google/sre-book/emergency-response/)
- [Google SRE postmortem culture](https://sre.google/sre-book/postmortem-culture/)
- [Google SRE effective troubleshooting](https://sre.google/sre-book/effective-troubleshooting/)
- [NIST SP 800-61 Rev. 3](https://csrc.nist.gov/pubs/sp/800/61/r3/final)
