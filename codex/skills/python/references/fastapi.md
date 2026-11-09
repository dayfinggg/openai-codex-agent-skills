<overview>
This file covers FastAPI facts from 2025 and 2026 that models often miss. It targets FastAPI 0.162 (October 2026) with Pydantic 2.9 or later and Starlette 1.x. Read the pinned FastAPI version in the lockfile first, and apply only the facts that version includes.
</overview>
<contents>
This file has these sections, in order.
- versions
- install and cli
- dependencies
- lifespan
- requests
- responses
- streaming
- security
- other features
- testing
</contents>


<versions>
FastAPI is still 0.x, and a minor release can break behavior. Read the [release notes](https://fastapi.tiangolo.com/release-notes/) for every version between the pinned one and the target before an upgrade. These floors and removals matter most.

| Release | Change |
| --- | --- |
| 0.122 | Security utilities return 401 with a `WWW-Authenticate` header instead of 403 |
| 0.126 | Pydantic v1 is no longer supported, and the floor is Pydantic 2.7 |
| 0.128 | The temporary `pydantic.v1` bridge is removed |
| 0.129 | Python 3.10 is the minimum |
| 0.132 | JSON bodies need a JSON `Content-Type` header by default |
| 0.134 | Starlette 0.46 is the minimum, and 1.x is supported since 0.133 |
| 0.135.2 | Pydantic 2.9 is the minimum |
| 0.137 | `router.routes` is a tree of included routers, not a flat list |
| 0.143 | Automatic OpenTelemetry exporter setup is opt-in |
| 0.148 | Defaults of omitted request parameters are not validated unless `validate_default=True` |
| 0.151 | An explicit JSON `null` differs from an omitted body value |
| 0.155 | Unknown keyword arguments to `Query`, `Body`, and the other parameter functions raise `TypeError` |

Python 3.14 needs Pydantic v2, because Pydantic v1 does not support it. The `fastapi-slim` package gets no new releases, so depend on `fastapi` or `fastapi[standard]`.
</versions>

<install_and_cli>
The `fastapi[standard]` extra adds the `fastapi` CLI, Uvicorn, `httpx2` for the test client, Jinja2, and `python-multipart`. It also adds `email-validator`, `pydantic-settings`, `pydantic-extra-types`, and the OpenTelemetry SDK. The extra includes `fastapi-cloud-cli` for `fastapi deploy` as well. The `fastapi[standard-no-fastapi-cloud-cli]` extra leaves that one out. Plain `fastapi` installs none of them.

Use `fastapi dev` for local work with auto-reload, and `fastapi run` in production. Both find the app through the `entrypoint` key in `pyproject.toml`, which editors and deploy tools also read.

```toml
[tool.fastapi]
entrypoint = "backend.main:app"
```

The `root_path` parameter of `FastAPI()` is deprecated since 0.146. Pass `--root-path /api/v1` to `fastapi run` instead.
</install_and_cli>

<dependencies>
Declare parameters and dependencies with `Annotated`, which the docs recommend over default values. A type alias then reuses one dependency across many endpoints.

```python
from typing import Annotated

from fastapi import Depends, FastAPI

app = FastAPI()

CurrentUser = Annotated[User, Depends(get_current_user)]


@app.get("/me")
def read_me(user: CurrentUser) -> UserOut:
    return user
```

A dependency with `yield` runs its exit code after the response is sent by default, which is `scope="request"`. Pass `Depends(session, scope="function")` to close the resource when the endpoint returns, before the response goes out. A request-scoped dependency may use only request-scoped sub-dependencies. A function-scoped dependency may use both scopes.

A `yield` dependency that catches an exception with `except` must re-raise it or raise a new one, such as `HTTPException`. A swallowed exception leaves FastAPI unaware of the error.
</dependencies>

<lifespan>
Startup and shutdown logic goes in a `lifespan` async context manager. The `@app.on_event("startup")` handlers are deprecated, and FastAPI ignores them once a `lifespan` is set.

```python
from contextlib import asynccontextmanager

from fastapi import FastAPI


@asynccontextmanager
async def lifespan(app: FastAPI):
    pool = await create_pool()
    app.state.pool = pool
    yield
    await pool.close()


app = FastAPI(lifespan=lifespan)
```
</lifespan>

<requests>
A Pydantic model can group `Query`, `Header`, `Cookie`, or `Form` parameters. Set `model_config = {"extra": "forbid"}` to reject unknown parameters. Since 0.160 the `extra` setting also applies to fields that a sibling parameter or dependency declares in the same location.

```python
from typing import Annotated, Literal

from fastapi import FastAPI, Query
from pydantic import BaseModel, Field

app = FastAPI()


class FilterParams(BaseModel):
    model_config = {"extra": "forbid"}

    limit: int = Field(100, gt=0, le=100)
    offset: int = Field(0, ge=0)
    order_by: Literal["created_at", "updated_at"] = "created_at"


@app.get("/items/")
def read_items(params: Annotated[FilterParams, Query()]) -> list[Item]:
    return list_items(params)
```

These request rules changed in October 2026.
- Since 0.148, a default for an omitted parameter is not user input. Validators skip it unless `validate_default=True` is set, and `model_dump(exclude_unset=True)` leaves it out.
- Since 0.149, an empty string in a form model counts as missing. Since 0.150, an unselected browser file input counts as missing too.
- Since 0.162, an omitted `bool` form field uses its declared default or fails as missing. Declare an HTML checkbox as `bool = False`.
- Since 0.155, extra JSON Schema keys go in `json_schema_extra`, as in `Query(json_schema_extra={"custom": "value"})`.

JSON request bodies need a valid JSON `Content-Type` header since 0.132. This default blocks a CSRF path against unauthenticated local apps. Set `FastAPI(strict_content_type=False)` only for clients that cannot send the header.
</requests>

<responses>
The return type annotation validates, documents, filters, and serializes the response. Pydantic serializes it in Rust, which the release notes measure at twice the old speed or more. Set `response_model` in the decorator when the function returns a different class than the API exposes. It takes priority over the return type. Set `response_model=None` to keep an annotation that is not a valid Pydantic type.

Filtering follows the declared type, not the runtime class. This endpoint returns a `UserIn` with a password, and the response holds only the `BaseUser` fields.

```python
from fastapi import FastAPI
from pydantic import BaseModel, EmailStr

app = FastAPI()


class BaseUser(BaseModel):
    username: str
    email: EmailStr


class UserIn(BaseUser):
    password: str


@app.post("/user/")
def create_user(user: UserIn) -> BaseUser:
    return user
```

`ORJSONResponse` and `UJSONResponse` are deprecated since 0.131, because a return type or `response_model` is faster. Use `a2wsgi.WSGIMiddleware` to mount a WSGI app, since `fastapi.middleware.wsgi.WSGIMiddleware` is deprecated.
</responses>

<streaming>
An endpoint that uses `yield` streams its items. The return type and the response class choose the format.

| Goal | Declaration | Result |
| --- | --- | --- |
| JSON Lines (0.134) | Return type `AsyncIterable[Item]` or `Iterable[Item]` | Each item is validated and sent as one line of `application/jsonl` |
| Server-Sent Events (0.135) | `response_class=EventSourceResponse` from `fastapi.sse` | Each item is JSON in the `data` field of an event |
| Raw bytes or text | `response_class=StreamingResponse` | Chunks bypass Pydantic, so set the media type |

Yield a `ServerSentEvent` to set `event`, `id`, `retry`, or a comment. Its `data` is always JSON-encoded, and `raw_data` sends preformatted text such as `[DONE]`. A plain `def` generator works too, and FastAPI runs it outside the event loop.
</streaming>

<security>
The built-in security classes such as `HTTPBearer` and `OAuth2PasswordBearer` answer missing credentials with 401 since 0.122. Clients that depend on the old 403 need a subclass that overrides `make_not_authenticated_error()` and returns the exception without raising it. Security dependencies also work on WebSocket endpoints since 0.144.
</security>

<other_features>
These features arrived in 2026.
- `app.frontend("/", directory="dist")` serves a built single-page app after the API routes (0.138). Its default `fallback="auto"` serves `404.html` or `index.html` only to browser navigations, so missing assets still return 404.
- FastAPI has native OpenTelemetry support (0.142). To configure exporters from the `OTEL_*` variables, set `FASTAPI_OTEL_AUTO_CONFIGURE=true` or pass `FastAPI(telemetry={"auto_configure": True})`.
- Routes added to a router after `include_router()` take effect, because inclusion keeps the router objects (0.137). Code that walked `router.routes` as a flat list must use `iter_route_contexts()` instead.
</other_features>

<testing>
`TestClient` runs the app inside plain `def` tests. Starlette builds it on `httpx2` and deprecates plain `httpx` for it. Use the client as a context manager when the test needs the lifespan to run.

```python
from fastapi.testclient import TestClient

from app.main import app


def test_read_item():
    with TestClient(app) as client:
        response = client.get("/items/foo")
    assert response.status_code == 200
```

Replace a dependency in tests through `app.dependency_overrides[get_db] = override_get_db`, and reset it to `{}` afterwards. For `async def` tests, mark them with `@pytest.mark.anyio` and send requests through `AsyncClient(transport=ASGITransport(app=app), base_url="http://test")`. Import both from `httpx2`, or from `httpx` on older setups. `AsyncClient` does not run the lifespan, so wrap the app in `LifespanManager` from `asgi-lifespan` when the test needs it.
</testing>
