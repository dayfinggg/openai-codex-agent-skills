---
name: node-backend-change
description: "Change Node.js backend behavior with HTTP, cancellation, timeout, streaming, and resource-lifecycle verification. Use for APIs, middleware, and Node service lifecycle work."
---

Verify the complete Node.js request and process lifecycle.

1. Establish the runtime version, framework, module mode, launch command, and shutdown mechanism. Read existing HTTP limits, middleware ordering, database clients, and external-service settings.
2. Trace input validation, authentication, authorization, errors, and responses. Preserve middleware ordering, accepted events, and public contracts.
3. Identify who owns each request, cancellation signal, deadline, and resource. Propagate cancellation into supporting dependencies. Stopping the wait does not necessarily stop the underlying operation.
4. For streams and large responses, verify backpressure, disconnection, partial responses, and cleanup of files or cursors. Do not raise buffering limits without evidence.
5. Check exceptions and rejected promises against the deployed Node version. Do not hide a failure with an always-successful response or continue a process whose state is invalid.
6. For shutdown, verify admission stops, active work drains, and connection pools close within the configured deadline. Work started during an HTTP request must not silently disappear after the response.
7. Run the original scenario and relevant dependency-failure, client-disconnection, and shutdown checks. Correlate observed errors and durations with logs.

Reuse framework and runtime mechanisms. Do not add unrelated middleware, retries, or signal handlers. Read version-matched [Node.js HTTP](https://nodejs.org/api/http.html), [Streams](https://nodejs.org/api/stream.html), and [Globals](https://nodejs.org/api/globals.html) documentation.

