# Contexts

Accept `context.Context` explicitly as the first parameter, conventionally named `ctx`.[2][9]
Propagate the incoming context across the whole request or RPC call chain, deriving deadlines or cancellation only when the operation owns that policy.[9][10]
Do not store a context in a struct, pass a nil context, or use context values for optional parameters. Resolve context ownership before delivering the change. Use `context.Background()` only for a genuine root operation, not to discard an incoming cancellation scope. Do not leave `context.TODO()` as an unfinished design decision.[9]
Call the cancel function returned by `WithCancel`, `WithTimeout`, or `WithDeadline` on every control-flow path.[9]
Use context values only for request-scoped data that crosses API or process boundaries, and use a typed key owned by the package.[9][10]
Make cancellation observable in loops and channel operations, and return `ctx.Err()` unless the API documents different behavior.[5][9][14]
Expose unusual cancellation, deadline, lineage, or value requirements through the API contract or tests instead of repeating the default context contract in source prose.[5]
