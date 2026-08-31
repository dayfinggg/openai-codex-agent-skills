# Application factory and state

- Keep `main` responsible for configuration, resource construction, `HttpServer` setup, and shutdown.
- Keep the `HttpServer::new` factory cheap because Actix instantiates an application per worker [B1].
- Actix starts one worker per available physical CPU by default, and `.workers(n)` changes that count [B1].
- Build shared pools, clients, and `web::Data` outside the factory when every worker must use the same resource [B1].
- Extract application data with `web::Data<T>`; handlers receive a read-only reference unless `T` provides explicit interior mutability [B2].
- Use `Arc`, atomics, locks, or an owner task deliberately when state must cross worker boundaries [B1].
- Remember that nested scopes resolve the closest data value, so scope-local data can shadow app-level data [B13].
- Keep worker-local state only when per-worker isolation is intentional and documented.
