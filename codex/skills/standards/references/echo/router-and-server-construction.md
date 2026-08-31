# Router and server construction

- Construct one Echo instance during startup and register routes from feature-owned composition functions.
- Use method-specific helpers such as GET, POST, PUT, PATCH, and DELETE.
- Use groups for a shared prefix and shared authentication or authorization middleware.
- Echo prioritizes static routes over parameter routes and parameter routes over wildcards.
- Avoid Any for state-changing endpoints because it accepts every HTTP method.
- Keep route patterns stable for logs, metrics, and API documentation.
- Pass Echo as the Handler of an explicit http.Server when TLS, timeouts, or graceful shutdown need service-owned control.
- Configure read, write, idle, and header limits on that server.
- Keep startup errors fatal and observe server errors until shutdown.
