# Laravel and Symfony

## Laravel 13 and later

- The skeleton is slim. Middleware, exceptions and routing are configured in `bootstrap/app.php` with `->withMiddleware(...)` and `->withRouting(...)`. There is no `app/Http/Kernel.php` and no `app/Console/Kernel.php`.
- `routes/` starts with `web.php` and `console.php`. Add API routes with `php artisan install:api`. Schedule tasks in `routes/console.php`.
- Validation lives in form requests (`php artisan make:request`) with `rules()` and `authorize()`. Use `$request->validated()` or `$request->safe()`, never `$request->all()` for writes.
- Responses go through API resources (`php artisan make:resource`, `$model->toResource()`, `whenLoaded()`).
- Eloquent casts are declared in a `casts(): array` method, enums are cast with `Status::class`, and accessors use `Attribute::make(get: ..., set: ...)`.
- Controller attributes such as `#[Middleware]` and `#[Authorize]`, and job attributes such as `#[Tries]`, `#[Backoff]` and `#[Timeout]`, replace the older properties and methods.
- Tests with Pest or PHPUnit through `php artisan test`. Style with `vendor/bin/pint`.

Do not write `Kernel.php` files, the `$casts` property, `getXAttribute` accessors, validation inside controllers or `$request->all()` passed to `create()`.

## Symfony 8 and later

- Routes as attributes: `#[Route('/orders/{id}', name: 'order_show', methods: ['GET'])]` from `Symfony\Component\Routing\Attribute\Route`.
- Services are autowired and autoconfigured by default. Inject dependencies through the constructor.
- Map requests with `#[MapRequestPayload]`, `#[MapQueryString]`, `#[MapQueryParameter]` and `#[MapUploadedFile]`. Validation failures return 422 automatically.
- Create projects with `symfony new my-app --webapp` or without `--webapp` for an API.

Do not write YAML or annotation routes in new code, or fetch services from the container directly.
