# DRY: remove duplicated knowledge

- DRY means one authoritative representation of each piece of knowledge, not zero repeated text.
- Centralize a rule when its changes must happen together and callers need the same invariant.
- Generate derived artifacts from one source when generation is safer than synchronization.
- Extract stable common behavior and pass real variation explicitly.
- Do not combine code merely because its shape looks alike; coincidental similarity creates accidental coupling.
- Keep semantic duplicates separate when policies, versions, owners, or release schedules differ.
- Repeated test setup can be useful when a shared fixture would hide the behavior under test.
- A repeated literal may be harmless when it represents two independent facts; a repeated business rule is a drift risk.
