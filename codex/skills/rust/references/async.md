# Async Rust and tokio

Match async APIs to the versions in the project lockfile. For current Tokio APIs, consult [the versioned Tokio documentation](https://docs.rs/tokio/latest/tokio/).

Rules for async code on Rust 1.85 and later with tokio 1.x.

## Traits and closures

- `async fn` in a public trait gives callers no way to require a `Send` future (`async_fn_in_trait` lint). Declare `fn run(&self) -> impl Future<Output = T> + Send` instead of allowing the lint or adding `#[async_trait]`. Implementations may still write `async fn run(&self) -> T`. The `trait-variant` crate generates a `Send` and a local variant.
- Traits with `async fn` or `-> impl Trait` methods are not dyn compatible. For `dyn` dispatch keep `async-trait` or return `Pin<Box<dyn Future<Output = T> + Send + '_>>`.
- `AsyncFn*` bounds (1.85) cannot require a `Send` future, because return type notation is still unstable, and `AsyncFn*` traits are not dyn compatible. For spawned callbacks use `F: Fn(X) -> Fut, Fut: Future<Output = T> + Send + 'static`.

## Locks and blocking

- Use `std::sync::Mutex` or `parking_lot` for plain data in async code. Use `tokio::sync::Mutex` only when the guard must live across `.await`, mainly for IO resources.
- `spawn_blocking` tasks cannot be aborted once started and runtime shutdown waits for them. Use `std::thread::spawn` for long-lived blocking loops. Bound CPU-heavy work with rayon or a `Semaphore`, because the blocking pool limit is very large.

## Cancellation

- In `loop { tokio::select! { .. } }` the futures of the losing branches are dropped. `read_exact`, `read_to_end`, `read_to_string` and `write_all` lose data, and `Mutex::lock`, `RwLock::read`, `Semaphore::acquire` and `Notify::notified` lose their place in the queue. Use cancel-safe calls such as `mpsc::Receiver::recv`, `read` and `StreamExt::next`, or pin the future before the loop and poll `&mut fut`.
- Dropping a `JoinHandle` does not stop the task. Keep tasks in a `JoinSet`, which aborts them when it is dropped, or call `abort()`.

## tokio versions

- tokio 1.54 needs Rust 1.85. The LTS lines are 1.51.x (until March 2027) and 1.53.x (until September 2027), both with MSRV 1.71. Pin one with `tokio = { version = "~1.53", ... }`.
