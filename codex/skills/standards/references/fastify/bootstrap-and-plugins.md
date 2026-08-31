# Bootstrap and plugins

Create the Fastify instance in a factory and keep `listen` in a separate bootstrap function.
Register decorators, schemas, hooks, routes, and plugins before `listen`, `inject`, or `ready` starts the instance. [F5]
Use `register` for routes, utilities, and integrations so initialization and teardown follow the plugin graph. [F5]
Use encapsulation to keep feature decorators, hooks, schemas, and error handlers local. [F6]
Break encapsulation with `fastify-plugin` only when a capability is intentionally shared. [F6]
Declare plugin dependencies and register them in dependency order.
Keep plugin initialization asynchronous and fail startup when a required dependency cannot initialize.
Release plugin resources in `onClose` after traffic has drained. [F3]
Do not hide a database client or queue consumer in an unregistered module singleton.
