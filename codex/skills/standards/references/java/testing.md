# Testing

- Test observable behavior and contracts rather than private implementation structure.
- Keep each test focused on one behavior with clear arrange, act, and assert phases.
- Cover normal inputs, boundaries, invalid inputs, state transitions, and documented failure modes.
- Assert exception type and cause when they are part of the contract.
- Use parameterized tests for a behavior matrix instead of duplicated test methods.
- Keep unit tests isolated, deterministic, and fast.
- Use fakes, fixed clocks, controlled executors, and local resources instead of sleeps and network calls.
- Use integration or contract tests for persistence, serialization, network, and framework boundaries.
- Exercise cancellation, interruption, cleanup, and concurrency limits where those behaviors matter.
- Use bounded waits and latches for concurrent tests, and report timeout context on failure.
- Reset global state and avoid test-order or wall-clock dependencies.
- Name a test class after its subject and end the name with Test.
- Run tests through the project build as well as an IDE.
- Use mutation, property-based, or fuzz testing when parsing, security, or combinatorial input risk justifies it.
