# Test quality

Use this reference when choosing a seam, deriving an oracle, designing fixtures, or deciding whether the test can detect a meaningful defect.

## Behavior and boundary

Test an observable contract through a stable public interface or the narrowest useful system boundary. Choose the cheapest level that can reliably expose the failure. Do not create one test per production method or duplicate the same risk at every test level. Prefer an integration or contract test when the behavior crosses a component boundary that an in-process unit test cannot observe.

Name the test in domain or user-visible language. A failure should identify the violated behavior rather than an internal call sequence.

## Independent oracle

Derive the expected result from an approved example, specification, invariant, reproducer, previous compatible contract, known literal, or separately derived calculation. Do not copy the current output into the expectation or reproduce the production algorithm in the test.

A literal expected value is valid when its origin is independent and reviewable. It is not valid merely because the implementation currently emits it. For material logic, confirm failure sensitivity with the pre-change implementation, a known bad variant, mutation, property, differential result, or another independent check when practical.

## Fixture integrity

- Use the smallest data shape that remains representative of the contract.
- Give the fixture one owner and an explicit lifecycle. Isolate mutable state across tests, orderings, and parallel workers.
- Control time, randomness, locale, storage, process state, and network behavior only where the contract depends on them.
- Make setup failure distinguishable from behavior failure and always complete required cleanup.
- Do not encode a hidden answer in fixture names, identifiers, paths, ordering, timestamps, or seeds.
- Do not rewrite a fixture, snapshot, or golden output to match a failing implementation unless the approved contract changed and the new expectation has independent evidence.

## Assertions and diagnostics

Assert the behavior strongly enough to reject a plausible wrong implementation. Avoid assertions on private fields, incidental formatting, or interaction order unless that detail is the contract. Treat snapshots as evidence only when a reviewer can understand their semantic change. Preserve focused failure output and relevant diagnostic artifacts without leaking secrets.

Never skip, relax, retry, or broaden a tolerance solely to turn red into green.
