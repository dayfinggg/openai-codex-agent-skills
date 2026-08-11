# Go

Use the module's declared Go version, workspace policy, generators, and standard tooling. Treat `gofmt` output as the formatting gate. Check changed files with `gofmt -l path/to/file.go` and format them with `gofmt -w path/to/file.go`. Use a repository wrapper or `go fmt` only at the package scope the task authorizes. Use `go vet`, tests, race detection, fuzzing, and `govulncheck` when relevant.

Do not hand-normalize whitespace after `gofmt`. It emits tabs for indentation and uses spaces where needed for alignment. Go defines no maximum line width. When the repository has no width rule, use the line-width row in [code shape and naming](code-shape-and-naming.md) solely as this skill's local operational fallback. Use that reference unchanged for function, type, file, nesting, complexity, and parameter thresholds.

Use short lowercase single-word package names without underscores. Use `MixedCaps` or `mixedCaps`, not underscores, for multiword identifiers, and let the initial letter express export visibility. Name one-method interfaces by established behavior, commonly an `-er` form, only when that meaning fits. For ordinary source files, preserve package precedent. If none exists, use short descriptive lowercase filenames and underscores only where separation is needed. Preserve mechanically significant `_test.go`, GOOS, GOARCH, and build-constraint filename suffixes.

Keep packages cohesive, interfaces small and consumer-owned, zero values useful when practical, and dependencies explicit. Return errors as values, add context without destroying identity, use `errors.Is` or `errors.As` for inspectable causes, and handle an error once at the correct layer. Avoid panic for ordinary failures.

Propagate `context.Context` across cancellable request boundaries without storing it in long-lived structs. Make goroutine ownership, termination, channel closure, synchronization, and resource cleanup explicit. Prevent leaks and data races before optimizing concurrency.

Prefer readable expressions and refactor by responsibility and complexity rather than wrapping to an imported language convention.

Primary references: [Effective Go](https://go.dev/doc/effective_go), [Go Code Review Comments](https://go.dev/wiki/CodeReviewComments), [Go module organization](https://go.dev/doc/modules/layout), [Go compatibility](https://go.dev/doc/go1compat), and [Go security practices](https://go.dev/doc/security/best-practices).
