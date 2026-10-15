# Framework conventions

The project's existing setup wins over this file.

## Contents

- Python with pytest
- JavaScript and TypeScript with Jest or Vitest
- Java with JUnit 5
- C# with xUnit or NUnit
- Go
- Rust

## Python with pytest

- Files `test_*.py`, functions `test_*`, plain `assert` statements.
- Fixtures for shared setup, `tmp_path` for files, `monkeypatch` for environment variables.
- `@pytest.mark.parametrize` for tables of cases.
- `pytest.raises(ErrorType, match=...)` for expected errors.

## JavaScript and TypeScript with Jest or Vitest

- Files `*.test.ts` or `*.spec.ts` next to the code or under `tests`, following the project.
- `describe` for the unit, `it` or `test` with a sentence naming the behavior.
- `it.each` for tables of cases.
- `await expect(promise).rejects.toThrow(...)` for async errors.
- Fake timers for time-dependent code, and reset mocks between tests.

## Java with JUnit 5

- Classes `*Test`, methods annotated with `@Test`, `@DisplayName` when a sentence reads better.
- `@ParameterizedTest` with `@CsvSource` or `@MethodSource` for tables.
- `assertThrows` for errors, AssertJ for fluent assertions when the project uses it.
- `@Nested` classes to group behaviors of one unit.

## C# with xUnit or NUnit

- Classes `*Tests`, xUnit `[Fact]` and `[Theory]` with `[InlineData]`, or NUnit `[Test]` and `[TestCase]`.
- Method names like `Method_Scenario_ExpectedResult`.
- `Assert.Throws` or `Assert.ThrowsAsync` for errors.

## Go

- Files `*_test.go`, functions `TestXxx(t *testing.T)`.
- Table-driven tests with `t.Run(tc.name, ...)` subtests.
- `t.Helper()` in helpers, `t.TempDir()` for files, `t.Parallel()` where safe.
- Compare with `errors.Is` and `errors.As`, not error strings.

## Rust

- Unit tests in a `#[cfg(test)] mod tests` inside the file, integration tests in `tests/`.
- `#[test]` functions, `assert_eq!` with clear values, `#[should_panic]` only for panics that are the contract.
- Return `Result` from tests to use `?`.
