<overview>
This file holds Django facts that models often miss, current for November 2026, and an access control guide. It covers Django 5.2 LTS, 6.0, and 6.1, and Django REST framework (DRF). Read `django-performance.md` for query performance reviews.
</overview>

<versions>
Django 6.1 is the current feature release, and 6.1.3 is its latest patch. Check the installed version in `pyproject.toml`, the lockfile, or `python -m django --version` before you use a version-specific API.

| Series | Python | Mainstream support ends | Extended support ends |
|--------|--------|-------------------------|-----------------------|
| 5.2 LTS | 3.10-3.14 | December 2025 | April 2028 |
| 6.0 | 3.12-3.14 | August 2026 | April 2027 |
| 6.1 | 3.12-3.15 | April 2027 | December 2027 |

Django 5.2 is the last series that supports Python 3.10 and 3.11. Django 6.1 supports Python 3.15 from 6.1.3. Django 6.1 requires PostgreSQL 15, MySQL 8.4, MariaDB 10.11, or SQLite 3.37 or later.

The release cycle becomes annual after 6.2. Django 6.2 is the next LTS, planned for April 2027. Django 2028.0 follows in January 2028 and replaces the planned 7.0. Deprecation warnings use the calendar name, such as `RemovedInDjango2028Warning`.
</versions>

<django_5_2>
Django 5.2 added features that 5.2 LTS projects can use.
- `models.CompositePrimaryKey("field_a", "field_b")` declares a primary key over several fields. Assign and filter it with a tuple in the declared order.
- A composite primary key has hard limits. A `ForeignKey` or generic relation cannot point to such a model, and the admin cannot register it. Migrations cannot add or remove it after the table exists.
- `manage.py shell` imports the models of all installed apps automatically.
- `reverse()` accepts `query` and `fragment` arguments.
- `HttpRequest.get_preferred_type()` picks a media type for content negotiation.
- `values()` and `values_list()` return fields in the order the call names them.
</django_5_2>

<django_6_0>
Django 6.0 was released in December 2025 and changed several defaults.
- `DEFAULT_AUTO_FIELD` defaults to `django.db.models.BigAutoField`. Set it to `django.db.models.AutoField` to keep the old key type in an older project.
- Content Security Policy is built in. Add `django.middleware.csp.ContentSecurityPolicyMiddleware`, and set `SECURE_CSP` or `SECURE_CSP_REPORT_ONLY` to a dict. Use the `django.utils.csp.CSP` constants, such as `CSP.SELF` and `CSP.NONCE`, for quoted sources.
- The `django.template.context_processors.csp` context processor provides the nonce for templates.
- Template partials are built in. `{% partialdef name %}` defines a fragment, `{% partial name %}` renders it, and `"page.html#name"` loads it alone.
- `django.tasks` defines background tasks with the `@task` decorator and `.enqueue()`, or `.aenqueue()` in async code.
- `Model.save()` raises `Model.NotUpdated` when a forced update affects no rows.
- `django.db.models.StringAgg` works on all backends, and `AnyValue` returns an arbitrary non-null value.
- `AsyncPaginator` and `AsyncPage` serve async views.
- Django uses the modern Python email API, so `EmailMessage.message()` returns an `email.message.EmailMessage`.
</django_6_0>

<tasks_framework>
The tasks framework defines and queues work, but Django ships no worker. The built-in `ImmediateBackend` (the default) runs tasks at once, and `DummyBackend` only stores them. Both are for development and tests, so production needs a third-party backend and its worker. Task arguments and return values must survive a `json.dumps()` and `json.loads()` round trip. Pass ids instead of model instances, and convert `datetime` and tuple values. Enqueue work that reads new rows inside `transaction.on_commit(partial(task.enqueue, ...))`.
</tasks_framework>

<django_6_1>
Django 6.1 was released in August 2026.
- `QuerySet.fetch_mode()` controls how Django loads a missing field. `models.FETCH_ONE` is the default, `models.FETCH_PEERS` loads the field for the whole queryset in one query, and `models.FETCH_RAISE` raises `FieldFetchBlocked`.
- A custom manager can set a fetch mode in `get_queryset()` as the model default. Related objects inherit the fetch mode of the instance that loaded them.
- `ForeignKey.on_delete` accepts `models.DB_CASCADE`, `models.DB_SET_NULL`, and `models.DB_SET_DEFAULT`, which use SQL `ON DELETE`. `DB_CASCADE` sends no `pre_delete` or `post_delete` signals.
- The `MAILERS` setting configures several email backends by alias. It deprecates `EMAIL_BACKEND`, the related `EMAIL_*` settings, `mail.get_connection()`, and the `connection` and `fail_silently` arguments.
- `JSONNull()` matches a top-level JSON `null`. Passing `None` for that purpose is deprecated.
- `UUID4` and `UUID7` database functions generate UUIDs in the database.
- `first()` and `last()` no longer order by primary key after `order_by()` with no arguments.
- `select_related()` with no arguments and `values_list(flat=True)` without a field name are deprecated.
</django_6_1>

<removed_apis>
These APIs are gone, so replace them when an upgrade fails.
- `DEFAULT_FILE_STORAGE`, `STATICFILES_STORAGE`, and `get_storage_class()` were removed in 5.1. Use the `STORAGES` setting and `storages["alias"]`.
- `Meta.index_together` was removed in 5.1. Use `Meta.indexes`.
- `CheckConstraint(check=...)` was removed in 6.0. Use `condition=`.
- Positional arguments to `Model.save()` and `Model.asave()` were removed in 6.0.
- `cx_Oracle` support was removed in 6.0. Use `oracledb`.
- Custom ORM expressions should return `as_sql()` params as a tuple from 6.0.
- In 6.1, `login()` and `alogin()` need an explicit user, and `find_all()` replaces `find(all=True)`.
</removed_apis>

<access_control>
Authorization in Django lives in querysets as much as in decorators. Most access bugs are views that fetch an object by id without scoping the query to the user or tenant. Review each view that reads or changes data with these rules.

<scope_querysets>
Scope every object lookup to what the user may see. This lookup returns any invoice whose id the caller guesses.

```python
invoice = get_object_or_404(Invoice, pk=pk)
```

This lookup returns 404 for invoices of other accounts.

```python
invoice = get_object_or_404(Invoice.objects.filter(account=request.user.account), pk=pk)
```

`get_object_or_404()` accepts a queryset, so pass the scoped one. Apply the same scope to list views, related lookups, bulk actions, and exports. A custom manager that filters by tenant helps, but check every use of a second unscoped manager.
</scope_querysets>

<require_login>
`LoginRequiredMiddleware` (Django 5.1 and later) makes login the default for every view. Add `django.contrib.auth.middleware.LoginRequiredMiddleware` after `AuthenticationMiddleware`. Mark public views, including the login view, with `@login_not_required` from `django.contrib.auth.decorators`. Without the middleware, each view needs `@login_required` or `LoginRequiredMixin`.

Login is not authorization. Use `PermissionRequiredMixin` or `@permission_required` for model permissions. Use `UserPassesTestMixin` with `test_func()` for rules about the object or the user.
</require_login>

<drf_permissions>
DRF views opt out of `LoginRequiredMiddleware`, and DRF allows all requests by default. Set `DEFAULT_PERMISSION_CLASSES` in `REST_FRAMEWORK` to include `rest_framework.permissions.IsAuthenticated`, or set `permission_classes` on each view.

`has_object_permission()` runs only when a generic view calls `get_object()`. It does not run for list views, and a custom view that never calls `get_object()` skips it. Scope `get_queryset()` to the user, so list, detail, update, and delete all share one filter.

```python
class InvoiceViewSet(viewsets.ModelViewSet):
    serializer_class = InvoiceSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return Invoice.objects.filter(account=self.request.user.account)
```

Check writable serializer fields too. A related field that accepts any primary key lets a user attach objects of another tenant. Limit its `queryset` or validate it.
</drf_permissions>

<admin_scoping>
Override `ModelAdmin.get_queryset(request)` to limit the objects that staff users see. The change and delete views look objects up through it. Override `has_change_permission(request, obj)` and the related methods for rules that depend on the object.
</admin_scoping>
</access_control>
