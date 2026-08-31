# Concurrency

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
