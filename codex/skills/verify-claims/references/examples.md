# Verification examples

## Performance claim

```text
claim: the new implementation reduces median latency for the representative workload
baseline: run the old implementation with the same input and environment
treatment: run the new implementation with the same input and environment
method: warm up, run interleaved repeated samples, control environmental noise, and compare outputs with an independent oracle
success threshold: the agreed latency margin and correctness condition before measurement
verdict: VERIFIED, NOT VERIFIED, or INCONCLUSIVE
```

Do not call a change faster because one run was shorter or because a benchmark was generated with the implementation.

## Security claim

```text
claim: sensitive values are not emitted in the declared diagnostic matrix
coverage matrix: named sinks, nested container shapes, key variants, and unique canary values
independent check: scan every captured sink for each canary and verify ordinary fields remain useful
verdict: VERIFIED only for the declared matrix when every canary is absent
```

A passing test suite written by the same agent is evidence, not independent proof.
