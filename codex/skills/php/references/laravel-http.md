<overview>
This file covers the HTTP edge of a Laravel application. It covers routes, controllers, validation, security, outbound HTTP calls, and exception handling. It targets Laravel 13 (PHP 8.3 or newer) and notes where Laravel 12 differs.
</overview>

<routing>
<route_model_binding>
Implicit route model binding resolves models from route parameters. Use it when the default lookup and the 404 for a missing model fit the endpoint. This controller looks the model up by hand.

```php
public function show(int $id): View
{
    $post = Post::findOrFail($id);

    return view('posts.show', ['post' => $post]);
}
```

This version lets Laravel resolve the model.

```php
public function show(Post $post): View
{
    return view('posts.show', ['post' => $post]);
}
```
</route_model_binding>

<scoped_bindings>
Scoped bindings make a nested model resolve only when it belongs to its parent. They constrain model resolution and do not replace authorization. In this route, the resolved post belongs to the resolved user.

```php
Route::get('/users/{user}/posts/{post}', function (User $user, Post $post) {
    return view('posts.show', ['post' => $post]);
})->scopeBindings();
```
</scoped_bindings>

<resource_routes>
Use `Route::resource()` or `Route::apiResource()` when the endpoint follows the resource controller actions. Define explicit routes when the behavior does not fit that vocabulary. The second line registers an API-only resource.

```php
Route::resource('posts', PostController::class);

Route::apiResource('posts', ApiPostController::class);
```

`apiResource()` omits the HTML `create` and `edit` routes. It does not add an `/api` prefix. That prefix comes from the application's API route configuration.
</resource_routes>

<resource_controllers>
Organize each controller around one resource with the standard actions `index`, `show`, `create`, `store`, `edit`, `update`, and `destroy`. This keeps routes predictable and stops controllers from collecting unrelated behavior.

A custom action such as `publish`, `approve`, or `archive` can signal a separate resource. A focused controller gives that behavior its own authorization, validation, and middleware boundary. This route adds a custom action to the primary controller.

```php
Route::post('/podcasts/{podcast}/publish', [PodcastController::class, 'publish']);
```

These routes model the published podcast as its own resource.

```php
Route::post('/published-podcasts/{podcast}', [PublishedPodcastController::class, 'store'])
    ->name('published-podcasts.store');

Route::delete('/published-podcasts/{podcast}', [PublishedPodcastController::class, 'destroy'])
    ->name('published-podcasts.destroy');
```

The controller then holds only the two standard actions.

```php
class PublishedPodcastController extends Controller
{
    public function store(Podcast $podcast): RedirectResponse
    {
        $podcast->publish();

        return back();
    }

    public function destroy(Podcast $podcast): RedirectResponse
    {
        $podcast->unpublish();

        return back();
    }
}
```

A custom verb is a design signal, not proof that another controller is required. Use query parameters for simple filtering. Keep an explicit action route when a resource would obscure the domain.
</resource_controllers>

<thin_controllers>
A controller coordinates HTTP input, authorization, validation, one application operation, and the response. Extract substantial or reused business logic. Do not add an action or service class only to meet a line limit. This controller delegates the work to an action class.

```php
public function store(StorePostRequest $request, CreatePostAction $create): RedirectResponse
{
    $post = $create->handle($request->validated());

    return redirect()->route('posts.show', $post);
}
```

A form request validates and authorizes before the controller runs, so do not repeat its rules in the controller.
</thin_controllers>

<controller_attributes>
Laravel 13 can declare controller middleware and authorization with the `#[Middleware]` and `#[Authorize]` attributes. They live in `Illuminate\Routing\Attributes\Controllers`. This controller applies `auth` to every action and a policy check to `store`.

```php
#[Middleware('auth')]
class CommentController
{
    #[Middleware('subscribed')]
    #[Authorize('create', [Comment::class, 'post'])]
    public function store(StoreCommentRequest $request, Post $post): RedirectResponse
    {
        $post->comments()->create($request->validated());

        return back();
    }
}
```

Use the attributes in Laravel 13 projects that already use them. Projects that register middleware in route files keep that style.
</controller_attributes>
</routing>

<validation>
<form_requests>
Use a form request when validation or authorization is substantial, reused, or clearer outside the controller. Inline `$request->validate()` stays fine for a small rule set of one endpoint.

```php
public function store(StorePostRequest $request): RedirectResponse
{
    $post = Post::create($request->validated());

    return redirect()->route('posts.show', $post);
}
```

The form request's `authorize()` method can enforce access to the operation. Validation checks the shape and values of the input. Validation alone does not authorize the user.

Laravel 13 form requests also accept class attributes. `#[StopOnFirstFailure]` stops after the first failed attribute. `#[FailOnUnknownFields]` rejects input keys that no rule names. `#[ErrorBag('login')]`, `#[RedirectTo]`, and `#[RedirectToRoute]` replace the matching properties.
</form_requests>

<rule_syntax>
Array syntax combines with rule objects and avoids delimiter problems. Prefer it in new code when it reads better. This rule uses array syntax with a rule object.

```php
'email' => ['required', 'email', Rule::unique('users')],
```

String syntax remains valid for simple rules.

```php
'email' => 'required|email|unique:users',
```

Fluent builders such as `Rule::string()`, `Rule::email()`, `Rule::date()`, and `Rule::anyOf()` express complex rules without string parsing.
</rule_syntax>

<validated_data>
Pass `validated()` or `safe()` data onward instead of `$request->all()`. When the rules also cover control fields or nested data, select only the fields the operation needs. This call passes every input key to the model.

```php
Post::create($request->all());
```

This call passes only the intended validated fields.

```php
$post = Post::create($request->safe()->only(['title', 'body']));
```

Validated data is not automatically safe for mass assignment. Keep the model's `$fillable` or `$guarded` rules aligned with the operation. Never add a sensitive attribute to validation only to make mass assignment convenient.

The `array` rule accepts a list of allowed keys, as in `'user' => ['array:name,username']`. Without that list, `validated()` returns the whole array, including keys no nested rule checked.
</validated_data>

<conditional_rules>
Use `Rule::when()`, `required_if`, or `exclude_unless` when they make the condition explicit. Choose the simplest form that stays easy to test. This rule makes the company name required only for business accounts.

```php
'company_name' => [
    'string',
    'max:255',
    Rule::when(
        $this->input('account_type') === 'business',
        ['required'],
        ['nullable'],
    ),
],
```
</conditional_rules>

<cross_field_validation>
Use the form request's `after()` method for checks that depend on several fields or on application state. Skip expensive queries when a prerequisite field already failed. This callback checks stock only after the product and quantity rules pass.

```php
public function after(): array
{
    return [
        function (Validator $validator) {
            if ($validator->errors()->hasAny(['product_id', 'quantity'])) {
                return;
            }

            $stock = Product::find($this->integer('product_id'))?->stock;

            if ($stock !== null && $this->integer('quantity') > $stock) {
                $validator->errors()->add('quantity', 'Not enough stock.');
            }
        },
    ];
}
```

Validation against mutable state does not prevent a race between validation and persistence. Enforce inventory, uniqueness, and similar invariants with database constraints, atomic updates, or a transaction.
</cross_field_validation>
</validation>

<security>
<mass_assignment>
Define `$fillable` when a model is filled from request-derived arrays, or guard attributes by another consistent model convention. Laravel models guard all attributes by default. `$guarded = []` turns that protection off.

```php
class User extends Model
{
    protected $fillable = [
        'name',
        'email',
        'password',
    ];
}
```

Do not pass untrusted request data to a model with `$guarded = []`. Mass assignment protection controls which attributes `create()`, `fill()`, and `update()` may set. It does not validate values or authorize the operation.
</mass_assignment>

<authorization>
Use policies, gates, or form request authorization for actions that depend on the current user's permissions. Authentication alone does not establish permission, and validation is not authorization. This controller checks the policy before the update.

```php
public function update(UpdatePostRequest $request, Post $post): RedirectResponse
{
    Gate::authorize('update', $post);

    $post->update($request->validated());

    return redirect()->route('posts.show', $post);
}
```

The same check can live in the form request instead.

```php
public function authorize(): bool
{
    return $this->user()?->can('update', $this->route('post')) ?? false;
}
```

Public actions that everyone may use need no redundant authorization check.
</authorization>

<query_bindings>
Use Eloquent, the query builder, or explicit bindings instead of interpolating untrusted values into SQL. Bindings protect values, not identifiers such as column names or sort directions. Map user-selected identifiers to an allow-list. This query interpolates request input into SQL and allows injection.

```php
DB::select("SELECT * FROM users WHERE name = '{$request->name}'");
```

These queries bind the value.

```php
User::where('name', $request->name)->get();
User::whereRaw('LOWER(name) = ?', [$request->string('name')->lower()->toString()])->get();
```

Never pass user input to `Rule::unique(...)->ignore()`. Pass a system-generated key or the model instance.
</query_bindings>

<output_escaping>
Blade's `{{ }}` syntax HTML-escapes output. Use `{!! !!}` only for content sanitized for the exact HTML context where it renders. Escaping rules differ for HTML, URLs, JavaScript, and CSS. This template prints untrusted content raw and allows XSS (cross-site scripting).

```blade
{!! $user->bio !!}
```

This template escapes it.

```blade
{{ $user->bio }}
```
</output_escaping>

<csrf>
Laravel 13 renames the CSRF middleware to `PreventRequestForgery`. It sits in the `web` group and first checks the browser's `Sec-Fetch-Site` header. A same-origin request passes at once. Other requests fall back to token validation. Laravel 12 uses `VerifyCsrfToken` and `ValidateCsrfToken`, which remain deprecated aliases in Laravel 13.

Include `@csrf` in every state-changing Blade form, because older browsers and plain HTTP still need the token.

```blade
<form method="POST" action="/posts">
    @csrf
    <input type="text" name="title">
</form>
```

Exclude routes such as third-party webhooks with `$middleware->preventRequestForgery(except: ['stripe/*'])` in `bootstrap/app.php`. An excluded route needs its own authenticity check, such as a webhook signature. Axios and Angular send the encrypted `XSRF-TOKEN` cookie back in the `X-XSRF-TOKEN` header. Confirm equivalent setup when the frontend uses another HTTP client. Do not disable CSRF protection to fix a token mismatch.
</csrf>

<rate_limiting>
Rate limit login, password recovery, verification messages, and expensive or abuse-prone API routes. Choose the limiter key deliberately. An IP address alone can group many users behind one network. An account identifier alone can enable a targeted denial of service. This limiter keys on the email and the IP together.

```php
RateLimiter::for('login', function (Request $request) {
    return Limit::perMinute(5)->by(Str::transliterate(
        Str::lower($request->string('email')).'|'.$request->ip()
    ));
});

Route::post('/login', LoginController::class)->middleware('throttle:login');
```

Rate limiting reduces abuse. It does not replace authentication, authorization, or upstream denial-of-service protection.
</rate_limiting>

<uploads>
Validate the content type, the size, and the image dimensions where relevant. The `mimes` rule reads the file contents and guesses the MIME type. It does not check the extension the user gave the file. The `extensions` rule checks that extension, so pair it with `mimes` or `mimetypes` and never use it alone.

```php
public function rules(): array
{
    return [
        'avatar' => ['required', 'image', 'mimes:jpg,jpeg,png,webp', 'max:2048'],
    ];
}
```

The `image` rule rejects SVG by default because SVG can carry scripts. Let Laravel's storage methods generate the filename, and store untrusted files outside any publicly executable location. Public files can need more controls, such as image re-encoding, a `Content-Disposition` header, and blocking of active formats.

```php
$path = $request->file('avatar')->store('avatars');
```
</uploads>

<secrets_and_serialization>
Do not commit populated `.env` files or hard-code credentials. Read environment variables only in configuration files, then use `config()` in application code so configuration caching works. The `laravel-app.md` reference covers encrypted environment files and secret stores.

Laravel 13 hardens unserialization. The cache config sets `serializable_classes` to `false`. List every class that the application caches as a PHP object. New applications set the session `serialization` option to `json`. Switching an existing application from `php` to `json` logs out every active session.
</secrets_and_serialization>

<dependency_audit>
Run `composer audit` regularly and in continuous integration. Review each finding for exploitability, then update or mitigate the affected package.

```bash
composer audit
```
</dependency_audit>

<encrypted_attributes>
Use the `encrypted` cast for sensitive values that must stay recoverable. Use `$hidden` to omit them from array and JSON output. Hidden attributes stay readable in PHP, and encryption does not replace access control. Encrypted values cannot be queried meaningfully. Store them in a `TEXT` or larger column, because ciphertext length varies.

```php
class Integration extends Model
{
    protected $hidden = ['api_key', 'api_secret'];

    protected function casts(): array
    {
        return [
            'api_key' => 'encrypted',
            'api_secret' => 'encrypted',
        ];
    }
}
```
</encrypted_attributes>
</security>

<http_client>
<timeouts>
Laravel's HTTP client waits 30 seconds for a response and 10 seconds for a connection by default. Choose both timeouts to fit the remote service and the calling request or job. Retries multiply the total elapsed time. This call uses the defaults.

```php
$response = Http::get('https://api.example.com/users');
```

This call sets explicit timeouts.

```php
$response = Http::connectTimeout(3)
    ->timeout(5)
    ->get('https://api.example.com/users');
```

A macro or a dedicated client class holds shared settings for one service.

```php
Http::macro('github', function () {
    return Http::baseUrl('https://api.github.com')
        ->connectTimeout(3)
        ->timeout(10)
        ->withToken(config('services.github.token'));
});

$response = Http::github()->get('/repos/laravel/framework');
```
</timeouts>

<retries>
Retry transient connection failures, rate-limit responses, and server errors with a delay. Retry idempotent requests such as `GET` freely. Retry a state-changing request only when the remote API supports an idempotency key or similar duplicate protection. This charge request retries without that guarantee and can charge twice.

```php
$response = Http::retry([100, 500, 1000])
    ->post('https://api.example.com/v1/charges', $data);
```

This idempotent request retries only connection failures, server errors, and 429 responses.

```php
$response = Http::connectTimeout(3)
    ->timeout(10)
    ->retry([100, 500, 1000], 0, function (Throwable $exception) {
        return $exception instanceof ConnectionException
            || ($exception instanceof RequestException
                && ($exception->response->serverError() || $exception->response->status() === 429));
    })
    ->get('https://api.example.com/data');
```

For a state-changing API that supports it, send the same idempotency key on every attempt.

```php
$response = Http::withHeaders(['Idempotency-Key' => $paymentAttempt->uuid])
    ->connectTimeout(3)
    ->timeout(10)
    ->retry([100, 500, 1000], 0, function (Throwable $exception) {
        return $exception instanceof ConnectionException
            || ($exception instanceof RequestException
                && ($exception->response->serverError() || $exception->response->status() === 429));
    })
    ->post('https://api.example.com/v1/charges', $data);
```

After the last failed attempt, `retry()` throws a `RequestException`. With `throw: false` it returns the last response instead. A connection failure still throws a `ConnectionException`.
</retries>

<error_responses>
The client returns `4xx` and `5xx` responses without throwing. Check the expected statuses or call `throw()` before reading a success payload. This call reads the body even when the request failed.

```php
$user = Http::get('https://api.example.com/users/1')->json();
```

This call throws on an error status first.

```php
$user = Http::connectTimeout(3)
    ->timeout(5)
    ->get('https://api.example.com/users/1')
    ->throw()
    ->json();
```

When the feature must degrade gracefully, handle each expected alternative explicitly.

```php
$response = Http::connectTimeout(3)
    ->timeout(5)
    ->get('https://api.example.com/users/1');

if ($response->successful()) {
    return $response->json();
}

if ($response->notFound()) {
    return null;
}

$response->throw();
```
</error_responses>

<pooling>
Use `Http::pool()` when several independent requests can run concurrently. The `concurrency` argument caps the requests in flight. Pooling changes execution time, not error handling. A connection failure leaves a `ConnectionException` in its entry instead of a `Response`. Check each entry before you use it.

```php
use Illuminate\Http\Client\Pool;

$responses = Http::pool(fn (Pool $pool) => [
    $pool->as('users')->connectTimeout(3)->timeout(5)
        ->get('https://api.example.com/users'),
    $pool->as('posts')->connectTimeout(3)->timeout(5)
        ->get('https://api.example.com/posts'),
], concurrency: 5);

foreach ($responses as $response) {
    if ($response instanceof Throwable) {
        throw $response;
    }
}

$users = $responses['users']->throw()->json();
$posts = $responses['posts']->throw()->json();
```

`Http::batch()` works like a pool and adds `before`, `progress`, `then`, `catch`, and `finally` callbacks.
</pooling>

<faking>
Use `Http::fake()` for external integrations. Call `Http::preventStrayRequests()` so an unexpected real request fails the test. `Http::allowStrayRequests([...])` lets listed URL patterns through. Also test the timeouts, connection failures, and error responses that the application handles.

```php
it('syncs a user from the API', function () {
    Http::preventStrayRequests();

    Http::fake([
        'api.example.com/users/1' => Http::response([
            'name' => 'John Doe',
            'email' => 'john@example.com',
        ]),
    ]);

    (new UserSyncService)->sync(1);

    Http::assertSent(fn (Request $request) =>
        $request->url() === 'https://api.example.com/users/1'
    );
});
```

This fake simulates a connection failure for the failure path.

```php
Http::fake([
    'api.example.com/*' => Http::failedConnection(),
]);
```
</faking>
</http_client>

<error_handling>
<report_and_render>
Laravel supports reporting and rendering on the exception class and central callbacks in `bootstrap/app.php`. Methods on the exception keep the behavior beside its definition.

```php
class InvalidOrderException extends Exception
{
    public function report(): void
    {
        Log::channel('orders')->error($this->getMessage());
    }

    public function render(Request $request): Response
    {
        return response()->view('errors.invalid-order', status: 422);
    }
}
```

Callbacks in `withExceptions` keep the whole exception policy in one place.

```php
->withExceptions(function (Exceptions $exceptions): void {
    $exceptions->report(function (InvalidOrderException $e) {
        Log::channel('orders')->error($e->getMessage());
    });
    $exceptions->render(function (InvalidOrderException $e, Request $request) {
        return response()->view('errors.invalid-order', status: 422);
    });
})
```

The two styles differ in default behavior. A `report()` method on the exception replaces default logging unless it returns `false`. A report callback keeps default logging unless it returns `false` or is chained with `->stop()`. A render callback that returns nothing, or a `render()` method that returns `false`, falls back to default rendering.
</report_and_render>

<ignored_exceptions>
Implement `Illuminate\Contracts\Debug\ShouldntReport` to keep an exception type out of reports and make that policy visible on the class. `$exceptions->dontReport([...])` and `dontReportWhen()` do the same centrally. Neither stops application code from logging the exception explicitly.

```php
class PodcastProcessingException extends Exception implements ShouldntReport {}
```
</ignored_exceptions>

<throttled_reports>
A failing integration can flood logs or error tracking. Return a `Lottery` from `$exceptions->throttle()` to sample reports, or a `Limit` to rate-limit them. A `Limit` keys on the exception class by default. Call `->by()` when tenants or integrations need separate limits.

```php
$exceptions->throttle(function (Throwable $e) {
    return match (true) {
        $e instanceof BroadcastException => Limit::perMinute(300),
        $e instanceof ApiMonitoringException => Lottery::odds(1, 1000),
        default => Limit::none(),
    };
});
```
</throttled_reports>

<duplicate_reports>
Call `$exceptions->dontReportDuplicates()` when one exception object can pass through several `report()` calls. It deduplicates by object identity, not by class or message.
</duplicate_reports>

<json_rendering>
Laravel picks HTML or JSON from the request's `Accept` header. If the API contract requires JSON regardless of that header, define the policy for the relevant routes.

```php
$exceptions->shouldRenderJsonWhen(function (Request $request, Throwable $e) {
    return $request->is('api/*') || $request->expectsJson();
});
```
</json_rendering>

<exception_context>
A `context()` method on an exception attaches structured data. Laravel merges it into the log entry when the handler reports the exception. `$exceptions->context(fn () => [...])` adds data to every report.

```php
class InvalidOrderException extends Exception
{
    public function context(): array
    {
        return ['order_id' => $this->orderId];
    }
}
```
</exception_context>
</error_handling>
