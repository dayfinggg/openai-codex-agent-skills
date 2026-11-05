Read when an outage, elevated errors, or production latency needs a bounded incident investigation.

1. Fix the service, operation, datasource, environment, timezone, and start/end of the investigation window before querying. Start with supplied request IDs or the strongest alert. Locate the last known good and first observed bad behavior. Alert firing time need not be failure onset.

2. Reconstruct a timestamped sequence from logs, metric windows, request traces, and rollout or configuration records. Separate connection refusal, application exceptions, dependency waits, resource saturation, and changes. Record clock skew, retention, sampling, and gaps. Distinguish no observation, inaccessible data, and a measured zero.

3. Compare equivalent request populations, parameters, revisions, and dependency paths. Check an unaffected operation or instance where available. A coincident deploy narrows the search but does not prove the cause. Use a bounded contrast to distinguish application work from queuing or dependency time. Consult the matching runtime or database reference only after evidence points there.

4. Preserve the evidence before any authorized mitigation. Record its intended effect, affected requests, restoration path, and verification signal. Do not restart repeatedly, disable checks, clear a shared cache, or increase capacity without evidence that it addresses the measured bottleneck.

5. Check the original failing operation and error or latency signal over a stated post-change window using a comparable population. A successful health endpoint or restarted process does not establish request recovery. For a non-reproducible incident, state the missing regression reproduction and distinguish observed recovery from a confirmed durable correction.
