# Async and concurrency

- Axum is designed for Tokio and Hyper, so use async clients and avoid blocking the runtime worker [A1].
- Move synchronous I/O and bounded CPU work to `spawn_blocking`; bound many CPU jobs with a semaphore or a dedicated pool [T3] [T10].
- Do not detach background work from a request unless its durability and failure reporting are owned elsewhere.
- Keep `JoinHandle`s or use `JoinSet` for background task failure, cancellation, and shutdown ownership [T4] [T9].
- `join!` runs branches concurrently on one task, while spawned tasks can run in parallel on runtime workers when appropriate [T11].
- Use bounded channels for work queues and a dedicated owner task for a mutable connection or client [T2].
- Use a short synchronous lock for data-only critical sections, and do not hold any blocking lock across `.await` [T1].
- Apply Tower concurrency limits or bounded queues before expensive handlers to make overload behavior explicit [A11].
- Use `select!` with cancellation and dependency timeouts, and make side effects safe if a future is dropped [T5].
