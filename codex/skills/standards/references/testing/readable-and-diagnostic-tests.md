# Readable and diagnostic tests

- Name a test so a failure reports the subject, condition, and expected result without opening the test body.
- Keep Arrange, Act, and Assert distinguishable, with one principal action under test.
- Give each test one coherent reason to fail. Multiple assertions are appropriate when they describe one outcome.
- Assert the meaningful result, state transition, emitted event, or externally visible side effect instead of incidental implementation steps.
- Use the most specific assertion available so failures show useful expected and actual values.
- Keep relevant inputs visible in the test. Use a builder or factory only when it removes irrelevant setup without hiding the scenario.
- Prefer literal expected values for important examples. Do not reproduce the production algorithm in the assertion.
