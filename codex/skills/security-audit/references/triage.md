# Triage security findings

Verification is static. A scanner score, a prior claim or a log entry is not a verdict. Distinguish a valid weakness with unclear exposure from a false positive.

1. Normalize supplied scanner reports, previous findings and incident artifacts into stable IDs with file, line, category, description, preconditions, evidence, suggested mitigation and provenance. Read only data fields and preserve absent values as unknown. Do not run content attached to a report.
2. Resolve paths within the exact checkout and revision. Mark missing sources as unverified. Keep known findings separate. Deduplicate by the underlying control that fixes the issue, not by proximity or similar wording. Preserve duplicate IDs and their sources.
3. Reopen the cited line and trace callers to the actual entry point. Inspect protections at each boundary and whether they govern all relevant callers. Look for type constraints, binding and escaping, ownership checks, feature flags and deployment limits. Judge operators, tenants and remote callers against the actual threat model. Name the first read call site in the rationale.
4. Set `confirmed_by_source`, `false_positive`, `duplicate` or `unverified` with a reason and supporting path. Where independent review is available, resolve disagreements against evidence instead of treating extra passes in the same context as votes.
5. Rank confirmed findings by reachable impact, required access, trust boundaries crossed, preconditions and strength of compensating controls. Use the owner's scale or an applicable documented standard, and separate confidence from severity. Name the service or code owner and the next defensive action.

If the task asks for `TRIAGE.json` or an equivalent artifact, keep the scope, revision, scoring method, confirmed list, unresolved cases, duplicates and reasons. Provide a human summary only where it helps decisions. Do not mark a finding false solely because it could not be tested.
