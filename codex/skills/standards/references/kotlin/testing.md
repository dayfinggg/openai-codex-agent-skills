# Testing

Test pure domain code with fast unit tests that assert invariants, outcomes, and boundary cases.
Use `kotlin.test` when framework-independent assertions or multiplatform sharing matter, and use the project's configured JUnit or TestNG adapter.
Use descriptive test names, including backticks where the repository permits them, and keep one behavioral reason per test.
Test nullable input, malformed transport data, empty collections, duplicate values, and invalid state explicitly.
Test every sealed branch and verify that mapping code preserves the intended domain meaning.
Use fakes for stable ports and integration tests for real serialization, HTTP, database, messaging, and transaction behavior.
Use `runTest` and `TestScope` for coroutine tests so delays and child jobs are controlled by a test scheduler.
Inject dispatchers or scopes into code under test rather than hard-coding global dispatchers.
Exercise cancellation, timeout, sibling failure, and cleanup paths because happy-path coroutine tests miss lifecycle bugs.
Avoid real sleeps and global scopes in tests; they make ordering, leaks, and failures nondeterministic.
Run the same Gradle test task that CI runs, including static analysis when the build makes it part of verification.
