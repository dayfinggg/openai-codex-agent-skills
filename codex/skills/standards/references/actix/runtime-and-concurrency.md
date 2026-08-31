# Runtime and concurrency

- Actix Web runs on Tokio, and each server worker uses a single-threaded runtime [B9].
- Each worker processes its requests sequentially, so blocking a handler, extractor, lock, or destructor stalls that worker [B1].
- Use async network and database clients, and avoid synchronous filesystem, DNS, compression, or CPU work in request futures.
- Use `web::block` or `actix_web::rt::task::spawn_blocking` for bounded blocking operations [B10] [T10].
- Bound CPU-heavy jobs with a semaphore or dedicated pool, and use a dedicated thread for long-lived blocking loops [B10] [T10].
- Use a bounded channel and an owner task when a shared client or mutable resource should have one clear owner [T2].
- Keep lock guards short and never hold a blocking lock across `.await` [T1].
- Use `#[tokio::main]` when the surrounding application needs Tokio's work-stealing runtime, but use `#[actix_web::main]` for Actix actor support and its local task system [B9].
- Track spawned background work with join handles or `JoinSet`; do not detach work whose failure affects service correctness [T9].
- Use cancellation-aware `select!` and make request side effects safe if a future is dropped [T5].
