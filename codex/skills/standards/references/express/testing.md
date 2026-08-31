# Testing

Export the app factory and test it without calling `listen` when possible.
Use an ephemeral port for tests that require a real server.
Exercise the real middleware order with malformed input, unsupported media types, auth failures, and oversized bodies.
Test returned and unreturned promise failures, error middleware, headers-sent behavior, and not-found handling.
Assert response shape and redaction as well as status and headers.
Close the server, clients, timers, and pools in teardown.
Use Node's `node:test` runner or the project's existing runner for deterministic unit and boundary tests. [N9]
Keep a small integration suite for proxy trust, TLS, uploads, streaming, and dependency wiring.
