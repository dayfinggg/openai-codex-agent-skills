# Async lifecycle

Return or await provider, factory, module, and lifecycle promises.
Create external clients during module initialization and close them during application shutdown.
Use `OnModuleInit` or `OnApplicationBootstrap` for asynchronous readiness checks. [Nst3]
Do not report readiness until required dependencies are usable.
Enable `enableShutdownHooks()` when process signals must trigger Nest shutdown handlers. [Nst3]
Make shutdown idempotent and bound the drain window.
Let the HTTP adapter stop new requests before providers release shared clients.
When a transport exposes a client-abort signal, cancel only safely cancellable work.
Give committed side effects a durable transaction, queue, or job owner instead of cancelling them on disconnect.
If an abort listener can outlive successful completion, remove it in `finally`; `{ once: true }` removes it only when abort fires. [Nst13]
Do not schedule asynchronous work from a `process.on('exit')` handler. [N4]
