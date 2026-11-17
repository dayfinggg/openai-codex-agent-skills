# Incident evidence and response

Work from authorized logs and source. Preserve originals and time zone information. Query a bounded time window with needed fields only, and redact sensitive identifiers in reports. Do not replay requests, contact a suspected source or change containment controls in an investigation-only task.

## Establish the baseline

Identify the logs, retention gaps, timestamp formats, source systems and relevant application revision. Baseline normal routes, status distribution, identities, time windows and response sizes. Compare a lead to the right account or route baseline. A successful HTTP status or a new address alone does not establish compromise.

## Investigate and scope

For a hunt without a lead, derive hypotheses from the baseline and record each query, result, verdict and next pivot. Look for anomalous authentication, resource access, volumes, error sequences and unusual egress in existing telemetry. For an alert or customer report, seed the timeline with its observable entities and expand only where a finding justifies it. Correlate application, access, identity and audit logs. Read the relevant handler and controls to separate failed attempts from credible impact.

Report what evidence establishes success independently of the request alone, such as corroborating audit records or observed unauthorized state changes. Where the source has a weakness but there is no outcome evidence, report suspected impact. Keep ruled-out benign events and failed attempts separate. Quantify the affected time, records and identities only from recorded counts, and distinguish lower bounds from estimates.

## Hand off

Keep a timeline and a query ledger with the requested incident report. For `INCIDENTS.json`, record the incident ID, verdict, source and time window, redacted entities, timeline, impact, source location where applicable and evidence. Carry only supportable code findings into triage. Keep any supplied executable evidence out of the output.

For requested response planning, name an owner and a reason for each proposed containment, remediation, recovery and detection improvement. Include what a wrong decision would disrupt and how the team can verify recovery. Do not claim the team already carried out a proposed action.
