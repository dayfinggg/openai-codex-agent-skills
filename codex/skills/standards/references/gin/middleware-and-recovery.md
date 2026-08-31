# Middleware and recovery

- Gin middleware runs in registration order before c.Next and resumes after c.Next returns.
- Keep middleware responsibilities narrow and make global, group, and route-level placement explicit.
- Put request ID, trusted proxy handling, limits, authentication, authorization, recovery, and logging in a reviewed order.
- Do not use middleware as a hidden service locator or as a place to mutate global state.
- Gin's built-in Recovery catches a panic and writes a 500, but custom recovery is needed for service-owned logging or envelopes.
- A custom recovery must write a generic 500 only when the response is not committed.
- After response commit, log the panic and abort or close according to the protocol; never write a second error body.
- Do not expose the recovered panic value, stack, or internal error text to clients.
- Ensure recovery does not run twice through Gin and an outer net/http wrapper.
- Fail closed when authentication or trusted proxy configuration is incomplete.
