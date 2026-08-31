# Database boundary

- Construct one async database pool at startup and place its cloneable handle in `AppState` [D1].
- Keep SQL, row decoding, and driver errors in an infrastructure or repository module, not in route modules.
- Let an application service own the use-case transaction scope, and keep the transaction short around the writes that must commit together [D2].
- Acquire a connection close to the query and release it before unrelated network or rendering awaits.
- Use bound parameters and database constraints, and consider SQLx compile-time checked queries when SQLx is the selected driver [D3].
- Configure pool size, acquire timeout, query timeout, and shutdown behavior from deployment limits [D1].
- Test migrations, constraints, query shape, and transaction rollback against an isolated real database.
