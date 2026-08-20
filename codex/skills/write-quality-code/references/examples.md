# Universal implementation examples

These examples illustrate decisions, not language syntax. Translate the pattern into the project's language and conventions.

## Validate before mutation

Fragile shape

```text
state.value = state.value - amount
validate(target)
state.other = state.other + amount
```

Preferred shape

```text
snapshot = read_consistent_snapshot(state)
validate(snapshot, amount, source, target)
next_state = calculate_new_state(snapshot, amount, source, target)
commit_result = commit_if_version_matches(state, snapshot.version, next_state)
if commit_result.conflict:
    retry_from_a_fresh_snapshot_or_return_conflict()
```

All checks happen before the first state change. The version check and commit are one atomic operation.

## Make retries safe

```text
input_fingerprint = fingerprint(input)
reservation = atomically_reserve(operation_key, input_fingerprint)

if reservation.completed:
    return reservation.result
if reservation.conflict:
    reject_mismatched_retry()

result = perform_operation(input, operation_key)
atomically_complete(reservation, result)
return result
```

Use a stable operation key, persist the reservation and completion state, and define failure recovery when a process stops between the side effect and completion.

## Protect a cache from stale work

```text
generation = read_generation(key)
value = load(key)

publish_if_generation_matches(key, value, generation)
```

The publish operation must compare and update atomically. An update during a slow load must not be overwritten by the older result.

## Redact sensitive output

```text
normalised_key = normalise_key(key)
if normalised_key is sensitive:
    replace its value
else if value is a supported mapping and depth is below the bound:
    redact its children recursively
else if value is a supported sequence:
    redact its elements recursively
```

Define supported containers, a depth or cycle policy, and representative key spellings. Keep ordinary diagnostic fields and do not claim coverage beyond that declared matrix.

## Test the public behavior

```text
given a valid request, the public operation returns the expected result
given an invalid boundary value, the public operation rejects it without mutation
given the same retry key and input, the side effect occurs once and returns the stored result
given concurrent calls, the named shared-state invariant remains true
```

Expected values come from the contract or an independent worked example. The test must not reimplement the production algorithm.

## Measure before optimizing

Use the independent baseline and treatment pattern in [verify-claims examples](../../verify-claims/references/examples.md). Keep an optimization only when the workload and the evidence justify its added complexity.
