<overview>
This file covers Laravel application structure, dependencies, naming, configuration, collections, and Blade views for Laravel 12 and 13. Read it when you add classes, wire dependencies, touch config or environment values, or work in Blade.
</overview>
<contents>
This file has these sections, in order.
- actions
- dependency injection
- framework conventions
- naming
- idiomatic syntax
- utilities
- deterministic order
- locks
- deferred work
- context
- concurrency
- configuration
- collections
- blade
- scripts and assets
- view composers
- fragments
</contents>


<actions>
Extract a discrete business operation into an action class when that makes it easier to reuse or test. Laravel gives action classes no special meaning, so follow the project's naming and invocation style.

```php
class CreateOrderAction
{
    public function __construct(private InventoryService $inventory) {}

    public function handle(array $data): Order
    {
        $order = Order::create($data);
        $this->inventory->reserve($order);

        return $order;
    }
}
```
</actions>

<dependency_injection>
Use constructor injection for dependencies an object needs for its whole lifetime. Use method injection for a dependency that one controller action, listener, job handler, or other container-invoked method needs. Avoid `app()` and `resolve()` where normal injection can make the dependency explicit.

This controller action hides its dependency behind `app()`.

```php
public function store(StoreOrderRequest $request)
{
    $service = app(OrderService::class);

    return $service->create($request->validated());
}
```

This version declares the dependency in the method signature.

```php
public function store(StoreOrderRequest $request, OrderService $service)
{
    return $service->create($request->validated());
}
```

Depend on a contract at a system boundary, such as a payment gateway or an external service. Do so when tests or swappable implementations justify the interface. Bind the contract in a service provider.

```php
interface PaymentGateway
{
    public function charge(int $amount, string $customerId): PaymentResult;
}

class OrderService
{
    public function __construct(private PaymentGateway $gateway) {}
}
```

```php
$this->app->bind(PaymentGateway::class, StripeGateway::class);
```
</dependency_injection>

<framework_conventions>
Follow Laravel's table, key, and pivot conventions unless the domain or an existing schema needs an override. A conventional model needs no table, key, or pivot arguments.

```php
class Customer extends Model
{
    public function roles(): BelongsToMany
    {
        return $this->belongsToMany(Role::class);
    }
}
```

A legacy schema justifies overrides such as `protected $table = 'Customer'`, a custom primary key, and explicit pivot columns.
</framework_conventions>

<naming>
New code uses Laravel's naming conventions. An established project convention wins unless a coordinated rename is worth it.

| Element | Convention | Example |
| --- | --- | --- |
| Controller | Singular resource name | `ArticleController` |
| Model | Singular StudlyCase | `User` |
| Table | Plural snake_case | `article_comments` |
| Pivot table | Singular model names in alphabetical order, in snake_case | `article_user` |
| Column | snake_case | `meta_title` |
| Foreign key | Singular model name plus `_id` | `article_id` |
| Resource URI | Plural resource | `articles/1` |
| Route name | Dotted segments, snake_case inside a segment | `users.show_active` |
| Method and variable | camelCase | `getAll`, `$articlesWithAuthor` |
| Collection variable | Descriptive and plural | `$activeUsers` |
| View | kebab-case | `show-filtered.blade.php` |
| Config file | snake_case | `google_calendar.php` |
| Enum | Singular StudlyCase | `UserType` |
</naming>

<idiomatic_syntax>
Use Laravel helpers and query methods when they state the intent more directly. Do not shorten code when the result is ambiguous or loses type information.

| Verbose form | Idiomatic form |
| --- | --- |
| `Session::get('cart')` | `session('cart')` |
| `return Redirect::back()` | `return back()` |
| `Carbon::now()` | `now()` |
| `->where('column', '=', 1)` | `->where('column', 1)` |
| `->orderBy('created_at', 'desc')` | `->latest()` |
| `->orderBy('created_at', 'asc')` | `->oldest()` |
| `->first()?->name` | `->value('name')` when only that value is needed |

Use typed request accessors such as `$request->string()`, `$request->integer()`, and `$request->boolean()` when their coercion fits. `Config::string()`, `Config::integer()`, `Config::boolean()`, and `Config::array()` read config values with a type check.
</idiomatic_syntax>

<utilities>
The `Str`, `Arr`, `Number`, and `Uri` classes give expressive, framework-consistent operations. Prefer them when they are clearer or safer than the plain PHP call, not for every built-in function. These calls show typical uses.

```php
$slug = Str::slug($title);
$short = Str::limit($text, 100);
$result = Str::of($input)->trim()->replace('_', '-')->lower();
$name = Arr::get($array, 'user.name', 'default');
$public = Arr::only($attributes, ['name', 'email']);
```

Use `Number` only for localized display, not for values you store or calculate.

```php
Number::format(1000000);
Number::currency(1500, 'USD');
Number::fileSize(1024 * 1024);
```

`Illuminate\Support\Uri` builds and transforms URIs in Laravel 12 and later.

```php
$uri = Uri::of('https://example.com/search')
    ->withQuery(['q' => 'laravel', 'page' => 1]);
```

Without a Laravel helper, use the multibyte functions such as `mb_strlen()` and `mb_strtolower()` for UTF-8 text. `strlen('José')` returns 5 bytes, and `strtolower()` leaves `Ü` unchanged. `Str::length()` and `Str::lower()` are multibyte-aware.
</utilities>

<deterministic_order>
Row order without an explicit `ORDER BY` is undefined. Choose an order that fits the feature, and add a unique tie-breaker when pagination must be stable.

```php
$posts = Post::query()
    ->orderByDesc('created_at')
    ->orderByDesc('id')
    ->paginate();
```
</deterministic_order>

<locks>
Use a lock when concurrent processes must run one at a time. `Cache::lock()` gives an atomic lock when the cache store supports locks. `lockForUpdate()` locks selected rows and must run inside a database transaction. The two solve different coordination problems. Set the lease (10 seconds below) longer than the callback can ever run. Another process can take an expired lock.

```php
Cache::lock('order-processing-'.$order->id, 10)->block(5, function () use ($order) {
    $order->process();
});
```

```php
DB::transaction(function () use ($id) {
    $product = Product::where('id', $id)->lockForUpdate()->first();
    $product->decrement('stock');
});
```
</locks>

<deferred_work>
`defer()` runs a callback after Laravel sends the HTTP response, in the same PHP process. Use it for light work that needs no retries or crash durability. Use a queued job when the work needs retries, queue controls, or durability across process failures.

```php
defer(fn () => PageView::create(['page_id' => $page->id, 'user_id' => auth()->id()]));
```
</deferred_work>

<context>
The `Context` facade shares data across the current request, command, or job without passing it through every layer. Laravel adds visible context to log entries and restores all context in queued jobs. `Context::addHidden()` stores data that reaches queued jobs but stays out of logs. Put secrets in context only when you want them to reach queued jobs too.

```php
Context::add('tenant_id', $request->header('X-Tenant-ID'));

$tenantId = Context::get('tenant_id');
```
</context>

<concurrency>
`Concurrency::run()` runs independent closures in parallel through the configured driver. The default `process` driver boots the application in a separate PHP process for each closure. Use it only when the parallel work outweighs process and serialization overhead. The faster `fork` driver needs `spatie/fork` and works only on the CLI. The `sync` driver runs the closures in sequence and mainly helps in tests.

```php
[$users, $orders] = Concurrency::run([
    fn () => User::count(),
    fn () => Order::where('status', 'pending')->count(),
]);
```
</concurrency>

<configuration>
<env_only_in_config>
Call `env()` only inside files in `config/`. After `php artisan config:cache`, Laravel does not load `.env`, so `env()` returns only real system environment variables. Application code reads values through `config()`.

```php
return [
    'key' => env('API_KEY'),
];
```

```php
$key = config('services.key');
```
</env_only_in_config>

<environment_checks>
Check the environment with `app()->isProduction()` or `App::environment('production')`, not with `env('APP_ENV')`. `App::environment(['local', 'staging'])` matches any listed value.
</environment_checks>

<secrets>
Never commit a plaintext production `.env` file. `php artisan env:encrypt --env=production --readable` writes an encrypted `.env.production.encrypted` file that is safe to commit. The `--readable` option keeps variable names visible and drops comments. `php artisan env:decrypt --env=production` reads the key from `LARAVEL_ENV_ENCRYPTION_KEY` or `--key`. Hosted deployments can inject secrets at runtime from the platform's secret store instead.
</secrets>

<named_values>
Use an enum or a class constant for a domain value that repeats or belongs to a fixed set. A one-off string literal does not need a constant. In a localized application, put user-facing strings in language files and read them with `__('app.article_added')`.
</named_values>
</configuration>

<collections>
<higher_order_messages>
Higher-order messages shorten simple collection calls. `$users->each->markAsVip()` replaces a closure that only calls `markAsVip()`. They work with methods such as `each`, `map`, `filter`, and `sum`. Use a closure when arguments or real logic make it clearer.
</higher_order_messages>

<bulk_operations>
`toQuery()` builds a query from the models in an Eloquent collection, so you need no manual `whereIn` on the keys. It needs a non-empty collection of one model type. Like other bulk updates, it fires no per-model events, so use it only when you do not need them.

```php
$users->toQuery()->update(['active' => false]);
```
</bulk_operations>

<custom_collections>
The `#[CollectedBy]` attribute declares a custom collection class without a `newCollection()` override.

```php
#[CollectedBy(UserCollection::class)]
class User extends Model {}
```
</custom_collections>

<streaming>
Choose between `cursor()`, `lazy()`, and `lazyById()` as `laravel-database.md` describes in its large data section.
</streaming>
</collections>

<blade>
<components>
Use a Blade component when a reusable interface benefits from explicit props, an attribute bag, or slots. An include still suits a small partial that uses the current view data on purpose. Pass an explicit data array to an include when implicit variables would hide its dependencies.

Use the attribute bag in component templates so callers can add attributes. `merge()` combines defaults with caller values and merges `class` values specially.

```blade
<div {{ $attributes->merge(['class' => 'alert alert-'.$type]) }}>
    {{ $message }}
</div>
```

`@aware` gives a nested component a prop that a caller passed to an ancestor component. It does not expose the ancestor's default prop value unless that value went through the attribute bag.
</components>

<scripts_and_assets>
A component that renders many times adds a `@push` block on every render. Use a consistently named `@pushOnce` block to add the content once per response.

Put substantial JavaScript and CSS in the project's asset pipeline and components. Small page-specific scripts or styles can stay in Blade layouts or stacks. Pass server data to JavaScript with `Js::from()`, which encodes it safely.

```blade
<script>
    const article = {{ Js::from($article) }};
</script>
```

Data attributes suit small scalar values. A whole model in an attribute can expose extra fields and complicate escaping.
</scripts_and_assets>

<view_composers>
A view composer centralizes the data that one or more named views need on every render. Keep the composer compatible with every view it targets, and avoid broad wildcards when views need different data. A composer runs only when Laravel renders a matching view, so JSON and streamed responses do not get its data.
</view_composers>

<fragments>
A route can return a full view or a named fragment for clients such as htmx or Turbo.

```php
return view('dashboard', compact('users'))
    ->fragmentIf($request->hasHeader('HX-Request'), 'user-list');
```
</fragments>
</blade>
