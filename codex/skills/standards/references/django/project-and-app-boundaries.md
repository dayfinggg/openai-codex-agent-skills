# Project and app boundaries

- Treat each Django app as a self-contained Python package with models, migrations, admin, URLconf, views, templates or static files, and tests. [D1]
- Keep project settings, the root URLconf, and ASGI or WSGI entrypoints in the project package.
- Keep business capability code in apps, and compose those apps through `INSTALLED_APPS` and the root URLconf. [D1]
- Include app URLconfs from the root URLconf so each capability owns its route patterns. [D2]
- Use a package or app boundary when code has a distinct owner, lifecycle, migration set, or public interface.
- Keep the project package as a composition root for middleware, installed apps, URL routing, and deployment entrypoints.
- Avoid database queries, network calls, or registration work during module import unless Django explicitly requires the registration.
- Do not create controller, service, repository, and mapper folders by habit.
- Add a use-case function when a workflow crosses models, requires one transaction, or coordinates an external system.
