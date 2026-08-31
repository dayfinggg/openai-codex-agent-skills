# Async and concurrency

An `async fn` creates a future; a runtime must poll that future for progress.
Choose async for many I/O-bound operations that benefit from cooperative waiting, and choose threads for blocking or parallel work when appropriate.
Treat threads and async tasks as complementary rather than mutually exclusive execution models.
Never perform unbounded blocking I/O or long CPU work on an async executor thread.
Use the runtime's blocking bridge or a dedicated worker for unavoidable blocking or CPU-bound operations.
Keep `.await` points visible and consider what state, locks, borrows, and cancellation can cross each one.
Do not hold a blocking mutex guard across `.await`; shorten the critical section or use an async-aware design deliberately.
Bound task counts, queue sizes, retries, and buffering so backpressure is explicit.
Propagate task errors and join or cancel spawned work according to the owning operation's lifecycle.
Require `Send` and `'static` only when the executor or spawned task actually requires them.
Use channels for ownership transfer and message passing when shared mutable state would add unnecessary coordination.
Use `Arc`, `Mutex`, `RwLock`, or atomics only with a clear contention and ordering model.
Make cancellation and drop behavior part of the API contract for operations that own external work.
Test async logic without a live server where possible by constructing an app or service value and calling it directly.
