# Next.js caching and Cache Components

Cache APIs and defaults are release-specific. Confirm the project's exact version, configuration, and the official guide before changing cache behavior.

## Cache boundaries

- Identify the cache boundary that owns the behavior before changing it. Request-time data, shared cached data, route output, and client cache are separate layers.
- A cached result may be shared across requests and users. Include all data that determines the result in its key, and do not cache tenant- or user-specific data under a shared key.
- Pass simple serializable values across cache boundaries. Read request context outside a shared cache scope unless the installed release explicitly supports the intended access pattern.
- Choose freshness and invalidation from the product's data contract. Use the invalidation API that matches the caller and read-your-writes requirement.
- Check the cache handler and deployment topology. An in-memory cache may not persist across serverless instances or deployments.

## Migration from route-level caching

Before enabling or removing a cache mode, inspect route segment exports, fetch options, `unstable_cache`, request APIs, and config flags. Search the full route tree, not only the route named in the task. Confirm which behavior the old settings provided, because a removed option may have kept data static, dynamic, or cached across deployments.

Treat codemod output as a proposed migration. Review its complete diff, count the target files, and verify the path before trusting a successful command result. Preserve request-time and privacy requirements. Complete the migration only when the applicable type check and build pass and a browser or request test confirms the intended rendering and freshness.

## Common failure modes

- Request APIs such as cookies, headers, route params, and search params may be asynchronous and may prevent static rendering when awaited outside a streaming boundary.
- A promise for request-time data passed into a cache scope can prevent prerendering. Await it outside the scope and pass only the required value if the documented API requires it.
- A cache backed by local memory may not be shared across instances or survive a deployment.
- Cache APIs may not apply in proxy or middleware execution.
- Module-level state in a server-rendered application is shared across concurrent requests. Do not keep user or request data there.
- Server Components should call the underlying data function directly instead of calling the application's own route handler over HTTP during prerendering.
- Catch blocks can swallow framework control-flow signals such as redirects or not-found errors. Follow the installed framework guidance for rethrowing them.
