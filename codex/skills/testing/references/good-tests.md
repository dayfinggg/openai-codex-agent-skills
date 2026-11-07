<overview>
Read this file when you write or change tests, add mocks, or add cleanup or helper methods for tests. It adds to the `tdd` skill, whose `tests.md` and `mocking.md` cover public-interface tests, tautological tests, and where to mock.

A test exists to catch a specific break. Two principles govern everything here. Every test names the break it catches, and every test exercises the real thing.
</overview>

<name_the_break>
Before you write the test body, name the production change that should make this test fail. Then decide whether that change is a bug or a decision. A test earns its place when it catches a real fault. Such faults are a wrong branch, a missing side effect, a wrong argument, a boundary case, or a broken contract.

Derive expected values without the code under test, as the `tdd` skill requires. Table-driven tests with literal expected values are the preferred shape.

A change detector is not a test. If only intentional decisions can fail a test, it fires on redesign and sleeps through bugs. Such decisions include a constant's value, the exact wording of a message, and private structure. Test the behavior that depends on the decision instead. So do not assert `expect(MAX_RETRIES).toBe(5)`. Assert that a failing call is retried 5 times and that a 6th attempt never happens.

Test behavior, not text. An assertion that a script, skill, or config contains an exact line proves only that the source is the source. Run scripts against controlled inputs, and assert outputs, side effects, or exit codes. Documents that instruct agents are tested through the behavior of the agent that reads them. Prose for humans earns no test at all.

Test your code, not the framework. Test the contract your code makes at its boundaries. Examples are the route you register, the query you emit, and the payload you produce. Upstream mechanics belong to their maintainers' tests. A test that your router calls a registered handler is the framework's test, not yours. When upstream behavior surprised you, write one narrow characterization test that names the assumption.

The same rule holds inside your code. Constructors, getters, constants, and trivial forwarding earn tests only when they validate, normalize, default, derive, enforce, or cause side effects. Otherwise assert the first result a consumer sees that depends on them.

Write only the tests the behavior needs. Trivial code and prose for humans earn none, and a test written to satisfy a process costs maintenance forever.

Before you write a test body, run this check.
1. Name the production change that would make the test fail.
2. If you cannot name one, redesign the test around an observable behavior.
3. If the only failing change is the source text, run the artifact and assert its effects.
4. If only intentional decisions fail it, test the behavior that depends on the decision.
5. If the expected value reuses the code's logic or helpers, replace it with a literal or a hand-checked fixture.
</name_the_break>

<exercise_the_real_thing>
A mock earns no assertions. An assertion on a mock passes when the mock is present and fails when it is absent. So it says nothing about the component. Assert the real component's behavior. If the mock is what you check, unmock it or delete the assertion. This assertion checks real behavior.

```typescript
expect(screen.getByRole('navigation')).toBeInTheDocument();
```

This assertion only checks that a mock exists.

```typescript
expect(screen.getByTestId('sidebar-mock')).toBeInTheDocument();
```

Mock at the right level. Learn every side effect of the real method before you replace it. Mock the slow or external operation, and keep real what the test depends on. When unsure, run the test against the real implementation first and observe what needs to happen. In this bad mock, the mock swallows a config write that duplicate detection reads.

```typescript
vi.mock('ToolCatalog', () => ({
  discoverAndCacheTools: vi.fn().mockResolvedValue(undefined)
}));
```

This mock replaces only the slow server startup, so the config write stays real.

```typescript
vi.mock('MCPServerManager');
```

Make doubles specific. At a system boundary, arguments, call counts, or ordering can be part of the contract, so assert them there. A fake that accepts anything verifies nothing. Give each branch its own fixture or spy, such as success, error, and malformed input. Then the wrong branch cannot satisfy the expectation.

Mirror real data completely. A mock response holds the complete structure as it exists in reality, with all documented fields. A partial mock fails silently when downstream code reads an omitted field, and the test passes while the integration breaks.

Production classes carry production methods only. Cleanup that only tests need lives in test utilities, never as a `destroy()` on the production class. Ask whether only tests call the method, and whether the class owns the resource's lifecycle. If only tests call it, it belongs in a test utility.

Prefer real components over complex mocks. Switch to an integration test with real components when mock setup outgrows the test logic. Switch also when mocks miss methods the real components have, or when tests break because a mock changed.

Before you add a mock or a test helper, run this check.
1. List the real method's side effects. Keep real the ones the test depends on, and mock the slow or external level below them.
2. Make the mock response mirror the complete real structure.
3. Put a method that only tests call in test utilities, not in production code.
4. If you are about to assert on the mock itself, unmock it or delete the assertion.
</exercise_the_real_thing>

<mutation_check>
Before you finish, mutate the production code in your head. At least one test should fail for each realistic mutation.
- A wrong constant or argument.
- A wrong branch handler.
- A missing state change or side effect.
- An empty or default return.
- Missing validation for zero, empty, nil, unauthorized, or malformed input.

A mutation that no test catches marks the behavior as unprotected, or the test as tautological.
</mutation_check>

<warning_signs>
These signs mark a test that protects nothing.
- The test can fail only through a panic, a crash, or a missing selector.
- The test fails on every intentional change and never on accidental breakage.
- The test greps source text, or asserts that a removed symbol stays removed.
- The test would still matter if only the framework remained.
- The test exists for coverage and checks no side effect or outcome.
- An assertion checks a `*-mock` test ID, or fails when you remove the mock.
- A method is called only from test files.
- Mock setup is more than half the test, or you cannot explain why the mock is needed.
- A mock was added "just to be safe".
- A large snapshot stands in for specific assertions, so nobody reviews its diffs.
- Tests share mutable state, so one test's leftovers change another's result.
- An async assertion is not awaited, so its failure never reaches the runner.
</warning_signs>
