<overview>
This file covers test design and review in Laravel 12 or 13. It targets Pest 4 or 5 and PHPUnit 12 or 13. It covers what to test, names, assertions, endpoint tests, browser tests, and security tests. Read [laravel-testing-data.md](laravel-testing-data.md) for factories, fakes, time, suite speed, and features that already do the work.
</overview>

<frameworks>
Check `composer.json` to see whether the project uses Pest or PHPUnit, and which major version. Write each new test in the style of the tests in the same directory. Each section below gives the Pest form first and the PHPUnit form second where they differ.

These version facts matter for syntax.
- Pest 5 requires PHP 8.4 and runs on PHPUnit 13. Pest 4 runs on PHPUnit 12.
- PHPUnit 12 and 13 read test metadata only from attributes, such as `#[Test]`, `#[DataProvider]`, `#[TestWith]`, `#[Group]`, and `#[CoversClass]`. Doc-comment annotations such as `@test` and `@dataProvider` do nothing.
- Laravel 13 adds the `#[UnitTest]` attribute. It skips the application boot for one method inside a feature test class.

These commands create and run tests.
- `php artisan make:test UserTest` creates a feature test, and `--unit` puts it in `tests/Unit`. Add `--pest` or `--phpunit` to force the style. Pass the class name without the suite directory.
- `php artisan test` accepts every Pest or PHPUnit argument, such as a file path, `--filter=name`, or `--stop-on-failure`.
- `vendor/bin/pest` and `vendor/bin/phpunit` call the runner directly with the same arguments.

The [Laravel testing docs](https://laravel.com/docs/13.x/testing), [Pest docs](https://pestphp.com/docs), and [PHPUnit docs](https://phpunit.de/documentation.html) hold the current names. The installed version in `vendor/` decides which names exist.
</frameworks>

<what_to_test>
Test observable behavior and application contracts. A test must still pass after an implementation change that keeps the behavior.

- Cover every changed decision and each high-value failure mode that applies. A decision is a branch, a validation, a calculation, or an authorization.
- Exercise a declaration through behavior instead of repeating its text in the test.
- Leave framework behavior to framework tests. A relation with a constraint, a cast, a scope, or a validation rule belongs to this project, so test it.
- Write a feature test first. Write a unit test only for logic that does not use the framework.
- Write a browser test only for JavaScript behavior that a feature test cannot reach.
- When two tests detect the same defect, trim the higher-layer test to one case and report the duplication.

Read the code under test before you write the test, and list its decisions. Some code has a defect, such as an empty method, an unused policy, or a write action without validation. Test the actual behavior and report the defect to the user.

A Pest architecture test follows other rules. An `arch()` test declares a convention for a whole directory, such as the parent class of every model. It checks declarations on purpose and fails when a new file breaks the convention.
</what_to_test>

<naming_and_structure>
<file_layout>
Name each test file `{ClassName}Test.php` and place it at the relative path of the class under test. The class `app/Actions/DeleteTeam.php` gets the test `tests/Unit/Actions/DeleteTeamTest.php`. Follow the project's convention for fixture files. Without one, put fixtures in `tests/Fixtures/` and load them by path. Move large literal values out of the test body into fixture files.
</file_layout>

<pest_declarations>
In Pest, use the test function that the other files in the directory use. Without neighbors, use `it()` for behavior with a verb phrase, and `test()` for a declarative fact. A grant in a policy, the labels of an enum, or the shape of a serialized model are declarative facts. Keep one declaration style in each file.
</pest_declarations>

<phpunit_classes>
In PHPUnit, each feature test class extends the project's base `TestCase`. Each unit test class extends `PHPUnit\Framework\TestCase`, as the `make:test --unit` stub does, so it does not boot the application. Mark each test method with the `test_` prefix or the `#[Test]` attribute, as the other files in the directory do.
</phpunit_classes>

<test_names>
The name of a test is a specification. It states the user-visible result and the condition that causes it.

- Name the behavior, not the method under test, because the file name already gives the class.
- Put the exact status code in the name of a test for an API error.
- Leave out `given`, `when`, and `then`.
- Use a verb that describes a result, such as `returns`, `renders`, `creates`, `dispatches`, `rejects`, `forbids`, `falls back`, or `does not`.

These Pest names state a result and its condition.

```php
it('returns 401 when no token is provided', function () { });
it('does not include deployments from deleted environments', function () { });
it('falls back to the default region when none is configured', function () { });
```

These PHPUnit names state the same with underscores.

```php
public function test_unauthenticated_request_redirects_to_login(): void { }
public function test_returns_401_when_no_token_is_provided(): void { }
public function test_valid_payload_creates_record_and_returns_201(): void { }
```

Names such as `it('works correctly')`, `it('returns data')`, `test_store()`, and `test_validation()` name no result. A name such as `it('handleMethod creates record')` names a method instead of a behavior.
</test_names>

<grouping>
In Pest, use `describe()` when one file covers separate lifecycle actions, such as a controller's `index`, `store`, and `destroy`. Skip `describe()` when the file covers one flow. Use a dataset when tests differ only in input. Skip a group that adds nesting without clarity.

In PHPUnit, write one test class for each class under test. When one controller has separate lifecycle actions, write a class for each action, such as `StoreOrderControllerTest` and `UpdateOrderControllerTest`. Use `#[Group]` only to select or skip tests in a run, not to structure a file.
</grouping>
</naming_and_structure>

<assertions>
<arrange_act_assert>
Write each test in three parts, which are the setup, one action, and the assertions. One blank line separates the parts, so the reader needs no comments. Keep each test self-contained, so it uses no value that another test created.
</arrange_act_assert>

<choosing_an_assertion>
Identify the subject of the check first, then use an assertion made for that subject. A subject-specific assertion names the wrong value when it fails. Build a check by hand only when no assertion exists for the subject. This table maps each subject to an assertion.

| Subject | Pest | PHPUnit |
| --- | --- | --- |
| A return value, object state, or transformed value | an `expect()` chain | `assertSame()` or the assertion for the type |
| An HTTP status, JSON, a session, or Inertia | a Laravel response assertion | a Laravel response assertion |
| The state in the database | a Laravel database assertion | a Laravel database assertion |
| The existence of a model | `assertModelExists($model)` | `assertModelExists($model)` |

In Pest, use a PHPUnit assertion only when no expectation and no Laravel assertion fits. Keep one `expect()` chain on one subject, and start a new chain when the subject changes. In PHPUnit, use `assertSame()` and not `assertEquals()`, because `assertSame()` also compares the type. Group the assertions for one subject together.

Prefer `assertModelExists($model)` over `assertDatabaseHas('users', ['id' => $user->id])`. Use a named response assertion, such as `assertNotFound()`, rather than `assertStatus(404)`, so a failure names the broken contract.

Status and content are separate facts. `assertSee` also passes on an error page with the text. Keep `assertOk()` beside it when the status is part of the behavior.

Pest 5 adds validation expectations that give clearer failures than a regular expression. They include `toBeEmail()`, `toBeUlid()`, `toBeIpAddress()`, `toBeMacAddress()`, `toBeHostname()`, `toBeDomain()`, `toBeBase64()`, and `toBeHexadecimal()`, and each works with `not`.
</choosing_an_assertion>

<known_values>
Write the expected value in the test, or compute it by a different method. A value computed with the implementation's logic passes when that logic is wrong. This test repeats the implementation's logic.

```php
$expected = now()->subHours(24)->floorSeconds(30)->toJson();

expect($from)->toBe($expected);
```

This test fixes the input time and asserts a known value.

```php
$this->travelTo('2025-01-01 00:00:00');

expect($from)->toBe('2024-12-31T00:00:00.000000Z');
```

In PHPUnit, the second form ends with `$this->assertSame('2024-12-31T00:00:00.000000Z', $from);`.
</known_values>

<complete_result>
A status code is not the complete result of a write operation. Assert each of these items when the operation changes it.

- The response or the return value.
- The state in the database.
- The jobs and events that the operation dispatches.
- The notifications and mail that the operation sends.

On the failure path, assert that the operation makes none of these changes. A test that asserts only `assertOk()` passes even when the application saves no record.
</complete_result>
</assertions>

<endpoint_tests>
<coverage>
The [HTTP tests docs](https://laravel.com/docs/13.x/http-tests) list the request helpers, authentication helpers, and response assertions. Write a test for each of these cases that applies.

- The request has missing or invalid authentication.
- The request comes from a different tenant, team, or organization.
- The user has an insufficient role or permission.
- The request breaks a route or scope constraint.
- The request fails validation.
- The request is valid. Assert both the response and the saved state.

Assert the application's actual behavior rather than a generic status code. An API returns `401` for a missing or invalid token, while a browser endpoint redirects to the sign-in route.
</coverage>

<tenant_isolation>
Assert the status code for a cross-tenant request. Expect `404` rather than `403` when a tenant must not learn that another tenant's record exists. A `403` confirms that it exists.
</tenant_isolation>

<authorization>
An HTTP test shows that the endpoint authorizes. It cannot show which mechanism refused, because middleware, a policy, and `abort()` all return `403`.

- Assert the complete permission matrix against the policy or the gate, so a failure names the wrong rule.
- Write one HTTP test for one refused role, which proves that the endpoint calls the authorization.
- Use the project's helper for gate abilities and arguments if one exists.
</authorization>

<validation>
Write one test for each validation rule when each failure is a separate contract. Write one test with an empty payload to assert several required fields together. Assert the text of the message the user sees, because a wrong message is a defect. Use a Pest dataset, or a PHPUnit `#[DataProvider]` or `#[TestWith]`, for input values with the same setup and assertions.

Send an invalid value through the application and assert the error. An assertion that an array of rules contains a string tests the declaration, not the behavior. Use such an assertion only for a rule that no request can reach, and state the reason in the test.

The rule-class test owns the matrix of passing and failing values. The endpoint test proves that the endpoint applies the rule and shows the message. When both hold the matrix, move it to the rule-class test and keep one case in the endpoint test. Keep that last case, because the rule-class test still passes when the request omits the rule. The same split applies to policies, scopes, and other classes that a request calls.
</validation>
</endpoint_tests>

<browser_tests>
A browser test is slower than an HTTP test and can fail for reasons outside the code. Write one only for JavaScript behavior, such as a modal, drag and drop, live search, or client-side validation. Assert the state that the user sees and the database state that the interaction saves. Wait for the required state, never for a fixed time, because a fixed wait fails on a slow machine.

<pest_browser_plugin>
Pest 4 and 5 run browser tests through `pestphp/pest-plugin-browser` as normal Pest tests on Playwright. The [browser testing docs](https://pestphp.com/docs/browser-testing) list the interactions, assertions, and devices.

- Installation needs the Composer package and Playwright, through `npm install playwright@latest` and `npx playwright install`.
- Put the tests in `tests/Browser` and run them with `vendor/bin/pest tests/Browser`. Add `--parallel` for the complete suite.
- `--debug` opens the browser and pauses at a failure. `--headed` shows a run that passes.
- `--browser firefox` or `--browser safari` changes the browser. Chrome is the default.
- Call `assertNoJavaScriptErrors()` in each browser test, because a console error is a defect.
- The plugin waits 5 seconds for an element. Raise it for a slow page with `pest()->browser()->timeout(10000)` in `Pest.php`.
- Apply `RefreshDatabase` to browser tests in `Pest.php`. The test hits the application through a real request, and leftover records break the next test.
- Add `tests/Browser/Screenshots` and `tests/Browser/Traces` to `.gitignore`.
- Give `withKeyDown()` a key code such as `KeyA`. A letter such as `'a'` ignores the held modifier.
- Interact inside the `withinFrame()` callback, because an interaction outside it does not reach the frame.
</pest_browser_plugin>

<dusk>
With Laravel Dusk, browser tests live in `tests/Browser` and run with `php artisan dusk`. The run needs ChromeDriver, which `php artisan dusk:install` downloads. The [Dusk docs](https://laravel.com/docs/13.x/dusk) list the selectors, interactions, and assertions.
</dusk>

When the project has neither package, a feature test covers every behavior that a request reaches. Name the package only if the user asks for a real-browser test.
</browser_tests>

<security_tests>
Test each boundary where user input affects authorization, rendered output, or query construction. A defect there is hard to see, because the feature keeps working. Write a test for each of these cases.

- Request a record of a different tenant, team, or organization, and expect the status from `tenant_isolation`.
- Run each unprivileged role through a dataset or data provider over the roles that the endpoint must refuse.
- Render user content in HTML and mail, including names and every free-text field. Assert that dangerous characters are escaped and the raw value is absent.
- Send injection through dynamic query parts, such as sort columns, filter fields, and sort directions.
- Send an unexpected key in a payload or configuration array. A merge that accepts every key can set an attribute the user must not control.

Do not assert an exact entity for an escaped quote, because Markdown and mail CSS inliners can decode it. This Pest test checks escaping in a mail notification.

```php
it('escapes dangerous content in the notification', function () {
    $organization = Organization::factory()->make([
        'name' => "O'Reilly <script>alert('xss')</script>",
    ]);

    $content = (new QuotaApproaching($organization, 80))->toMail()->render();

    expect($content)
        ->toContain('&lt;script&gt;')
        ->not->toContain("<script>alert('xss')</script>");
});
```

This PHPUnit test checks the same escaping.

```php
public function test_escapes_dangerous_content_in_the_notification(): void
{
    $organization = Organization::factory()->make([
        'name' => "O'Reilly <script>alert('xss')</script>",
    ]);

    $content = (new QuotaApproaching($organization, 80))->toMail()->render();

    $this->assertStringContainsString('&lt;script&gt;', $content);
    $this->assertStringNotContainsString("<script>alert('xss')</script>", $content);
}
```

Laravel defends against mass assignment, unauthorized access, and unescaped output. The tests prove that the application applies the right defense to each attribute, route, and template.
</security_tests>

<reviewing_tests>
A test can pass and still have no value. For each test, name the defect it would catch. When an issue runs through the whole suite as a convention, report the pattern once. An existing test that follows a project convention is not a defect. Explain its drawbacks and let the user decide. In Pest, the value checks skip `arch()` tests, which state a directory convention.

These checks cover value and structure.
- The test covers observable behavior and survives an implementation change that keeps the behavior.
- The test exercises declarations through behavior and does not test the framework.
- The test detects a defect that no other test covers.
- Every changed decision and each high-value failure mode has coverage.
- The file name, path, test names, and declaration style follow `naming_and_structure`.

These checks cover coverage, data, and assertions.
- HTTP tests cover authentication, authorization, role, scope, and validation where they apply.
- A cross-tenant request gets a status that does not confirm the record exists.
- The full permission matrix lives in policy tests, not controller tests.
- Each validation rule has a test that asserts the visible message.
- Rendered user input and each dynamic query part have a security test.
- Each test creates its own mutable records, and `beforeEach()` or `setUp()` holds configuration only.
- Each `make()` call is in a test that needs no database.
- Each test controls time, randomness, sleep, and outbound HTTP, and passes alone and in any order.
- Each expected value is known in advance, and each write test asserts response, database state, and side effects.
- Each fake has one assertion and names its classes, unless the test asserts the complete result.
</reviewing_tests>
