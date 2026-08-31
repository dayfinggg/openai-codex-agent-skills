# Errors and exception filters

Throw `HttpException` subclasses for expected HTTP failures.
Nest's built-in exception layer handles `HttpException` and returns a generic response for unknown exceptions. [Nst7]
Create a custom exception hierarchy when domain errors need stable mapping.
Use a global exception filter for the public error contract and cross-cutting logging.
Use controller or method filters only for intentionally local response policies.
Remember that middleware exceptions are handled only by global filters because middleware runs before route selection. [Nst7]
Do not expose stack traces, SQL, tokens, file paths, or upstream credentials.
Log unknown exceptions with the original error, request identifier, route, and safe context.
Do not catch an error merely to log it and continue with inconsistent state.
If a response has started, finish or abort the stream and never write a second response.
