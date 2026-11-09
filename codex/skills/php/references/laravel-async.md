<overview>
This file covers work that runs outside the request in a Laravel application. It covers queued jobs, scheduled tasks, events, notifications, mail, and caching. It targets Laravel 13 (PHP 8.3 or newer) and notes where Laravel 12 differs.
</overview>
<contents>
This file has these sections, in order.
- queues
- scheduling
- events
- notifications
- mail
- caching
</contents>


<queues>
<job_settings>
Laravel 13 documents job settings as class attributes from `Illuminate\Queue\Attributes`. They include `#[Tries]`, `#[Backoff]`, `#[Timeout]`, `#[MaxExceptions]`, `#[FailOnTimeout]`, `#[UniqueFor]`, and `#[DeleteWhenMissingModels]`. The framework still reads the older `$tries`, `$backoff`, `$timeout`, and `$uniqueFor` properties. Laravel 12 supports only the properties, so match the installed version and the project. A `tries()` or `backoff()` method overrides both forms.

Laravel 13 also adds `Queue::route(ProcessPodcast::class, connection: 'redis', queue: 'podcasts')`. It sets the default connection and queue for a job class in one central place.
</job_settings>

<reservation_time>
For drivers that use the `retry_after` setting, set it longer than the longest job timeout by a safety margin. When a reservation expires, another worker can take the same job while the first still runs. Keep the worker's `--timeout` several seconds shorter than `retry_after`. Job timeouts need the PCNTL extension. This job and connection config keep the margin.

```php
#[Timeout(120)]
class GenerateReport implements ShouldQueue
{
    use Queueable;
}
```

```php
'redis' => [
    'driver' => 'redis',
    'retry_after' => 150,
],
```

Amazon SQS uses its own visibility timeout instead of `retry_after`, so configure that timeout on the queue. A worker can also stop after side effects but before it acknowledges the job. Make important jobs idempotent even with correct timeouts.
</reservation_time>

<backoff>
Use growing delays when a dependency needs time to recover. Do not retry permanent validation or business-rule failures. This job retries three times after 1, 5, and 10 seconds.

```php
#[Tries(4)]
#[Backoff([1, 5, 10])]
class SyncWithStripe implements ShouldQueue
{
    use Queueable;
}
```

Rate-limiting and exception-throttling middleware release jobs back to the queue. Each release still counts as an attempt. Set the tries or `retryUntil()` to cover the intended retry window. `FailOnException` middleware fails the job at once for exceptions that a retry cannot fix.
</backoff>

<unique_jobs>
Implement `ShouldBeUnique` when only one queued instance of a logical job may exist. Uniqueness uses a cache lock. It does not replace idempotent processing or a database constraint.

```php
#[UniqueFor(3600)]
class GenerateInvoice implements ShouldQueue, ShouldBeUnique
{
    use Queueable;

    public function uniqueId(): string
    {
        return (string) $this->order->id;
    }
}
```

Every dispatching process must share a cache store that supports locks. The `memcached`, `redis`, `dynamodb`, `database`, `file`, and `array` drivers support them. Unique-job constraints do not apply to jobs inside batches.

A unique job unlocks after it completes or fails all attempts. Implement `ShouldBeUniqueUntilProcessing` only when the lock should release right before processing starts. Another instance can then be dispatched while the first runs.

```php
class UpdateSearchIndex implements ShouldQueue, ShouldBeUniqueUntilProcessing
{
    use Queueable;
}
```
</unique_jobs>

<terminal_failure>
Implement `failed()` when the application must update state, alert an operator, or record domain context after the last attempt. Logging every failure in each job can duplicate the queue's own failure reporting. Laravel calls `failed()` on a new job instance, so changes made in `handle()` are lost.

```php
public function failed(?Throwable $exception): void
{
    $this->podcast->update(['status' => 'failed']);

    Log::error('Podcast processing failed', [
        'podcast_id' => $this->podcast->id,
        'exception' => $exception,
    ]);
}
```
</terminal_failure>

<rate_limited_jobs>
Use queue middleware such as `RateLimited` when jobs share a third-party API quota. Define the named limiter, and choose the release delay and attempt limit together.

```php
public function middleware(): array
{
    return [new RateLimited('external-api')];
}
```
</rate_limited_jobs>

<batches>
Use `Bus::batch()` to track a group of jobs and run callbacks when the batch finishes or fails. A batch is not a database transaction. Laravel does not roll back completed jobs when another job fails. By default, one failed job marks the batch as cancelled. Call `allowFailures()` only when partial failure is acceptable. Batched jobs should check `$this->batch()->cancelled()` or use the `SkipIfBatchCancelled` middleware.

```php
Bus::batch([
    new ImportCsvChunk($chunk1),
    new ImportCsvChunk($chunk2),
])
    ->then(fn (Batch $batch) => Notification::send($user, new ImportComplete))
    ->catch(fn (Batch $batch, Throwable $exception) => Log::error('Import batch failed', [
        'exception' => $exception,
    ]))
    ->dispatch();
```
</batches>

<time_based_retries>
`retryUntil()` is the time-based alternative to an attempt count. Laravel retries the job any number of times until the deadline, subject to limits such as maximum exceptions. When both are defined, `retryUntil()` wins over the tries setting.

```php
public function retryUntil(): DateTimeInterface
{
    return now()->addHours(4);
}
```
</time_based_retries>

<after_commit_dispatch>
A job dispatched inside a database transaction can run before the transaction commits. Set the connection's `after_commit` option to `true`, or call `->afterCommit()` on the dispatch. Laravel discards such jobs when the transaction rolls back. The `after_commit` option also delays queued listeners, mailables, notifications, and broadcast events.
</after_commit_dispatch>

<horizon>
Laravel Horizon adds monitoring, balancing, metrics, and supervisor configuration for Redis queues. It manages Redis queues only. A project with a `database` queue runs a normal `php artisan queue:work database` worker beside Horizon.
</horizon>
</queues>

<scheduling>
<schedule_location>
Schedules live in `routes/console.php` with the `Schedule` facade. The alternative is `->withSchedule(function (Schedule $schedule) {...})` in `bootstrap/app.php`. `php artisan schedule:list` shows every task and its next run.
</schedule_location>

<overlap>
Use `withoutOverlapping()` when a second run must not start while the previous run holds the lock. It suits tasks with variable duration that are unsafe to run concurrently.

```php
Schedule::command('reports:generate')
    ->everyFifteenMinutes()
    ->withoutOverlapping(30);
```

The optional value is the lock expiry in minutes, not the task timeout. The default is 24 hours. An expiry that is too short permits overlap while the first run continues. Clear stale locks with `php artisan schedule:clear-cache`. The task itself should still tolerate retries and partial runs.
</overlap>

<one_server>
Use `onOneServer()` when only one scheduler node should run a task. All nodes must share one default cache store with atomic locks, such as `database`, `memcached`, `dynamodb`, or `redis`. `Schedule::useCache('redis')` picks a different store for these locks.

```php
Schedule::command('billing:charge')->daily()->onOneServer();
```

Name a scheduled closure or job with `->name()` before `onOneServer()`. A distinct name gives each task its own lock, which matters when one job runs with different parameters. `Schedule::alwaysOnOneServer()` applies the rule to every task, but unnamed closures still run on every server.
</one_server>

<background_tasks>
Tasks due at the same time run one after another by default. Use `runInBackground()` when an independent long-running command should not delay later tasks. It works only with `command()` and `exec()`, not with closures. Give background processes logging and failure monitoring.

```php
Schedule::command('analytics:process')->hourly()->runInBackground();
```

Sub-minute tasks such as `everyTenSeconds()` keep `schedule:run` alive for the whole minute. They should dispatch queued jobs or background commands. Add `php artisan schedule:interrupt` to the deploy script so a running scheduler picks up new code.
</background_tasks>

<environments>
Use `environments()` when a task should run only in named environments. It is an operational safeguard, not an authorization control.

```php
Schedule::command('billing:charge')
    ->monthly()
    ->environments(['production']);
```
</environments>

<groups>
Schedule groups share frequency and constraints across several tasks.

```php
Schedule::daily()
    ->onOneServer()
    ->timezone('America/New_York')
    ->group(function () {
        Schedule::command('emails:send --force');
        Schedule::command('emails:prune');
    });
```
</groups>

<bounded_work>
The scheduler does not stop a task at a deadline. Bound the work inside the command or job. Process finite chunks, check a deadline, or dispatch queued jobs with suitable timeouts. Use operating-system or process controls when a hard stop is required.
</bounded_work>
</scheduling>

<events>
<discovery>
Laravel discovers listeners in the application's `Listeners` directory. It registers each `handle` or `__invoke` method for the event type-hinted in its signature. `->withEvents(discover: [...])` in `bootstrap/app.php` adds other directories. Register listeners by hand only when discovery is off, the listener lives elsewhere, or explicit registration reads better.

Cache the listener manifest in production with `php artisan optimize` or `php artisan event:cache` during deployment. Rebuild it whenever listeners change.
</discovery>

<after_commit_events>
An event that implements `ShouldDispatchAfterCommit` waits until all open database transactions commit. Laravel discards the event if the transaction rolls back. Outside a transaction it dispatches at once. The delay affects synchronous and queued listeners alike. A queued listener can instead implement `ShouldQueueAfterCommit`.

```php
class OrderShipped implements ShouldDispatchAfterCommit {}
```
</after_commit_events>

<debounced_listeners>
Laravel 13 can debounce a queued listener with `#[DebounceFor(30)]` and a `debounceId()` method. Repeated events with the same ID within the window run the listener once, for the latest event. `maxWait` caps how long the debounce can defer the listener. A debounced listener must not also implement `ShouldBeUnique`.
</debounced_listeners>
</events>

<notifications>
<queued_notifications>
Queue notifications that call external services such as mail, SMS, or Slack. The response then does not wait for them. Keep a notification synchronous when the operation needs immediate success or failure feedback. Laravel 13 queue attributes such as `#[Tries]` and `#[Timeout]` on the notification class pass to the queued job.

```php
class InvoicePaid extends Notification implements ShouldQueue
{
    use Queueable;
}
```

A queued notification sent inside a transaction can run before the commit. Call `afterCommit()` on it, or enable the connection's `after_commit` option, when delivery depends on committed data. Neither setting changes a synchronous notification.

```php
$user->notify((new InvoicePaid($invoice))->afterCommit());
```
</queued_notifications>

<channel_queues>
Channels can need different latency and priority. Implement `viaQueues()` to map each channel to a queue, and `viaConnections()` to map each channel to a connection.

```php
public function viaQueues(): array
{
    return [
        'mail' => 'mail-queue',
        'slack' => 'slack-queue',
    ];
}
```
</channel_queues>

<on_demand_notifications>
Send to a recipient that is not a model with an on-demand notification, instead of a dummy model.

```php
Notification::route('mail', 'admin@example.com')->notify(new SystemAlert());
```
</on_demand_notifications>

<recipient_locale>
Implement `HasLocalePreference::preferredLocale()` on a notifiable model so notifications and mailables use the recipient's locale. Laravel keeps that locale for queued delivery. An explicit `locale()` call on one notification sets the locale for that send.
</recipient_locale>
</notifications>

<mail>
<queued_mail>
Implement `ShouldQueue` on a mailable when delivery should normally happen in the background. Laravel then queues the mailable even when the caller uses `Mail::send()`. Keep mail synchronous when the caller must know at once that the transport accepted it. The same holds when no queue worker runs.

```php
class OrderShipped extends Mailable implements ShouldQueue
{
    use Queueable, SerializesModels;
}
```

A worker can process a queued mailable from inside a transaction before the commit. Call `afterCommit()` on the mailable, or enable the connection's `after_commit` option, when the mail depends on committed records. Laravel drops such a mailable if the transaction rolls back. The setting affects only queued mail.

```php
Mail::to($user)->send(
    (new OrderShipped($order))->afterCommit()
);
```
</queued_mail>

<mail_assertions>
Under `Mail::fake()`, a mailable that implements `ShouldQueue` counts as queued, not sent. Use `Mail::assertQueued()` for queued mailables and `Mail::assertSent()` for synchronous ones. This assertion fails for a queued mailable.

```php
Mail::assertSent(OrderShipped::class);
```

This assertion matches it.

```php
Mail::assertQueued(OrderShipped::class);
```

Test rendered content separately by instantiating the mailable and calling `assertSeeInHtml()` or `assertSeeInText()`. Test delivery with `Mail::fake()`. A failure then points at the content or at the delivery.
</mail_assertions>

<markdown_mailables>
Markdown mailables render HTML and plain-text versions from Laravel's mail components and support publishable themes. They suit conventional transactional messages. A custom HTML and text pair can suit a specialized design better.

```bash
php artisan make:mail OrderShipped --markdown=mail.orders.shipped
```
</markdown_mailables>
</mail>

<caching>
<remember>
`Cache::remember()` implements a cache-aside read without a separate truthiness check. It does not stop concurrent requests from computing the same missing value. Use an atomic lock when duplicate computation must not happen. This manual version treats valid falsy values such as `false` or `0` as misses.

```php
$val = Cache::get('stats');
if (! $val) {
    $val = $this->computeStats();
    Cache::put('stats', $val, 60);
}
```

This version handles every value correctly.

```php
$val = Cache::remember('stats', 60, fn () => $this->computeStats());
```

`Cache::rememberWithWarmth()` returns the value and a flag that says whether it came from the cache.
</remember>

<stale_while_revalidate>
`Cache::flexible()` serves stale data during a stale period and refreshes the value in a deferred function. During an HTTP request, that refresh runs after the response is sent. It is not a durable background job. After the stale period, the request recomputes the value synchronously. This call expires the value after five minutes.

```php
Cache::remember('users', 300, fn () => User::all());
```

This call keeps the value fresh for five minutes and serves it stale until ten minutes.

```php
Cache::flexible('users', [300, 600], fn () => User::all());
```
</stale_while_revalidate>

<memoized_store>
`Cache::memo()` decorates a cache store and keeps resolved values in memory for one request or job. Repeated reads of the same key then skip the store. A write such as `put`, `increment`, or `remember` forgets the memoized value and goes to the store. `Cache::memo('redis')` decorates a named store.

```php
$settings = Cache::memo()->get('settings');
```
</memoized_store>

<once_helper>
`once()` memoizes a callback's result for the current request or job. Calls from an object instance are scoped to that instance. Unlike `Cache::memo()`, it never reads an external store.

```php
public function roles(): Collection
{
    return once(fn () => $this->loadRoles());
}
```

Use `once()` for repeated computation within one execution. Use `Cache::memo()` to cut repeated reads of a store that also persists values across executions.
</once_helper>

<tags>
Tags group related entries so one call invalidates them all. The `file`, `dynamodb`, `database`, and `storage` drivers do not support tags. Confirm that the store supports tags before you rely on them.

```php
Cache::tags(['user-1'])->flush();
```
</tags>

<atomic_writes>
`add()` writes a value only when the key does not exist yet, and it does so atomically. This check-then-write sequence has a race.

```php
if (! Cache::has('lock')) {
    Cache::put('lock', true, 10);
}
```

This call is atomic.

```php
Cache::add('lock', true, 10);
```

Use `Cache::lock()` when the code needs lock ownership and safe release. `Cache::withoutOverlapping('key', fn () => ...)` runs a closure under a lock. `Cache::funnel('key')->limit(3)` caps concurrent runs at a fixed number.
</atomic_writes>

<extending_ttl>
Laravel 13 adds `Cache::touch('key', 3600)` to extend an item's lifetime without reading and rewriting it. It returns `false` when the key does not exist.
</extending_ttl>

<failover_store>
The `failover` driver tries each listed store in order when a store operation throws. It does not consult later stores on an ordinary miss, and it does not copy data between stores. Set `CACHE_STORE=failover` to use it. Laravel dispatches `CacheFailedOver` when it switches, so report that event.

```php
'failover' => [
    'driver' => 'failover',
    'stores' => ['redis', 'database'],
],
```
</failover_store>

<object_serialization>
Laravel 13 sets the cache `serializable_classes` option to `false` in new applications. A cached object whose class is not on that list comes back as `__PHP_Incomplete_Class`. List the classes the application caches, or cache arrays and other plain values.
</object_serialization>
</caching>
