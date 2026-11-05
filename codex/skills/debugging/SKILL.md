---
name: debugging
description: Diagnoses bugs, performance regressions, outages, failed CI jobs, slow SQL, PHP-FPM failures, and Symfony errors through reproduction, fault localization, and regression proof. Use before changing code when the user reports an error, a bug, a crash, a 500, a failing job, a timeout, something that stopped working, or a difference between local and production. Not routine feature work or schema design.
---

1. Establish the expected and observed behavior, affected operation, environment, revision, runtime and dependency versions, inputs, and relevant time interval. Read applicable project instructions, the affected callers and contracts, and relevant glossary entries or architecture decisions. An investigation request does not authorize a fix or deployment. Keep live investigation read-only until a specific correction is supported and authorized.

2. Select only the relevant reference. Each contains a read when condition.

   - [Incidents](references/incidents.md), read when diagnosing an outage, elevated errors, or production latency.
   - [CI failures](references/ci-failures.md), read when a pipeline fails, flakes, or differs from local execution.
   - [Database queries](references/database-queries.md), read when SQL, locks, or connection exhaustion dominate the symptom.
   - [PHP-FPM and OPcache](references/php-fpm-opcache.md), read when FastCGI fails, workers saturate, or PHP serves stale code.
   - [Symfony](references/symfony.md), read when a request, profiler token, service binding, or environment loading points to Symfony.
   - [Runtime debugging](references/runtime-debuggers.md), read when Node.js or Python state, timing, or stack inspection can distinguish causes.

3. Before changing behavior, run a bounded reproduction that asserts the user's exact symptom. Prefer an existing failing test, then an HTTP or CLI invocation, UI assertion, trace replay, or isolated harness. Preserve the invocation, relevant output, exit status, environment, and revision. Reading code to construct the reproduction is allowed. A setup failure or successful health check is not reproduction of the reported defect.

4. Minimize the failing scenario by removing one input, caller, configuration difference, or dependency at a time and rerunning it. Keep the actual call chain and concurrency required for failure. Pin clocks, seeds, data, and dependencies where relevant. For intermittent bugs, measure failures per attempts under bounded stress and preserve the schedule or seed. Do not prescribe arbitrary retry counts or treat one clean run as proof. For performance, capture a representative baseline with equivalent data, concurrency, and cache state before tuning.

5. If no reproduction is possible, record attempts and the missing access, artifact, or instrumentation. Continue independent read-only investigation. Ask only for the missing prerequisite. A human-only reproduction needs exact steps, timestamps, and redacted observations through an available user interaction channel, never a shell waiting for input. Do not claim regression proof from inspection alone.

6. Gather the smallest evidence set that separates causes. Correlate exact log lines, metrics with units and populations, trace spans with request identity, and relevant code, configuration, dependency, or deployment changes. Extract the supporting lines with timestamps and source locations before drawing conclusions from a long log. Follow surrounding context and rotated history when needed. A summary, truncated result, missing sample, or plausible narrative is not a measured cause. Redact secrets before displaying or saving commands and artifacts, including headers and payloads. Do not reconstruct masked values.

7. Locate the first broken contract in the actual path. Trace the bad value, exception, or wait backward through callers and component boundaries, comparing with a working equivalent. Distinguish the originating defect from downstream symptoms. A database wait does not justify an HTTP timeout increase, and a tool-runtime failure does not establish an application defect. Repair the responsible layer without changing unrelated access rules, supported events, or interfaces.

8. When the cause is uncertain, keep competing falsifiable hypotheses. For each, identify supporting evidence, counterevidence, a predicted observation, and a disconfirming result. Select the cheapest bounded experiment whose possible outcomes distinguish the leading explanations. Change one variable at a time. Prefer a breakpoint or targeted boundary probe over broad logging. Mark temporary instrumentation with a unique searchable identifier. Revisit the candidates after a failed experiment instead of stacking speculative fixes. Use a known-good comparison or authorized bisection when change history provides the distinguishing experiment.

9. Before an authorized fix, turn the minimal reproduction into a failing regression test at a seam that reaches the real caller and lifecycle. Confirm that it fails for the reported reason on the old behavior. If deliberately altering code or a fixture to demonstrate failure, verify the mutation against the unchanged baseline. If no adequate seam exists, name the missing coverage rather than substituting a shallow test or expanding into an architectural rewrite.

10. Apply the smallest cause-directed correction. Do not weaken assertions, skip checks, refresh snapshots blindly, suppress errors, raise limits, clear shared caches, kill sessions, or restart services to make a symptom disappear. A restart or other mitigation requires evidence for its purpose, existing authorization, preserved diagnostic evidence, and a recovery check. Distinguish mitigation from a durable fix.

11. Run the regression test and the original unminimized reproduction after the change, then relevant checks of affected callers and contracts. Compare performance under the baseline conditions. State intermittent-test attempts and outcomes instead of claiming universal absence. An incident also needs recovery evidence for the affected population, not just process uptime. Preserve unrelated failures and report them separately. Stop once the requested behavior and relevant regression checks pass.

12. Remove task-owned probes and disposable artifacts when no process needs them, verify removal using their identifier, and preserve evidence needed by an active investigation. Review the complete task diff for unintended behavior changes and secrets.

Report the observed sequence, affected environment and revision, established cause with its exact evidence or the remaining competing explanations, actual correction or mitigation, and executed verification outcomes. State what was not checked and its concrete blocker. If a change preceded a symptom but no controlled comparison was run, report that sequence and the missing comparison without attributing causation. Do not turn assumptions, an unexecuted test, a rerun, or a service restart into a completion claim. Keep the report in chat unless a document is requested.
