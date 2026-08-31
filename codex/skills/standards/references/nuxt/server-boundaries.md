# Server boundaries

- Put HTTP API handlers under `server/api/`, route handlers under `server/routes/`, and cross-request middleware under `server/middleware/`.
- Export handlers with `defineEventHandler` or its supported alias and return a response or promise through the Nitro contract. [N6]
- Keep authentication, authorization, parsing, validation, serialization, and error mapping at the server boundary.
- Keep server middleware from returning a response accidentally when it is intended only to enrich the request context. [N5]
- Put reusable server-only helpers in `server/utils/` and shared app/server helpers in `shared/`.
- Do not use app auto-imports as a reason to cross the app and Nitro boundary.
