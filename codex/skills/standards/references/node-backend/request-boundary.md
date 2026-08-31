# Request boundary

Model each request as receive, parse, authenticate, authorize, validate, execute, serialize, and finish.
Keep sockets, headers, cookies, status codes, and request streams in the transport layer.
Pass a typed command and explicit request context into application code.
Give every method and path one clear owner.
Make middleware or adapter setup order visible in one composition root.
Install request metadata and security controls before routes that depend on them.
Terminate a request exactly once.
Return immediately after sending a response.
Treat client disconnects as lifecycle events. Cancel only safely cancellable work, and give committed side effects a durable owner.
Set explicit limits for body bytes, header bytes, parameters, query fields, and upload parts.
Use streams for large bodies and responses instead of unbounded buffers.
Preserve backpressure across every stream boundary.
Set and enforce a supported `Content-Type`.
Parse URLs explicitly and normalize only what the contract permits.
Never infer authorization from a client-controlled value.
Create or validate a request identifier and carry it through downstream calls.

Node's HTTP API parses message framing but leaves header and body interpretation to the application. [N1]
