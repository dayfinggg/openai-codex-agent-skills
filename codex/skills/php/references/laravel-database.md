<overview>
This file covers Eloquent models, query performance, advanced queries, and migrations for Laravel 12 and 13. Read it before you write or review queries, models, relationships, or schema changes.
</overview>
<contents>
This file has these sections, in order.
- eager loading
- prevent lazy loading
- select columns
- large data sets
- indexes
- counts and aggregates
- subqueries
- inverse relations
- relationships
- scopes
- casts
- model attributes
- model aware queries
- queries outside views
- migrations
</contents>


<eager_loading>
Eager load a relationship with `with()` when code reads it on many models. Eager loading avoids the N+1 pattern of one query plus one query per model. Lazy loading is fine when the code may not need the relationship or loads only one model.

This loop runs one author query for each post.

```php
$posts = Post::all();
foreach ($posts as $post) {
    echo $post->author->name;
}
```

This version loads all authors in one extra query.

```php
$posts = Post::with('author')->get();
foreach ($posts as $post) {
    echo $post->author->name;
}
```

A constrained eager load can skip large columns and limit rows per parent. Keep the related primary key and every column Eloquent needs to match the relationship. Laravel 11 and later apply `limit()` per parent inside an eager load without extra packages. In this example, `id` and `user_id` let Eloquent match posts to users.

```php
$users = User::with(['posts' => function ($query) {
    $query->select('id', 'user_id', 'title')
          ->where('published', true)
          ->latest()
          ->limit(10);
}])->get();
```
</eager_loading>

<prevent_lazy_loading>
Enable lazy-loading prevention in `AppServiceProvider::boot()` to catch N+1 queries during development. With it enabled, access to an unloaded relationship throws a `LazyLoadingViolationException`. Use `handleLazyLoadingViolationUsing()` to report violations in another way. `Model::preventSilentlyDiscardingAttributes()` similarly throws when code fills an attribute that is not fillable.

```php
public function boot(): void
{
    Model::preventLazyLoading(! $this->app->isProduction());
}
```
</prevent_lazy_loading>

<select_columns>
Select only the needed columns when skipping large text, binary, or JSON columns gives a real benefit. Keep every key that relationship matching needs. A `belongsTo` relationship needs the foreign key on the parent query and the owner key on the related query. A `hasMany` relationship needs the parent's local key and the related model's foreign key.

This query selects four post columns and three author columns.

```php
$posts = Post::select('id', 'title', 'user_id', 'created_at')
    ->with(['author:id,name,avatar'])
    ->get();
```
</select_columns>

<large_data_sets>
Use chunking or lazy iteration when the full result set would exceed the practical memory budget. This loop loads every user into memory before it starts.

```php
$users = User::all();
foreach ($users as $user) {
    $user->notify(new WeeklyDigest);
}
```

This version processes 200 users at a time.

```php
User::where('subscribed', true)->chunk(200, function ($users) {
    foreach ($users as $user) {
        $user->notify(new WeeklyDigest);
    }
});
```

Use `chunkById()` or `lazyById()` when updates during the loop can change which rows match the query. Plain `chunk()` and `lazy()` use offset pagination, so rows can shift and the loop can skip or repeat records. The `ById` methods add their own where clause, so group your own `orWhere` conditions inside a closure. Never change the pagination key itself during the loop.

```php
User::where('active', false)->chunkById(200, function ($users) {
    $users->each->delete();
});
```

The three streaming methods differ in queries and eager loading.

| Method | Queries | Eager loading | Fits |
| --- | --- | --- | --- |
| `cursor()` | One query, one hydrated model at a time | Not supported | Read-only loops over attributes |
| `lazy()` | Chunked queries, flat `LazyCollection` | Supported per chunk | Loops that need relationships |
| `lazyById()` | Chunked by a monotonic key | Supported per chunk | Loops that update matched rows |

Some database drivers still buffer the raw results of `cursor()`, so very large results can use much memory. `lazy()` also avoids holding one database cursor open for the whole loop.
</large_data_sets>

<indexes>
Design indexes around frequent, performance-sensitive query patterns. A column in `WHERE`, `ORDER BY`, `JOIN`, or `GROUP BY` does not need an index by that fact alone. Selectivity, write cost, existing indexes, and the query plan all matter.

This schema adds a composite index for `WHERE status = ? ORDER BY created_at`.

```php
Schema::create('orders', function (Blueprint $table) {
    $table->id();
    $table->foreignId('user_id')->constrained();
    $table->string('status');
    $table->timestamps();
    $table->index(['status', 'created_at']);
});
```

Confirm the column order and the benefit with production-like data and the database's query-plan tools. Engines can combine indexes or choose an explicit sort, so a matching `ORDER BY` list alone does not guarantee index use. Before you add an index on a foreign key, check whether the database already created one. Avoid an index whose leading columns duplicate an existing index without serving a distinct query.

This index may support a sort by last name and then first name.

```php
$table->index(['last_name', 'first_name']);
```

```php
User::query()->orderBy('last_name')->orderBy('first_name')->paginate();
```
</indexes>

<counts_and_aggregates>
Use `withCount()` when you need only relationship counts. Loading and hydrating every related model wastes memory. This query adds a `comments_count` and an `approved_comments_count` attribute to each post.

```php
$posts = Post::withCount([
    'comments',
    'comments as approved_comments_count' => function ($query) {
        $query->where('approved', true);
    },
])->get();
```

Conditional aggregates combine several counts over the same rows into one query. Use `toBase()` when you need only scalar values and model hydration adds nothing. Confirm the expression syntax for the project's database engine.

```php
$statuses = Feature::toBase()
    ->selectRaw("count(case when status = 'Requested' then 1 end) as requested")
    ->selectRaw("count(case when status = 'Planned' then 1 end) as planned")
    ->selectRaw("count(case when status = 'Completed' then 1 end) as completed")
    ->first();
```
</counts_and_aggregates>

<subqueries>
A correlated subquery with `addSelect()` fetches one value from a has-many relationship without loading the whole relationship. The value arrives in the main query.

```php
#[Scope]
protected function withLastLoginAt(Builder $query): void
{
    $query->addSelect([
        'last_login_at' => Login::select('created_at')
            ->whereColumn('user_id', 'users.id')
            ->latest()
            ->take(1),
    ])->withCasts(['last_login_at' => 'datetime']);
}
```

The same pattern can select a foreign key and expose the model through a `belongsTo` relationship. Eager loading that relationship still runs one separate query, but it avoids loading the full has-many collection.

```php
public function lastLogin(): BelongsTo
{
    return $this->belongsTo(Login::class, 'last_login_id');
}

#[Scope]
protected function withLastLogin(Builder $query): void
{
    $query->addSelect([
        'last_login_id' => Login::select('id')
            ->whereColumn('user_id', 'users.id')
            ->latest()
            ->take(1),
    ])->with('lastLogin');
}
```

A join on a has-many table duplicates parent rows. It needs a first step that reduces the related table to one row per parent. A correlated subquery in `orderBy()` is often simpler for sorting by one related value. Its speed depends on the query plan and supporting indexes.

```php
#[Scope]
protected function orderByLastLogin(Builder $query): void
{
    $query->orderByDesc(Login::select('created_at')
        ->whereColumn('user_id', 'users.id')
        ->latest()
        ->take(1)
    );
}
```

`whereHas()` usually produces an `EXISTS` subquery, and `whereIn()` with a subquery produces `IN`. Either form can be faster, depending on engine, indexes, and cardinality, so measure both with representative data. Neither form loads the subquery results into PHP memory.

```php
$query->whereHas('company', fn ($q) => $q->where('name', 'like', $term));

$query->whereIn('company_id', Company::where('name', 'like', $term)->select('id'));
```

Two targeted queries can beat one complex correlated subquery or join when the first query is highly selective. They also add a round trip, can move a large ID list, and lose the single-query consistency snapshot. Decide from query plans and production-like measurements.
</subqueries>

<inverse_relations>
Code that reads `$child->parent` after loading the children from that parent triggers one lazy query per child. Set the inverse relationship to the loaded parent instance to avoid those queries.

```php
$feature->load('comments.user');
$feature->comments->each->setRelation('feature', $feature);
```

Laravel 11.22 and later can do this automatically with `chaperone()` on the `hasMany` definition, as in `return $this->hasMany(Comment::class)->chaperone();`. Call `chaperone()` on the eager load instead when only some queries need it.
</inverse_relations>

<relationships>
Define the relationship that matches the database association, and declare its concrete return type.

```php
public function comments(): HasMany
{
    return $this->hasMany(Comment::class);
}

public function author(): BelongsTo
{
    return $this->belongsTo(User::class, 'user_id');
}
```

`whereBelongsTo()` expresses a relationship constraint without naming the foreign key. These two queries replace `Post::where('user_id', $user->id)`.

```php
Post::whereBelongsTo($user)->get();
Post::whereBelongsTo($user, 'author')->get();
```
</relationships>

<scopes>
Extract a reusable query constraint into a local scope instead of repeating it. Laravel 12 and later mark a local scope with the `#[Scope]` attribute (`Illuminate\Database\Eloquent\Attributes\Scope`) on a protected method. Older projects use the `scopeActive()` naming convention, so follow what the project uses.

```php
#[Scope]
protected function active(Builder $query): void
{
    $query->where('verified', true)->whereNotNull('activated_at');
}
```

```php
$active = User::active()->get();
$articles = Article::whereHas('user', fn ($q) => $q->active())->get();
```

A global scope silently changes every query on the model, which makes queries hard to debug. A `PublishedScope` would hide drafts from admin panels, reports, and jobs unless each one removes the scope. Prefer an explicit local scope such as `Post::published()`. Reserve global scopes for universal rules such as soft deletes or multi-tenancy. Register a global scope with `#[ScopedBy([TenantScope::class])]` on the model.
</scopes>

<casts>
Define casts in the `casts()` method for automatic type conversion. Follow the project if its models use the `$casts` property. Cast every date or timestamp column that code treats as a date, so templates call `$order->ordered_at->toDateString()` instead of `Carbon::parse()`. Eloquent already casts `created_at` and `updated_at`.

```php
protected function casts(): array
{
    return [
        'is_active' => 'boolean',
        'metadata' => 'array',
        'total' => 'decimal:2',
        'ordered_at' => 'datetime',
    ];
}
```
</casts>

<model_attributes>
Laravel 13 can configure a model with PHP attributes from `Illuminate\Database\Eloquent\Attributes`. Examples are `#[Table('my_flights')]`, `#[Fillable(['name'])]`, `#[Hidden([...])]`, `#[Connection('mysql')]`, `#[UseFactory(...)]`, `#[ObservedBy([...])]`, and `#[CollectedBy(...)]`. `#[Table]` also takes `key`, `keyType`, `incrementing`, `timestamps`, and `dateFormat` arguments. `#[Refreshes(['name'])]` reloads generated columns after a write. Use attributes or properties as the project's other models do. See the [Eloquent docs](https://laravel.com/docs/13.x/eloquent) for the full list.
</model_attributes>

<model_aware_queries>
Prefer Eloquent models and relationships for model-backed application queries. They keep casts, scopes, and the model's table configuration. `DB::table()`, joins, and raw SQL need table names, so use them when you want their lower-level behavior. When a query builder call should follow a model's table name, use `(new User)->getTable()`. Cover explicit table names in complex joins or raw SQL with tests when the schema can change.

Migrations use explicit table names, not application models. A migration is a historical snapshot, while models and their scopes change after deployment.
</model_aware_queries>

<queries_outside_views>
Prepare data before a Blade template renders, in a controller, a query service, or a view composer. A query in a template stays hidden from review and tests, and it often causes N+1 queries. This template runs a query and a lazy profile load on each row.

```blade
@foreach (User::all() as $user)
    {{ $user->profile->name }}
@endforeach
```

This controller loads users and profiles before rendering, and the template loops over `$users`.

```php
$users = User::with('profile')->get();

return view('users.index', compact('users'));
```
</queries_outside_views>

<migrations>
<generate_with_artisan>
Generate migrations with Artisan so the filename has the right timestamp and the class has the right structure.

```bash
php artisan make:migration create_posts_table
php artisan make:migration add_slug_to_posts_table
```
</generate_with_artisan>

<foreign_keys>
Use `constrained()` when its naming conventions and default actions match the relationship. Name the table or the delete behavior when they differ. Check the driver's foreign-key index behavior before you add a second single-column index.

```php
$table->foreignId('user_id')->constrained()->cascadeOnDelete();
$table->foreignId('author_id')->constrained('users');
```
</foreign_keys>

<modifying_columns>
A column change with `->change()` must repeat every attribute the column already has. Attributes you leave out, such as `nullable`, `default`, or `unsigned`, are dropped.

```php
$table->string('name', 100)->nullable()->default('guest')->change();
```
</modifying_columns>

<immutable_after_deploy>
Create a new migration for every change after a migration ran in a shared or production environment. Editing the old file makes fresh installs differ from upgraded ones. A local migration that nobody else has run can be edited and rerun.
</immutable_after_deploy>

<populated_tables>
Adding a required or unique column to a populated table usually needs several deployment-safe steps.
1. Add the column as nullable.
2. Deploy code that handles both states.
3. Backfill existing rows in bounded chunks.
4. Add the required constraint or unique index after the data is valid.

A one-step `$table->string('slug')->unique();` is not safe on a populated table. Run a large backfill as an observable, restartable command or job, not inside a schema migration. A small deterministic data change can live in a migration when you understand its locking, transaction, and deployment behavior. Separate long backfills from schema changes when the split reduces locks.
</populated_tables>

<defaults>
The database applies a column default on insert, not when you instantiate a model. Mirror the default in the model's `$attributes` only when code must see it before the model is saved. Keep both values in sync.

```php
$table->string('status')->default('pending');
```

```php
protected $attributes = [
    'status' => 'pending',
];
```
</defaults>

<rollbacks>
Implement `down()` when the change can be reversed safely. A rollback that drops populated columns or cannot restore transformed data destroys data, even when it runs without errors. State that limit in the migration and prefer a forward-fix migration in production.
</rollbacks>
</migrations>
