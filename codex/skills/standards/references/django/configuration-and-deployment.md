# Configuration and deployment

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
