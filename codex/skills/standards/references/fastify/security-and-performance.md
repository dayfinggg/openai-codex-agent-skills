# Security and performance

Prefer Fastify-native plugins such as `@fastify/helmet`, `@fastify/cors`, and `@fastify/static` over Express middleware where available. [F10]
Fastify does not provide Express-style middleware by default; use a supported plugin only when a native hook or plugin is not appropriate. [F10]
Apply security plugins before the routes they protect and scope them through encapsulation when needed.
Keep request body limits, parameter limits, and handler timeouts explicit.
Use response schemas and compiled serializers on hot routes after measuring their effect. [F1]
Avoid synchronous work and unbounded loops in handlers and hooks.
Use streams and `stream.pipeline()` for large transfers and abort propagation. [N5]
Benchmark the complete service under representative payloads and concurrency.
Use event-loop delay, memory, file descriptors, pool saturation, and error rate as capacity signals.
