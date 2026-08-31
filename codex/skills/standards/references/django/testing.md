# Testing

- Use `django.test.TestCase` for database tests that need transaction isolation and a clean database. [D13]
- Split a growing `tests.py` into a test package with focused model, view, form, API, and integration modules. [D13]
- Use Django's test client for URL, middleware, authentication, form, template, and error behavior. [D16]
- Use `RequestFactory` only when deliberately bypassing routing and middleware. [D16]
- Enable `enforce_csrf_checks=True` in tests that prove CSRF behavior. [D16]
- Test migrations and constraints on the database engine used in production when portability or backend behavior matters.
- Test transaction rollback, `on_commit()` behavior, idempotency, authorization, and safe error responses.
- Keep external services behind explicit adapters and replace them with fakes or test endpoints in ordinary tests.
