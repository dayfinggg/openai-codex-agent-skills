---
name: incident-diagnosis
description: "Investigate application errors, latency regressions, or outages using a bounded timeline and corroborated logs, metrics, traces, and changes. Use for backend or web incidents."
---

Find the cause of the reported incident with the least expensive reliable evidence.

1. Establish the affected service, operation, environment, user-visible symptom, and fixed time range. Reuse supplied IDs, alerts, and known changes. Alert firing time is not automatically failure onset.
2. Confirm datasource and environment identity before querying. Begin with the strongest supplied signal rather than surveying every dashboard or service.
3. Build a timeline from evidence. Separate connection failures, application exceptions, dependency waits, resource saturation, and rollout changes. A temporal correlation alone does not prove causation.
4. Form ranked hypotheses that can be weakened as well as supported. Choose a bounded check for each material uncertainty. Inspect counterevidence before making a cause claim.
5. Compare equivalent request populations, parameters, and deployments. Distinguish missing data, inaccessible data, and an actual measured zero. Account for retention, sampling, and clock differences.
6. Use php-fpm-opcache-diagnostics, database-query-diagnosis, or a relevant installed runtime specialist when the evidence points there. Keep investigation read-only until an authorized correction is established.
7. Verify the original symptom after a correction and check the relevant regression signal. A restarted service or successful health endpoint does not by itself prove the failing operation is repaired.

Do not repeatedly restart components, raise limits, clear shared caches, or disable checks to make symptoms disappear. Ask only for a missing fact or access that materially blocks diagnosis and cannot be obtained.

Finish with verified observations, established cause or remaining uncertainty, actual corrective action, and the evidence for recovery. Keep the report in chat unless a file is requested.

