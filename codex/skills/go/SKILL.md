---
name: go
description: Implements and tests Go changes with module, context, goroutine, and race checks. Use for Go code, go.mod, go.sum, or concurrency defects.
---

1. Before editing, run `go version` and `go env GOMOD GOWORK GOOS GOARCH CGO_ENABLED GOTOOLCHAIN`. Read `go.mod`, `go.work` if present, build tags, CI, and existing check commands. Establish the language baseline, selected toolchain, workspace modules, and target platform. Modern Go may select or download a different toolchain from the local default. Match changed APIs and loop-variable semantics to the module's language version.

2. For implementation or module work, read [the shared procedure](../python/references/common.md). Inspect callers and package error conventions. Keep small interfaces at their consumer when needed, preserve nil versus empty wire values, and handle typed-nil interfaces deliberately. Wrap with `%w` where callers use `errors.Is` or `errors.As`. Do not discard errors or introduce panic for ordinary failure.

3. Trace `context.Context` from the boundary through blocking I/O. Do not substitute `context.Background()` to bypass cancellation. Call owned cancel functions and establish how every goroutine terminates and is joined or observed. Cancellation signals do not wait for termination. Check blocked sends, receives, channel closure ownership, and early consumer exit. Protect shared maps, slices, and state with clear ownership and minimal synchronization. Avoid copying values containing mutexes.

4. Close response bodies, files, cursors, and transactions on success and failure. Register cleanup after successful acquisition. Check `defer` inside loops for resources retained until function return. Exercise cancellation and goroutine termination on the changed path rather than only testing a successful result.

5. Inspect selected dependencies with `go list -m all` and `replace`, `exclude`, and vendor configuration. `go.sum` contains checksums and is not a full lockfile. For an authorized dependency change, use the existing Go workflow, targeting `go get MODULE@VERSION` rather than an unbounded upgrade. Run `go mod tidy` when imports or dependencies changed, review `go.mod` and `go.sum`, and preserve the baseline, toolchain, replacements, and vendoring policy. Run `go mod verify` to check downloaded module-cache integrity when dependencies change. It does not prove vendored files are unchanged.

6. Before reporting, format touched files with `gofmt -w FILE`, run configured linters and `go vet PACKAGE`, then `go test -count=1 -timeout=2m PACKAGE` using the affected package path or pattern and actual build tags. Compilation checks Go types, vet detects additional suspicious constructs. Keep the repository's timeout when defined. For shared-memory or concurrency changes run `go test -race -count=1 -timeout=2m PACKAGE` on a supported target with its required C toolchain. A clean race run covers only executed paths. State an unsupported environment instead of claiming a race check passed. Use table-driven cases where behavior has variants and benchmarks only for requested performance work.

Consult [modules](https://go.dev/ref/mod), [context](https://pkg.go.dev/context), [vet](https://pkg.go.dev/cmd/vet), and [the race detector](https://go.dev/doc/articles/race_detector) for changed boundaries.
