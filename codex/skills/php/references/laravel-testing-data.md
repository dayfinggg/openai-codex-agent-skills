<overview>
This file covers test data, fakes, determinism, suite speed, and existing test features. It targets Laravel 12 or 13 with Pest 4 or 5, or PHPUnit 12 or 13. Read [laravel-testing.md](laravel-testing.md) first for what to test, names, and assertions.
</overview>
<contents>
This file has these sections, in order.
- test data
- isolation
- suite speed
- existing features
</contents>


<test_data>
<own_data>
Each test creates the mutable records it uses, so the setup stays visible and each test picks its factory state. In PHPUnit, a private helper that the test calls is fine. Use `beforeEach()` or `setUp()` only for configuration that applies to every test in the file. Records created in `setUp()` stay in memory until the suite ends.
</own_data>

<factories>
These rules decide how a factory builds a record.
- Use `create()` when the test needs the record in the database.
- Use `make()` only when the test needs no database, such as rendering a notification or testing a value object.
- Use a named factory state instead of a raw attribute. `User::factory()->unverified()->create()` states the meaning, while `create(['email_verified_at' => null])` states only a value.
- Use `for()` or the project's relationship helper to declare the owner of a record.
- Use `recycle()` when several records must share one parent record.
- Use `sequence()` when several records need different attributes.
- Create only the records that arrange the behavior or support an assertion.

These factory calls use a named state, a shared parent, and a sequence.

```php
$organization = Organization::factory()->onPlan(BillingPlan::Pro)->create();

$environment = Environment::factory()->recycle($organization)->create();

$organizations = Organization::factory()
    ->count(3)
    ->sequence(
        ['created_at' => now()->setSeconds(30)],
        ['created_at' => now()->setSeconds(1)],
    )
    ->create();
```
</factories>

<parameterized_tests>
Use a Pest dataset or a PHPUnit data provider when setup, body, and assertions stay the same across inputs. Typical cases are enum cases, roles, plans, and boundary values. Inputs that fail in the same way, and input and output pairs, also fit. When cases need a different setup, behavior, or assertions, write separate tests. A test body with a branch is two tests in one function.

Give each case a name or key that states the difference, so a failure names the case without counting positions. This Pest test runs over every role except admin.

```php
it('forbids roles other than admin', function (Role $role) {
    $this->actingAs(User::factory()->hasOrganization($role)->create())
        ->post('/settings')
        ->assertForbidden();
})->with(collect(Role::cases())->reject(fn (Role $role) => $role === Role::Admin));
```

This PHPUnit test does the same with a data provider. A data provider method is `public static`.

```php
public static function nonAdminRoles(): array
{
    return collect(Role::cases())
        ->reject(fn (Role $role): bool => $role === Role::Admin)
        ->mapWithKeys(fn (Role $role): array => [$role->value => [$role]])
        ->all();
}

#[DataProvider('nonAdminRoles')]
public function test_forbids_roles_other_than_admin(Role $role): void
{
    $this->actingAs(User::factory()->hasOrganization($role)->create())
        ->post('/settings')
        ->assertForbidden();
}
```
</parameterized_tests>
</test_data>

<isolation>
A test that depends on real time, randomness, sleep, or the network can fail for reasons outside the code. Control all four. The [mocking docs](https://laravel.com/docs/13.x/mocking) list Laravel's fakes, facade doubles, and fake assertions.

<choosing_a_double>
Pick the first option that applies to the dependency. A framework fake keeps the real code path, while a mock replaces the dependency.
1. Use the framework fake for events, queues, mail, notifications, storage, the HTTP client, time, and sleep.
2. Use the application's own fake implementation of a service if it has one.
3. Mock a container-resolved contract only when the real implementation leaves the process or is nondeterministic.
4. Use the real implementation for everything else, including the database.
</choosing_a_double>

<framework_fakes>
These rules keep fakes precise.
- Create each fake inside the test that needs it, not in a file-level `beforeEach()` or in `setUp()`. The global fakes in `suite_speed` are the exception.
- Pass class names to `Event::fake()` and `Queue::fake()` when you know what the code dispatches. A fake without class names can hide an unexpected dispatch.
- Use a fake without class names only when the test asserts the complete result, including `assertNothingPushed()`.
- Write one assertion for each fake, which says the code dispatched the item or did not.
- Assert the data of a job or an event when that data is part of the behavior.
- Use `Exceptions::fake()` to assert that the application reports the right exception. `withoutExceptionHandling()` changes the response under test.

Create prerequisite factory records before `Event::fake()`. Factories rely on model events, such as a `creating` hook that sets a UUID. A fake without class names suppresses those events, so the factory can build an invalid model. Call the fake first only when a factory event is under test, and pass that event's class.
</framework_fakes>

<mocking>
Declare an expectation with `shouldReceive()` or `expects()` before the action. Use a spy with `shouldHaveReceived()` after the action. When equality cannot state the expected argument, such as one field of a value object, use `Mockery::on()` or `withArgs()`. `$this->mock(Contract::class)` binds a mock into the container, and `$this->partialMock()` mocks only some methods.

Pest also offers the `mock()` function after `use function Pest\Laravel\mock;`. Prefer Mockery over a PHPUnit mock for a class that Mockery can double, because Laravel's helpers build on Mockery. Pass input through the HTTP test methods instead of mocking the `Request` facade, and call `Config::set()` instead of mocking `Config`.
</mocking>

<outbound_http>
`Http::preventStrayRequests()` makes any request without a matching fake throw instead of reaching the network. `Http::allowStrayRequests([...])` lets listed URL patterns through, such as a local service. Fake the exact endpoint that each test calls, such as `Http::fake(['github.com/*' => Http::response('ok')])`. An `Http::fake()` without an endpoint accepts unexpected requests and can hide defects. The guard covers only Laravel's HTTP client, so check direct Guzzle and cURL calls separately.
</outbound_http>

<time_and_randomness>
These helpers make time and random values fixed.
- Freeze or move time in each test that depends on a date, a period, or a timestamp. Use `$this->freezeTime()`, `$this->freezeSecond()`, `$this->travelTo()`, `$this->travel(5)->days()`, and `$this->travelBack()`, which work in Pest and PHPUnit. Avoid `Carbon::setTestNow()`.
- Use `Str::createRandomStringsUsing()` when the test asserts a generated identifier or slug.
- Use `Sleep::fake()` instead of a real sleep, and assert the sleeps with `Sleep::assertSequence()`, `Sleep::assertSleptTimes()`, or `Sleep::assertNeverSlept()`. `Sleep::fake(syncWithCarbon: true)` also moves Carbon time forward by each fake sleep.
- Restore time and randomness after each test if the suite does not do it already.
- Call `$this->withoutDefer()` to run deferred functions at once in a test.

Laravel's `retry` helper and HTTP client retries sleep through the `Sleep` class, so `Sleep::fake()` covers them. Code that calls PHP's native `sleep()` still pauses.
</time_and_randomness>

<database>
These rules keep database tests honest.
- Run real queries against real records in the test database. A mocked query builder makes the test assert the mock.
- When the serialized shape of a model is a contract, assert the exact keys of `toArray()`. The test then fails when the model exposes a new attribute.
- Test application behavior that the schema causes, such as deleting dependent records through a cascade. Leave the database engine's cascade to the engine.
- Prefer `LazilyRefreshDatabase` over `RefreshDatabase`, so a test that never touches the database runs no migrations.
</database>
</isolation>

<suite_speed>
These settings apply to the project and to CI, not to single tests. Measure first, find the slow test, and change a project-wide setting only after you know the costly work. The [Pest optimizing docs](https://pestphp.com/docs/optimizing-tests) and the [PHPUnit docs](https://phpunit.de/documentation.html) list the speed options.

<environment>
These environment settings remove common waste.
- Set `BCRYPT_ROUNDS=4` in `.env.testing` or `phpunit.xml`. The default of 12 makes the hash take most of the time of each sign-in test.
- Disable Xdebug. Disable PCOV too unless the run needs coverage.
- Disable packages that work on every request in the test environment, such as Pulse, Telescope, and Nightwatch.
- Use the `WithCachedConfig` and `WithCachedRoutes` traits, so the run loads configuration and routes once. In Pest, apply them with `pest()->use(WithCachedConfig::class)`. A test that changes routes per case resets the cache with `CachedState::$cachedRoutes = null` in `setUp()`.
- Call `withoutVite()` so the framework resolves no built asset.

Three causes of a slow suite are common. Xdebug loads without need, a missing `.env.testing` leaves `BCRYPT_ROUNDS` at the default, or code calls native `sleep()`.
</environment>

<global_fakes>
Put three calls in `Pest.php` for Pest, or in the `setUp()` of the base `TestCase` for PHPUnit.
- `Http::preventStrayRequests()`, because one request that reaches the network can slow the whole suite.
- `Sleep::fake(syncWithCarbon: true)`, so retries and backoff do not sleep.
- `Exceptions::fake()`, so the suite reports no exception to an external service.
</global_fakes>

<parallel_runs>
`vendor/bin/pest --parallel` or `php artisan test --parallel` spreads tests across the CPU cores. `php artisan test --parallel` needs `brianium/paratest` as a dev dependency. Add `--processes=N` when the default count does not suit the machine or CI. Laravel creates and migrates one test database per process, with a token suffix such as `_test_1`, and `--recreate-databases` rebuilds them.

A test that fails only in parallel breaks one of these conditions.
- The test creates each record that it reads.
- The test does not depend on the order of the run.
- The test shares no file, cache key, or queue with another test. `ParallelTesting::token()` gives each process a unique name for such a resource.
</parallel_runs>

<fewer_tests>
Pest 5 adds Test Impact Analysis with `vendor/bin/pest --parallel --tia`. It runs only the tests that recent changes affect and replays cached results for the rest. The first run records a dependency graph and needs PCOV or Xdebug. Keep `--tia` out of CI, except in a workflow that records the baseline on merges to `main`.

Pest 4.6 and later balance shards by runtime. Run `vendor/bin/pest --update-shards` to record test times, and commit `tests/.pest/shards.json`. Each CI job then runs `vendor/bin/pest --shard=1/4` with its own first number.
</fewer_tests>

<slow_tests>
`vendor/bin/pest --profile` or `php artisan test --profile` lists the ten slowest tests. Start with them, because one cause often applies to the whole suite. When the cause is unclear, add a temporary event listener or log entry to see what work the test does.
</slow_tests>
</suite_speed>

<existing_features>
Pest, PHPUnit, and Laravel already cover most testing needs. Search the docs for the capability you need, not for a function name you remember. If the installed version lacks the feature, tell the user instead of writing an unconfirmed API. The [Pest feature list](https://pestphp.com/llms.txt) includes the additions of each release.

This table maps a need to the Pest feature to search for.

| Need | Pest feature |
| --- | --- |
| Run one test over many input values | datasets, bound datasets |
| Assert over many values or a collection | higher-order expectations |
| Remove repeated setup from each test in a file | hooks, higher-order tests |
| Apply a convention to the whole codebase | architecture testing |
| Measure whether the suite finds defects | mutation testing |
| Find code without types | type coverage |
| Speed up a slow suite | parallel, profiling |
| Split the suite across CI jobs | sharding, `--update-shards` |
| Run only the tests a change affects | Test Impact Analysis, `--tia` (Pest 5) |
| Run one test while debugging | filtering, `--bail`, `--dirty` |

This table maps a need to the PHPUnit feature to search for.

| Need | PHPUnit feature |
| --- | --- |
| Run one test method over many input values | `#[DataProvider]`, `#[TestWith]` |
| Run a test only after another test passes | `#[Depends]` |
| Select or skip a set of tests | `#[Group]`, `--group`, `--exclude-group` |
| Skip a test on a PHP version or missing extension | `#[RequiresPhp]`, `#[RequiresPhpExtension]` |
| Find tests that depend on run order | `--order-by=random` |
| Speed up a slow suite | ParaTest, `--cache-result` |
| Stop at the first failure while debugging | `--stop-on-failure`, `--filter` |

<laravel_assertions>
Laravel ships assertions for each part of the framework, and the [testing docs](https://laravel.com/docs/13.x/testing) link to each list. Examples are `assertDatabaseHas()`, `assertModelExists()`, `assertSoftDeleted()`, `assertRedirectToRoute()`, `assertJsonPath()`, `Queue::assertPushed()`, and `Notification::assertSentTo()`. A hand-built check fails with "false is not true", which names nothing. A framework assertion names the wrong table, value, or response.

This hand-built check gives an empty failure message.

```php
expect(User::where('email', 'taylor@laravel.com')->exists())->toBeTrue();
```

This assertion names the table and the missing attributes when it fails.

```php
$this->assertDatabaseHas('users', ['email' => 'taylor@laravel.com']);
```
</laravel_assertions>
</existing_features>
