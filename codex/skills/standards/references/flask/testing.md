# Testing

- Use an app fixture that calls `create_app()` and enables `TESTING=True`. [L9]
- Use Flask's test client for request, cookie, session, redirect, JSON, form, and error-handler behavior. [L9]
- Use the CLI runner for commands and database initialization workflows. [L9]
- Use an application or request context only for code that truly requires one. [L3] [L9]
- Use a full request when testing dispatch and `before_request`; a manually pushed request context does not run full dispatch. [L9]
- Test extension setup, teardown cleanup, database rollback, CSRF, host validation, and session flags.
- Keep external services behind explicit adapters and replace them with fakes or test endpoints in ordinary tests.
- Use the maintained Flask tutorial example as a compact reference for the factory, blueprints, extension setup, tests, and CLI workflow. [L13]
