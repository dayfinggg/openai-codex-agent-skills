# Testing

- Test public behavior and observable contracts rather than private helper calls or incidental instance variables.
- Add a focused regression test for a confirmed bug before changing the implementation when a cheap test target exists.
- Keep unit tests close to pure domain logic and use integration tests at database, network, filesystem, and framework boundaries.
- Prefer real small collaborators over extensive mocks; mock only an external boundary or an intentionally isolated protocol.
- Give each test one clear reason to fail and name the behavior and relevant condition.
- Keep tests deterministic by controlling time, randomness, environment, ordering, and external services.
- Isolate state between tests and avoid tests that depend on execution order or shared mutable fixtures.
- Assert useful output, state transitions, emitted messages, and error contracts rather than implementation call counts.
- Test both normal and boundary inputs, including empty collections, nilability, invalid arguments, and repeated calls.
- Test block APIs for no-block behavior, yielded arguments, yield count, and exception-safe cleanup.
- Use the test framework already adopted by the project, whether Minitest, RSpec, or another documented runner.
- Run the smallest relevant test first, then the full project command before delivery.
- Run type checks and lint checks that CI treats as required; a passing unit suite is not sufficient evidence by itself.
- Keep snapshots and fixtures small, named, and reviewed when they encode an intentional contract.
- Delete tests that assert no useful behavior only when the replacement coverage is explicit and stronger.
- Treat hard-to-write tests as feedback about object boundaries, dependency direction, or hidden state.
