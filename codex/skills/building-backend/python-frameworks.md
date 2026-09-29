# FastAPI and Django

## FastAPI

- Pydantic v2 only. Use `model_config`, `field_validator` and `model_validator`, not the v1 `Config` class and `validator`.
- Declare dependencies with `Annotated`, for example `SessionDep = Annotated[Session, Depends(get_session)]`, and reuse the alias.
- Startup and shutdown work goes in a `lifespan` async context manager passed to `FastAPI(lifespan=lifespan)`. Do not use `@app.on_event`.
- Install with `uv add "fastapi[standard]"` and run with `fastapi dev` or `fastapi run`.
- Separate request, response and database models. Set `response_model` or a return type on every route.

## Django 6 and later

- URLs with `path()` and `re_path()`. `url()` no longer exists.
- Storage settings in `STORAGES`, not `DEFAULT_FILE_STORAGE` or `STATICFILES_STORAGE`.
- Content Security Policy through the built-in `SECURE_CSP` setting.
- Background work with `django.tasks` and the `@task` decorator where the project has no queue yet.
- Async views with `async def` under ASGI, using the async ORM methods such as `aget`, `acreate` and `async for`. Transactions are still synchronous.
- `BigAutoField` is the default primary key.

Do not write `ugettext`, `force_text`, `index_together`, or raw SQL where the ORM expresses the query.
