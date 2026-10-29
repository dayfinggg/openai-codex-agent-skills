---
name: go-change
description: "Change Go packages or services with context, goroutine, resource, and race verification. Use for Go implementation, debugging, and concurrency changes."
---

Preserve Go package contracts and verify concurrency along executed paths.

1. Identify the toolchain, go.mod requirements, workspace, build tags, and existing check commands. Read callers and the project's error conventions.
2. Trace context.Context from the request boundary through I/O. Identify cancellation, deadline, and resource ownership. Do not substitute a background context merely to bypass cancellation.
3. For every new goroutine, establish its termination condition and who joins or observes it. Check blocked channel sends, receives, and early consumer exit. Preserve the established channel-ownership contract.
4. Inspect shared maps, slices, and structures. Use the smallest synchronization mechanism with clear ownership. An absence of panic does not prove an absence of races.
5. Verify response-body, file, transaction, and cursor cleanup on success and failure. Preserve error wrapping where callers rely on identity.
6. Run formatting, existing static analysis, and affected package tests. For shared-memory or concurrency changes, use go test -race on a supported platform.
7. Verify cancellation and termination where relevant. For performance work, compare benchmarks with equivalent inputs and conditions.

The race detector checks executed paths only. A clean run is not proof of all possible interleavings. Do not claim a concurrency fix is verified if the failing path was never exercised.

Consult the [Go Race Detector](https://go.dev/doc/articles/race_detector), [Context](https://pkg.go.dev/context), and [Go Modules](https://go.dev/ref/mod).

