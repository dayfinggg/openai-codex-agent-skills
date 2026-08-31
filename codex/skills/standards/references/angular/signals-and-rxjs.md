# Signals and RxJS

- Use `signal` for writable synchronous state and read it by calling the signal getter.
- Use `computed` for pure derived state; computed signals are lazy, memoized, and track only signals read by the derivation.
- Use `linkedSignal` when derived state must remain writable and reset or reconcile when its source changes.
- Use `effect` only for imperative side effects such as logging or synchronizing a non-reactive API.
- Do not use an effect to copy state, derive state, or create a second source of truth; use `computed` or restructure the state instead.
- Expose shared writable state as a readonly signal and expose mutation through named methods.
- Prefer immutable object and array updates so OnPush input comparisons observe changed references.
- Read signals before an `await` when the read must be tracked; reactive tracking does not cross an asynchronous boundary.
- Use RxJS for event streams, cancellation, time-based composition, WebSockets, and APIs that already expose Observables.
- Keep an Observable as an Observable when stream operators express the behavior more clearly than signal state.
- Use the `async` pipe for a template-only Observable and let Angular manage its subscription.
- Use `toSignal` once at a component or service boundary when imperative code or a template needs a current value.
- `toSignal` subscribes immediately and cleans up with the creating context, so do not call it repeatedly for the same Observable.
- Use `toObservable` when a signal must enter an RxJS pipeline, and remember that stabilized signal changes emit asynchronously.
- Use `takeUntilDestroyed` for subscriptions that cannot be expressed with `async`, `toSignal`, or another lifecycle-aware API.
- Treat `resource` or `httpResource` as optional signal-based async boundaries; use explicit loading and error states.
