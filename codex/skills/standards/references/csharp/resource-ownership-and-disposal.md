# Resource ownership and disposal

- Dispose resources that the type owns; document ownership when a dependency is borrowed or transferred.
- Prefer `using` and `await using` scopes so cleanup runs when the body exits through success, return, or exception.
- Implement `IDisposable` only when the type owns disposable or unmanaged resources, or when a base-class contract requires it.
- For a non-sealed disposable base class, use a non-virtual public `Dispose()` and a protected virtual `Dispose(bool)` pattern.
- Make disposal idempotent and reject operations that cannot work after disposal with `ObjectDisposedException`.
- Prefer `SafeHandle` to hand-written finalizers for unmanaged handles.
- Treat finalizers as an advanced last resort; they delay cleanup and complicate object-state assumptions.
- Implement `IAsyncDisposable` when cleanup itself must await asynchronous work.
- A type with both synchronous and asynchronous resources will often need both `IDisposable` and `IAsyncDisposable` paths.
- For a non-sealed async-disposable base class, centralize overridable cleanup in `DisposeAsyncCore()`.
- Never make callers guess whether they must dispose an object; state lifetime rules in the API documentation and tests.
