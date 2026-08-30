# Django web standards

Use this reference for Django applications and services.
Use `python.md` for Python naming, typing, packaging, exceptions, async primitives, and general testing rules.
Prefer Django's built-in contracts before adding framework extensions or architectural layers.
Treat the versioned Django documentation as normative when it conflicts with this reference.

## Project and app boundaries

- Treat each Django app as a self-contained Python package with models, migrations, admin, URLconf, views, templates or static files, and tests. [D1]
- Keep project settings, the root URLconf, and ASGI or WSGI entrypoints in the project package.
- Keep business capability code in apps, and compose those apps through `INSTALLED_APPS` and the root URLconf. [D1]
- Include app URLconfs from the root URLconf so each capability owns its route patterns. [D2]
- Use a package or app boundary when code has a distinct owner, lifecycle, migration set, or public interface.
- Keep the project package as a composition root for middleware, installed apps, URL routing, and deployment entrypoints.
- Avoid database queries, network calls, or registration work during module import unless Django explicitly requires the registration.
- Do not create controller, service, repository, and mapper folders by habit.
- Add a use-case function when a workflow crosses models, requires one transaction, or coordinates an external system.

## URLs, requests, and responses

- Use named URL patterns and `reverse()` instead of hardcoding URLs in Python or templates. [D2]
- Remember that URLconf matching does not inspect the HTTP method.
- Enforce allowed methods in the view or with a suitable method decorator. [D2]
- Keep request parsing, authorization, application calls, response selection, and status codes visible in the view boundary.
- Keep domain and persistence code independent of `HttpRequest`, `HttpResponse`, and template concerns where practical.
- Return the correct `HttpResponse`, `JsonResponse`, redirect, and status for each operation.
- Use root `handler400`, `handler403`, `handler404`, and `handler500` only when the default error views do not meet the contract. [D2]
- Keep middleware for cross-cutting request and response policy, not for business workflows tied to one model. [D9]
- Django middleware runs as an onion: request code follows declared order and response code runs in reverse order. [D9]
- Treat middleware order as a dependency contract, such as sessions before authentication middleware. [D9]
- Avoid unexpected middleware short-circuits, especially when they bypass authentication, CSRF checks, logging, or response cleanup. [D9]

## Validation, models, and ORM use

- Validate untrusted form data through `is_valid()` and the documented cleaning pipeline. [D3]
- Use explicit serializers or schemas for JSON APIs instead of passing arbitrary request dictionaries into model constructors.
- Keep request shape validation separate from cross-record business invariants and database constraints.
- Treat a model as the authoritative definition of stored data and its essential behavior. [D4]
- Put row-level behavior on model methods and table-wide query behavior on managers or querysets. [D4] [D5]
- Use the ORM directly for ordinary CRUD and query composition; do not wrap every queryset in a repository. [D5]
- Understand that querysets are lazy and evaluate them deliberately. [D6]
- Measure query counts and use documented eager-loading or projection techniques when an access path is slow. [D7]
- Keep query helpers close to the app or model that owns their meaning.
- Use database constraints for uniqueness, referential integrity, and invariants that must hold across all callers. [D4]
- Do not rely on overridden `save()` or signals to enforce behavior that bulk operations can bypass. [D4]
- Use raw SQL sparingly, keep parameters separate from SQL text, and review every raw query as security-sensitive. [D11]

## Transactions and errors

- Wrap the smallest multi-write use case in `transaction.atomic()`. [D8]
- Catch database exceptions around an inner atomic block rather than inside the block so Django can roll back correctly. [D8]
- Use `transaction.on_commit()` for jobs, notifications, cache invalidation, or messages that must follow a successful commit. [D8]
- Keep transaction orchestration in an application function when it spans several models; keep simple model writes direct.
- Map expected not-found, permission, validation, and conflict conditions to stable HTTP responses.
- Keep unexpected exceptions as server failures, log them once at the boundary that can act, and do not expose tracebacks or SQL.
- Test both the response contract and the database state after expected failures.

## Async and request concurrency

- Use ASGI for genuinely asynchronous request handling, long-lived I/O, or high in-process concurrency. [D10]
- Use WSGI when the project is otherwise synchronous and has no async workload that benefits from ASGI. [D10]
- Use async ORM methods and `async for` where supported. [D10]
- Wrap synchronous-only code with `sync_to_async()` from an async view rather than calling the synchronous ORM directly. [D10]
- Keep transaction-bearing work in one synchronous function called through an adapter because Django transactions do not yet work in async mode. [D10]
- Disable persistent database connections in async mode and use a backend or pool sized for the target concurrency. [D10]
- Keep third-party middleware and libraries on the same sync or async path where possible to avoid repeated adaptation.
- Do not enable `DJANGO_ALLOW_ASYNC_UNSAFE` in production to silence safety checks. [D10]

## Security

- Treat all user-controlled input as untrusted and validate it before application work. [D11]
- Keep CSRF protection enabled for cookie-authenticated state changes and avoid `csrf_exempt` unless the threat model requires it. [D11]
- Keep template autoescaping enabled, review `safe` and `mark_safe`, and use a suitable CSP for content that needs stronger isolation. [D11]
- Prefer queryset parameterization and review `RawSQL`, custom SQL, and `extra()` carefully. [D11]
- Set `ALLOWED_HOSTS` and use Django's host validation rather than reading an untrusted `Host` header directly. [D11] [D14]
- Enforce site-wide HTTPS for authenticated traffic, enable secure session and CSRF cookies, and configure HSTS where appropriate. [D11] [D14]
- Keep `DEBUG` false in production because debug responses disclose source, settings, local variables, and library details. [D14]
- Treat uploaded media as untrusted content, prevent execution by the web server, and consider serving it from a separate origin. [D11] [D14]

## Configuration and deployment

- Keep development and production settings distinct, and load production secrets from environment or secret storage. [D12] [D14]
- Set `DJANGO_SETTINGS_MODULE` or use the documented settings configuration path before accessing Django settings. [D12]
- Keep `SECRET_KEY` large, random, private, and out of source control. [D14] [D15]
- Use the maintained project settings template as a baseline, then review every generated production setting. [D15]
- Run `manage.py check --deploy` against the actual production settings before release. [D14]
- Replace `runserver` with a production WSGI or ASGI server. [D14]
- Define `STATIC_ROOT` and run `collectstatic` for production static files. [D14]
- Serve media through a controlled storage or web-server path that cannot execute uploaded code. [D14]
- Apply migrations deliberately and ensure one controlled process performs one-time migration work before workers accept traffic.
- Configure health checks, structured logs, metrics, timeouts, graceful shutdown, backups, and database connection limits.

## Testing

- Use `django.test.TestCase` for database tests that need transaction isolation and a clean database. [D13]
- Split a growing `tests.py` into a test package with focused model, view, form, API, and integration modules. [D13]
- Use Django's test client for URL, middleware, authentication, form, template, and error behavior. [D16]
- Use `RequestFactory` only when deliberately bypassing routing and middleware. [D16]
- Enable `enforce_csrf_checks=True` in tests that prove CSRF behavior. [D16]
- Test migrations and constraints on the database engine used in production when portability or backend behavior matters.
- Test transaction rollback, `on_commit()` behavior, idempotency, authorization, and safe error responses.
- Keep external services behind explicit adapters and replace them with fakes or test endpoints in ordinary tests.

## Sources

### Official Django and Python documentation

- [D1: Django reusable apps](https://docs.djangoproject.com/en/6.0/intro/reusable-apps/)
- [D2: Django URL dispatcher](https://docs.djangoproject.com/en/6.0/topics/http/urls/)
- [D3: Django form and field validation](https://docs.djangoproject.com/en/6.0/ref/forms/validation/)
- [D4: Django models](https://docs.djangoproject.com/en/6.0/topics/db/models/)
- [D5: Django managers](https://docs.djangoproject.com/en/6.0/topics/db/managers/)
- [D6: Django making queries](https://docs.djangoproject.com/en/6.0/topics/db/queries/)
- [D7: Django database access optimization](https://docs.djangoproject.com/en/6.0/topics/db/optimization/)
- [D8: Django database transactions](https://docs.djangoproject.com/en/6.0/topics/db/transactions/)
- [D9: Django middleware](https://docs.djangoproject.com/en/6.0/topics/http/middleware/)
- [D10: Django asynchronous support](https://docs.djangoproject.com/en/6.0/topics/async/)
- [D11: Django security](https://docs.djangoproject.com/en/6.0/topics/security/)
- [D12: Django settings](https://docs.djangoproject.com/en/6.0/topics/settings/)
- [D13: Django testing overview](https://docs.djangoproject.com/en/6.0/topics/testing/overview/)
- [D14: Django deployment checklist](https://docs.djangoproject.com/en/6.0/howto/deployment/checklist/)
- [D16: Django testing tools and test client](https://docs.djangoproject.com/en/6.0/topics/testing/tools/)

### Maintainer examples

- [D15: Django maintained project settings template](https://github.com/django/django/blob/main/django/conf/project_template/project_name/settings.py-tpl)
