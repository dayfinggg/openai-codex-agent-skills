# Security and performance

Run a maintained Node.js LTS release and keep it current.
Pin and review dependencies, audit vulnerabilities, and remove unused packages.
Use TLS at the application or trusted proxy boundary and configure proxy trust deliberately.
Keep secrets in a protected environment or secret manager, never in source or logs.
Prevent path traversal, command injection, SSRF, open redirects, brute force, and resource amplification.
Apply authentication before authorization and check authorization at each protected capability.
The Node Permission Model reduces accidental resource access but is not a malicious-code sandbox. [N7]
Keep every event-loop callback and worker-pool task small and bounded. [N8]
Do not use synchronous filesystem, compression, crypto, or child-process APIs on request paths. [N8]
Bound input before expensive JSON, regular-expression, decompression, or cryptographic work.
Review regular expressions for catastrophic backtracking and prefer linear-time alternatives. [N8]
Offload CPU-heavy work to workers or a queue, or partition it so the event loop yields.
Set connection, header, request, upstream, handler, and queue timeouts with an owner for each.
Use Node's header and request timeout controls to protect slow clients when the proxy does not. [N1]
Benchmark the complete service under representative load instead of trusting synthetic framework rankings.
Use event-loop delay, memory, file descriptors, pool saturation, and error rate as capacity signals.
