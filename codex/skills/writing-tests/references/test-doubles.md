# Test doubles

Definitions follow Robert C. Martin's "The Little Mocker", which builds on Gerard Meszaros's terms.

| Double | What it does | Use it when |
|---|---|---|
| Dummy | Fills a required parameter and is never used | A signature demands an argument the test does not care about |
| Stub | Returns fixed values | The code needs input from a dependency, such as an authorized user or a fixed time |
| Spy | Stub that also records calls and arguments | The test must check that a boundary call happened, such as an email being sent |
| Mock | Spy that holds its own expectations and verifies them | Rarely, when call order and count are the behavior itself |
| Fake | Simplified working implementation | Many tests share a dependency with real behavior, such as an in-memory repository |

## Guidance

- Stubs and spies cover most needs. Write them by hand from the interface, which keeps them readable.
- Fakes pay off for repositories, queues, and clocks used across many tests. Give a fake its own tests when it grows logic.
- Verify interactions only at architectural boundaries. Checking calls between internal classes couples tests to structure.
- Do not double what you do not own directly. Wrap a third-party API behind your own interface and double that interface, then cover the wrapper with an integration test.
- Inject time and randomness so tests stay repeatable.
