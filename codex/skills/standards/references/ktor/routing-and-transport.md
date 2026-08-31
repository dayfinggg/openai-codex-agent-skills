# Routing and transport
- Group routes by feature or resource and use `Route` extension functions to keep the top-level routing block readable.
- Use nested `route` blocks when path ownership and resource relationships are clear.
- Parse path and query parameters explicitly and return a deliberate 400 response for invalid input.
- Use `ContentNegotiation` and typed serialization for request and response DTOs.
- Keep database entities and internal domain values out of public JSON unless their contracts are intentionally identical.
- Keep route handlers free of SQL, transaction policy, secret handling, and broad exception translation.
