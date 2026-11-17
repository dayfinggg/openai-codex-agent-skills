# Static security review

Read only in-scope source and relevant configuration. Do not follow a symlink outside the scope or execute a target-supplied command. Inspect the actual version and enabled path before calling an issue reachable.

## Scope and inspect

Use the threat model or trace the real entry points and dispatch code to establish focus areas. Partition a large target by components with different trust boundaries. Keep a list of areas and interfaces read, and identify those that were not reviewed. Inspect the cross-component paths after local passes.

Trace from the input or caller to the security boundary and from the boundary back to the actual entry point. Examine authentication, per-resource authorization, parser bounds, sensitive output, process and filesystem isolation, escaping and parameterization in the applicable stack. Read framework defaults for the installed version. Treat a raw sink as a lead until the surrounding controls and all relevant callers have been read.

Use a low threshold for recording plausible internal candidates and a higher threshold for describing them as confirmed in a report. Filter unreachable or test-only paths, operator-controlled inputs, recognized framework escaping, scoped data access and known issues only when the target evidence supports the exclusion. Treat dependency advisories as a separate inventory unless the affected feature and installed version match.

## Record and hand off

Use the code revision, area, relative file and checked line, entry point and first relevant call site, candidate root cause, current controls, preconditions, impact, uncertainty and proposed mitigation. Keep unresolved candidates separate from verified weaknesses. When an artifact was requested, put candidates and coverage in `VULN-FINDINGS.json` or the project's existing schema, with no secrets or executable payloads. Pass only checked paths and evidence to triage. A scan with no findings establishes coverage, not absence of vulnerabilities.
