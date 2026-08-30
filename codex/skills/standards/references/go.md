# Go standards reference

Use this as a review checklist, not as a substitute for package documentation or local conventions.
Prefer clarity, simple control flow, small public APIs, and code that a new maintainer can verify from the call site.
Effective Go remains the community baseline, but it was written for Go in 2009 and does not cover modules, generics, or newer libraries.[1]
Google's Go guide is team guidance rather than a language law; apply it with the project's existing, consistent style.[3][5]

## Effective Go and review baseline

Run `gofmt` on every Go file, and use `goimports` when it is the project's chosen import tool.[1][2]
Keep standard-library imports in the first group and third-party or local imports in later groups.[2]
Write the successful path with minimal indentation, handle errors first, and omit `else` after `return`, `continue`, or `break`.[1][2]
Give every exported name a doc comment, and make declaration comments full sentences that start with the declared name.[1][2]
Explain why code is surprising, performance-sensitive, security-sensitive, or constrained; do not narrate obvious syntax.[3]
There is no fixed line-length rule; refactor names or semantic boundaries instead of wrapping code mechanically.[2][3]
Use `defer` immediately after acquiring a resource when cleanup must happen on every return path.[1]
Keep APIs explicit about ownership, cleanup, blocking, concurrency, and error behavior.[3][5]
Prefer ordinary language constructs and standard-library facilities before adding abstractions or dependencies.[3]

## Package boundaries and module layout

A package is the set of Go files in one directory; files in that directory compile together and share unexported identifiers.[7][8]
Start a small package at the module root with `go.mod`, implementation files, and `_test.go` files beside them.[7]
A module is a versioned collection of packages, and its `go.mod` module path prefixes the import paths of those packages.[8]
Use the repository path as the module path when the module will be published, and keep `go.mod` and `go.sum` under version control.[30][31]
Run `go mod tidy` through the Go tool so the dependency declarations and checksums stay consistent.[30][31]
Keep one module in a repository by default; split modules only when packages need independent release or dependency boundaries.[7][8]
Put commands in `cmd/<name>` when a repository contains both binaries and importable packages.[7]
Put implementation packages that are not public API under `internal`; the Go tool prevents outside modules from importing them.[7][22]
Do not add a `pkg` directory merely as taxonomy; choose directories whose package names and purposes are already clear.[22]
Keep the import graph acyclic; an import cycle is illegal and usually signals entangled ownership or a boundary in the wrong place.[8][32]
Dependency hygiene can be better than reusing a large dependency for one small helper.[32]

Name packages with short, lower-case, meaningful nouns that describe what they provide.[1][6]
Avoid catch-all names such as `util`, `common`, `helper`, `api`, `types`, or `interfaces`.[2][5][6][21]
If a package name cannot form a clear prefix at its call sites, reconsider the package abstraction boundary.[6]
Do not repeat the package name in exported identifiers: prefer `http.Server` to `http.HTTPServer`.[1][6]
Keep tightly coupled types and their unexported helpers together when clients need them together.[5]
If a hypothetical client must import two closely related packages to use either meaningfully, consider combining them.[5]
Split a package when a concept is genuinely distinct and a smaller package gives clients a clearer import and identifier.[5]
Do not split files by a one-type-per-file rule; group related code and keep each file focused and findable.[5]
Avoid both a single file with thousands of lines and a forest of tiny files; file size is a navigation heuristic, not an API boundary.[5]

## Interfaces

An interface describes behavior, and a type satisfies it implicitly; use that structural property to reduce coupling.[1][5]
Begin with a concrete implementation and a real consumer; do not invent an interface before a use case exists.[2][5]
The consumer usually owns the interface and should list only the methods it actually uses.[2][5]
Use an interface when several implementations must serve one consumer, when a consumer needs to hide a large surface, or when a real boundary requires it.[5]
Do not define an implementor-side interface solely to make mocking convenient; test the real public API or define the consumer's small interface.[2][5]
Prefer one or two method interfaces that compose cleanly; larger interfaces are harder to implement and substitute.[1][5]
Return concrete types by default so callers retain useful methods and future implementations can grow without interface churn.[2][5]
Return an interface when it is the product or protocol, when runtime choice requires it, or when exposing extra methods would break an invariant.[5]
Document interface contracts, edge cases, ownership, error semantics, and concurrency expectations.[5][26]
Use compile-time interface assertions at unusual implementation boundaries, not as decoration on every satisfying type.[1]
The standard library's `io.Reader`, `io.Writer`, and composed interfaces are a verified model of small, capability-focused contracts.[26]

## Naming, comments, and API shape

Use `MixedCaps` and `mixedCaps`, not underscores, for Go identifiers.[1][3]
Keep initialisms consistent: write `URL`, `HTTP`, `ID`, and `DB`, not `Url`, `Http`, `Id`, or `Db`.[2][4]
Use short receiver names derived from the type, consistently across methods; do not use `this`, `self`, or `me`.[2][4]
Do not prefix ordinary getters with `Get`; use the concept name unless “get” describes an actual operation such as HTTP GET.[1][4]
Choose variable-name length from scope and use: short local names are fine in tiny scopes, while long-lived or ambiguous values need more context.[4]
As a rough, non-normative guide, small scopes are 1–7 lines, medium scopes 8–15, large scopes 15–25, and very large scopes exceed 25 lines.[4]
Use package and type context to remove redundant words, but keep names specific enough to distinguish similar values.[3][4]
Write package comments adjacent to the package clause, and document non-obvious lifecycle or cleanup obligations.[2][5]
Keep error strings lower-case and without terminal punctuation unless a proper noun or acronym requires capitalization.[2]

## Errors

Return errors as the final result, check them, handle them, or return them; do not discard them with `_` without a documented reason.[1][2]
Use an additional `bool` or `error` result instead of an in-band sentinel such as `-1`, `nil`, or an empty string when validity needs signaling.[2]
Use `panic` only for unrecoverable programmer or package-internal conditions; normal operation errors belong in the returned `error`.[1][2]
Add useful operation or input context while preserving an underlying error when callers should inspect it.[1][11]
Wrap with `%w` when the underlying identity or type is part of the package contract; use `%v` when you intentionally hide that dependency.[11]
Use `errors.Is` for sentinel or equivalent matching and `errors.As` for extracting a documented error type through wrappers.[11][12]
Define a sentinel only when callers need stable identity, and document which error properties callers may rely on.[11][12]
Implement `Unwrap` on custom errors that contain an underlying error and preserve useful structured fields for callers.[11]
Use `errors.Join` when several independent failures must be returned together, and let callers inspect the resulting error tree.[12]
Test error semantics such as nilness, `Is`, `As`, and documented fields rather than brittle human-readable strings.[18]
Document significant sentinel values, concrete error types, pointer versus value form, and cleanup obligations in package or API comments.[5]

## Contexts

Accept `context.Context` explicitly as the first parameter, conventionally named `ctx`.[2][9]
Propagate the incoming context across the whole request or RPC call chain, deriving deadlines or cancellation only when the operation owns that policy.[9][10]
Do not store a context in a struct, pass a nil context, or use context values for optional parameters; use `context.TODO()` when the correct parent is not known yet.[9]
Call the cancel function returned by `WithCancel`, `WithTimeout`, or `WithDeadline` on every control-flow path.[9]
Use context values only for request-scoped data that crosses API or process boundaries, and use a typed key owned by the package.[9][10]
Make cancellation observable in loops and channel operations, and return `ctx.Err()` unless the API documents different behavior.[5][9][14]
Document unusual cancellation, deadline, lineage, or value requirements instead of repeating the default context contract.[5]

## Concurrency

Concurrency is a way to structure independently executing work; it is not the same thing as parallelism.[15]
Start a goroutine only when its owner can state how it exits, how it reports failure, and how its resources are reclaimed.[2][23]
Use channels when communication and synchronization clarify ownership, but use `sync.Mutex` or `sync/atomic` for small shared-state problems when they are simpler.[1][13][15]
Serialize every concurrent read and write to shared data with channels, locks, or atomic operations; data-race-free programs have sequentially consistent behavior.[13]
Run `go test -race` on concurrent code and realistic workloads; the race detector only finds races on executed paths.[19]
Bound worker counts or queue capacity deliberately; do not create an unbounded goroutine per request when a worker pool or semaphore is sufficient.[1][13]
Make pipeline stages close their outbound channels after all sends, and coordinate fan-in closure with `sync.WaitGroup`.[14]
When downstream code can stop early, propagate cancellation to every upstream sender instead of guessing a buffer size.[14]
Use directional channel types to make send and receive ownership visible in function signatures.[1][14]
Never send on a channel after its owner closes it, and make the close responsibility unambiguous.[14]
In tests, wait for spawned goroutines and report their failures through safe result channels or `t.Error`; only the test goroutine may call `t.Fatal` or `FailNow`.[5][18]

## Tests and examples

Put tests in `_test.go` files, name unit tests `TestXxx`, accept `*testing.T`, and run them with `go test`.[16][17]
Use the package's own name for white-box tests, and a `<package>_test` package for black-box tests of exported behavior.[17]
Use table-driven tests when cases share setup and assertions; use separate test functions when cases require different logic.[18][24]
Name subtests for humans and include inputs or descriptions in failures; never make reviewers count table rows.[18]
Report failures as `Function(input) = got, want want`, with the actual value before the expected value.[18]
Compare stable semantics, full structures, and documented error behavior instead of incidental serialized output or error text.[18]
Prefer `t.Error` when independent checks can continue; reserve `t.Fatal` for setup that makes the current test impossible.[18]
Use `t.Helper` for setup and cleanup helpers, not for assertion helpers that hide where a test failed.[5][18]
Add runnable `Example` functions when a package needs to show a complete call sequence; examples also exercise the documented usage.[2][3]
Use fuzz tests for parsers, decoders, and security-sensitive input boundaries; make fuzz targets fast, deterministic, and free of persistent global state.[20]
Run fuzz tests with `go test -fuzz=...`, preserve minimized failures in the seed corpus, and treat them as regression tests.[20]
Use coverage to find untested branches and cases, not as a target that proves correctness.[29]
The official `golang/example/hello` repository and standard-library tests are useful executable examples of module and test layout.[25][28]

## Simplicity and size heuristics

Review in this order: clarity, simplicity, concision, maintainability, then consistency.[3]
Use the least mechanism that makes the behavior clear; add complexity only for a measured requirement or a deliberate public-API tradeoff.[3]
If a function feels too long, too repetitive, or too deeply nested, change its semantic boundaries rather than counting lines.[2][3]
Avoid long parameter lists and adjacent parameters of the same type; use a documented option struct when many inputs are genuinely needed.[5]
Keep contexts out of option structs and configuration state; they describe call lifetime, not object configuration.[5][9]
Treat exported types, interfaces, dependencies, and package names as cognitive and maintenance costs.[3][5]
Keep a package large enough to contain one coherent domain and small enough for its docs and call sites to remain navigable.[5]
Keep related unexported implementation details together, and split only when a distinct concept or ownership boundary improves use.[5]
Prefer a focused file layout with related code grouped together; do not use file count as a proxy for quality.[5]
When an interface, helper package, or dependency exists only to avoid a little duplication, reconsider the boundary first.[5][21]

## Sources

### Official Go documentation

[1] [Effective Go](https://go.dev/doc/effective_go)
[2] [Go Code Review Comments](https://go.dev/wiki/CodeReviewComments)
[6] [Package names](https://go.dev/blog/package-names)
[7] [Organizing a Go module](https://go.dev/doc/modules/layout)
[8] [Go Modules Reference](https://go.dev/ref/mod)
[9] [context package documentation](https://pkg.go.dev/context)
[10] [Go Concurrency Patterns: Context](https://go.dev/blog/context)
[11] [Working with Errors in Go 1.13](https://go.dev/blog/go1.13-errors)
[12] [errors package documentation](https://pkg.go.dev/errors)
[13] [The Go Memory Model](https://go.dev/ref/mem)
[14] [Go Concurrency Patterns: Pipelines and cancellation](https://go.dev/blog/pipelines)
[16] [Go tutorial: Add a test](https://go.dev/doc/tutorial/add-a-test)
[17] [testing package documentation](https://pkg.go.dev/testing)
[18] [Go Test Comments](https://go.dev/wiki/TestComments)
[19] [Data Race Detector](https://go.dev/doc/articles/race_detector)
[20] [Go Fuzzing](https://go.dev/doc/security/fuzz/)

### Google team guidance

[3] [Google Go Style Guide](https://google.github.io/styleguide/go/guide)
[4] [Google Go Style Decisions](https://google.github.io/styleguide/go/decisions)
[5] [Google Go Best Practices](https://google.github.io/styleguide/go/best-practices)

### Practitioner guidance

[21] [Dave Cheney: Avoid package names like base, util, or common](https://dave.cheney.net/2019/01/08/avoid-package-names-like-base-util-or-common)
[22] [Dave Cheney: Use internal packages to reduce your public API surface](https://dave.cheney.net/2019/10/06/use-internal-packages-to-reduce-your-public-api-surface)
[23] [Dave Cheney: Never start a goroutine without knowing how it will stop](https://dave.cheney.net/2016/12/22/never-start-a-goroutine-without-knowing-how-it-will-stop)
[24] [Dave Cheney: Prefer table driven tests](https://dave.cheney.net/2019/05/07/prefer-table-driven-tests)

### Maintainer examples and talks

[15] [Go Concurrency Patterns talk by Rob Pike](https://go.dev/talks/2012/concurrency.slide)
[25] [Official Go examples: hello module](https://github.com/golang/example/tree/master/hello)
[26] [Go standard library: io interfaces](https://github.com/golang/go/blob/master/src/io/io.go)
[27] [Go standard library: context source](https://github.com/golang/go/blob/master/src/context/context.go)
[28] [Go standard library: strings tests](https://github.com/golang/go/blob/master/src/strings/strings_test.go)
[29] [The cover story](https://go.dev/blog/cover)
[30] [Managing dependencies](https://go.dev/doc/modules/managing-dependencies)
[31] [How to Write Go Code](https://go.dev/doc/code)
[32] [Rob Pike: Go at Google: Language Design in the Service of Software Engineering](https://go.dev/talks/2012/splash.article)
