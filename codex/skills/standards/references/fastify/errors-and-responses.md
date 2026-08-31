# Errors and responses

Fastify catches synchronous and async route errors and routes them to its error handler. [F2]
Use `Error` instances with stable application codes, causes, and safe status metadata.
Register one root `setErrorHandler` for the public error contract, with narrower handlers only inside intentional plugin scopes. [F2]
Replace unexpected dependency messages with a generic 500 response and log the original error.
Do not forward database messages, SQL, stack traces, tokens, or internal paths.
Remember that Fastify's default serializer forwards `message` and `code` unless the application replaces them. [F2]
Use `reply.sent` and clear returns to prevent duplicate sends.
Do not throw strings or arbitrary primitives from routes or hooks; throw `Error` instances. [F2]
Keep error handlers free of new failure paths, and let parent handlers handle errors outside their scope.
Use response schemas for both success and deliberately shaped error responses.
