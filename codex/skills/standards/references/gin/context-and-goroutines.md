# Context and goroutines

- Extract r.Context from c.Request and pass it to every service, database, and outbound client operation.
- Use context.Context as the first parameter below the Gin boundary.
- Do not store gin.Context or a request context in a long-lived object.
- Gin reuses gin.Context objects through a pool, so never retain the original context in a goroutine after the handler returns.
- If an unavoidable background goroutine needs read-only request metadata, follow Gin's c.Copy guidance and capture only immutable values.
- A copied context is not permission to write a response after return or to abandon cancellation and shutdown ownership.
- Give every goroutine an owner, stop condition, failure path, and join or queue lifecycle.
- Use an application context for work that intentionally outlives the request.
