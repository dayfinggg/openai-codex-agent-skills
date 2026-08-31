# Router and server construction

- Use gin.New when the service needs an explicit middleware stack.
- Use gin.Default only when its built-in logger and recovery behavior are deliberately part of the service policy.
- Register route groups for shared prefixes and shared authorization policy.
- Register method-specific routes and avoid Any-style catch-all behavior for state-changing endpoints.
- Keep route registration in startup composition code rather than package init functions.
- When server timeouts, TLS, or graceful shutdown matter, pass the Gin handler to an explicit http.Server instead of hiding lifecycle in router.Run.
- Configure read, write, idle, and header limits on that http.Server.
- Keep route patterns stable for metrics and logs, and do not log raw query strings by default.
