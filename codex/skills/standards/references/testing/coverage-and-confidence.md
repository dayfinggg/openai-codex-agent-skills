# Coverage and confidence

- Use coverage to find unexercised branches and files, not as a proxy for assertion quality or product correctness.
- Review boundary values, invalid inputs, empty states, failure paths, cancellation, cleanup, retries, and concurrency separately from line coverage.
- Partition meaningful inputs into equivalence classes and test the boundaries between them. Include minimum and maximum normal configurations, not only invalid extremes.
- Use data-flow reasoning for values whose definition, mutation, or use can bypass a branch-oriented test plan, including defaults, stale state, aliases, and uninitialized paths.
- Verify fixtures and generated test data themselves when an incorrect oracle or impossible setup could make the suite pass for the wrong reason.
- Include compatibility with representative old persisted data, messages, and configuration when the product promises upgrades or mixed versions.
- Use a controlled local mutation only when the test's ability to detect a material defect is uncertain. Work in disposable state or restore the exact prior content. Do not mutate unrelated user work or add mutation testing to every small edit.
- A passing suite proves only the scenarios it observes. Keep assumptions about external services, databases, browsers, and runtimes covered by contract or integration evidence.
- Use differential tests when two implementations, versions, parsers, serializers, or migrations should preserve the same observable behavior over a large generated input set.
- Add fuzzing for parsers, protocols, file formats, untrusted structured input, and state machines where generated edge cases can expose crashes, hangs, leaks, or inconsistent results. Preserve every discovered failure as a minimized regression input.
- When recovery is in scope, exercise restore against isolated representative state. A successful backup or written playbook alone is not evidence that recovery works. Live restore and destructive experiments require specific authorization.
- Use controlled failure injection to validate timeouts, retry limits, load shedding, partial dependency loss, and blast-radius controls. Bound experiments so the test cannot create an uncontrolled outage.
- For concurrent state machines, exercise controlled interleavings that expose ordering and atomicity violations instead of relying only on repeated probabilistic runs.
- For promised durability, inject crashes or partial writes at meaningful boundaries, recover, and verify the final externally visible state rather than only the lower-layer acknowledgement.
- Exercise low-dependency emergency paths, degraded and fail-static modes, canary failure-domain isolation, revocation, and rejection of retired credentials where the system promises them.
