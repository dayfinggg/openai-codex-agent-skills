# Express, Fastify, Hono and NestJS

## Express 5

- Async handlers may throw or reject. Express 5 passes the error to the error handler, so no `try` and `catch` wrapper or `express-async-handler` is needed.
- Wildcards are named (`/*splat`) and optional segments use braces (`/:file{.:ext}`). Regular expression characters in path strings are not supported.
- `req.body` is `undefined` until a body parser runs. `express.urlencoded` defaults to `extended: false`.
- Use `app.delete`, `res.status(code).json(body)`, `res.sendStatus(code)`, `res.redirect(status, url)` and `res.sendFile`. The Express 4 forms `app.del`, `req.param()`, `res.send(status)`, `res.json(obj, status)` and `res.sendfile` are removed.

## Fastify 5

Declare JSON schemas for `body`, `querystring`, `params`, `headers` and `response` on every route. Validation and fast serialization come from them, and response schemas drop fields that are not declared.

## Hono

Write handlers inline on the route so types flow through. Split a large app into sub-apps joined with `app.route()`, and export the app type for the typed `hc` client.

## NestJS 12

Create projects with `nest new`. Validate with `ValidationPipe` using `whitelist`, `forbidNonWhitelisted` and `transform`, or with `StandardSchemaValidationPipe` and a Zod or Valibot schema.

## Choosing for a new service

Use what the project already uses. For a new small API, Hono or Fastify. For a large team codebase that wants modules and dependency injection, NestJS. Use Express when its middleware ecosystem is a requirement.
