# When Echo is justified

- Choose Echo when an existing service or team needs its routing, binding, middleware, rendering, or centralized error pipeline.
- Prefer net/http or chi for a new small service when Echo would add unused policy or lifecycle surface.
- Echo v5 uses the github.com/labstack/echo/v5 import path and requires Go 1.25 or newer.
- Pin the major version and confirm the service toolchain before adopting Echo v5.
- Keep echo.Context out of services, repositories, domain entities, and persistence models.
- Do not mix Echo routing with a second router abstraction in one service.
