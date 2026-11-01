---
name: node-backend-change
description: "Change Node.js HTTP, cancellation, timeout, streaming, or resource-lifecycle behavior in services and standalone utilities. Use for request helpers, middleware, streams, and process lifecycle changes. Exclude pure value transformations without Node runtime behavior."
---

Verify the complete Node.js request and process lifecycle.

1. Establish the runtime version, framework, module mode, launch command, and shutdown mechanism. Read existing HTTP limits, middleware ordering, database clients, and external-service settings.
2. Trace input validation, authentication, authorization, errors, and responses. Preserve middleware ordering, accepted events, and public contracts.
3. Identify who owns each request, cancellation signal, deadline, and resource. Propagate cancellation into supporting dependencies. Stopping the wait does not necessarily stop the underlying operation.
4. For streams and large responses, verify backpressure, disconnection, partial responses, and cleanup of files or cursors. Do not raise buffering limits without evidence.
5. Check exceptions and rejected promises against the deployed Node version. Do not hide a failure with an always-successful response or continue a process whose state is invalid.
6. For shutdown, verify admission stops, active work drains, and connection pools close within the configured deadline. Work started during an HTTP request must not silently disappear after the response.
7. Run the original scenario and relevant dependency-failure, client-disconnection, and shutdown checks. Correlate observed errors and durations with logs.

Reuse framework and runtime mechanisms. Do not add unrelated middleware, retries, or signal handlers. Read the relevant sections of version-matched official documentation for the APIs and lifecycle behavior being changed. Use [Node.js HTTP](https://nodejs.org/api/http.html), [Streams](https://nodejs.org/api/stream.html), or [Globals](https://nodejs.org/api/globals.html) as applicable, not as a required reading list for every task.

