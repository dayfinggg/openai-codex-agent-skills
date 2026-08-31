# Performance and lifecycle

Do not use synchronous filesystem, compression, crypto, or child-process APIs in request handlers.
Bound JSON, regular-expression, decompression, and upload work before processing it.
Use streaming APIs for large responses and preserve backpressure.
Use compression middleware where it improves the measured response path, and avoid compressing already-compressed media. [E3]
Cache only responses with explicit freshness and invalidation rules.
Set server and upstream timeouts; do not rely on a reverse proxy to protect every deployment.
Start clients and pools during bootstrap, and close them during graceful shutdown.
Keep the `app` object independent from `http.Server` so `server.close()` can stop new connections and drain active work. [N1]
On client disconnect, cancel only safely cancellable work and give committed side effects a durable transaction, queue, or job owner.
If a close or abort listener can outlive successful completion, remove it in `finally`; `{ once: true }` removes it only when abort fires. [N4]
In Express 5, handle the `app.listen` callback's error argument rather than assuming bind failures throw synchronously. [E6]
Use readiness checks that fail before traffic reaches an uninitialized dependency.
