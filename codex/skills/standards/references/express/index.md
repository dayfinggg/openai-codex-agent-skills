# Express 5 backend standards

Build on [framework-neutral Node.js backend standards](../node-backend/index.md).
Use Express 5 as an explicit middleware and routing pipeline, not as a hidden application container.
Keep the app factory separate from the server bootstrap so tests can import the app without binding a port.

## Reference map

- [Composition and request boundaries](composition-and-request-boundaries.md)
- [Parsing and validation](parsing-and-validation.md)
- [Async handlers and errors](async-handlers-and-errors.md)
- [Security](security.md)
- [Performance and lifecycle](performance-and-lifecycle.md)
- [Logging and observability](logging-and-observability.md)
- [Testing](testing.md)
- [Choose Express deliberately](choose-express-deliberately.md)
- [Sources](sources.md)
