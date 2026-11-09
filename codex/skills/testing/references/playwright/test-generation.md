<overview>
This file covers how to plan, generate, and heal Playwright tests with `playwright-cli`. Use the plan and generate parts when the user asks for new Playwright tests or a test plan. Use the heal part when existing Playwright tests fail. Every `playwright-cli` action prints the matching Playwright TypeScript, and that code is the raw material for every test.

The sections work on their own.
- How generation works covers the core mechanic, where actions become TypeScript, and how to add assertions.
- Plan explores the app and writes a spec file that lists what to test.
- Generate turns a spec into test files, and updates the spec when it is vague or stale.
- Heal diagnoses failing tests, fixes them, and brings the spec in line with the app.

All three rely on one mechanic. Run `npx playwright test --debug=cli` in the background, then run `playwright-cli attach tw-XXXX` to drive the paused page. [playwright-tests.md](playwright-tests.md) explains the debug and attach steps.
</overview>
<contents>
This file has these sections, in order.
- how generation works
- plan
- generate
- heal
</contents>


<how_generation_works>
Every action you perform with `playwright-cli` prints the matching Playwright TypeScript code. You can copy it directly into test files. In this session, the snapshot shows `e1` as the Email textbox and `e2` as the Password textbox. `e3` is the Sign In button.

```bash
playwright-cli open https://example.com/login
playwright-cli snapshot
playwright-cli fill e1 "user@example.com"
playwright-cli fill e2 "password123"
playwright-cli click e3
```

The three actions print this code.

```typescript
await page.getByRole('textbox', { name: 'Email' }).fill('user@example.com');
await page.getByRole('textbox', { name: 'Password' }).fill('password123');
await page.getByRole('button', { name: 'Sign In' }).click();
```

This test collects the generated code and adds an assertion.

```typescript
import { test, expect } from '@playwright/test';

test('login flow', async ({ page }) => {
  await page.goto('https://example.com/login');
  await page.getByRole('textbox', { name: 'Email' }).fill('user@example.com');
  await page.getByRole('textbox', { name: 'Password' }).fill('password123');
  await page.getByRole('button', { name: 'Sign In' }).click();
  await expect(page).toHaveURL(/.*dashboard/);
});
```

<semantic_locators>
The generated code uses role-based locators where it can, because they survive markup changes. A CSS selector such as `page.locator('#submit-btn')` breaks more easily than this role locator.

```typescript
await page.getByRole('button', { name: 'Submit' }).click();
```

Take a snapshot to learn the page structure before you record actions.
</semantic_locators>

<assertions>
Generated code captures actions but not assertions. Add expectations with one of these matchers.
- `toBeVisible()` checks that the element is rendered and visible.
- `toHaveText(text)` checks the element's text content.
- `toHaveValue(value)` and `toBeEmpty()` check an input or select value.
- `toBeChecked()` and `not.toBeChecked()` check a checkbox state.
- `toMatchAriaSnapshot(snapshot)` checks the page or a locator against a partial accessibility snapshot.

Use `playwright-cli generate-locator <target>` for the locator in the assertion. Use the snapshot and eval commands to capture the expected value.

When you assert text content, make sure the locator does not contain text from the element itself. `getByTestId()` and `getByLabel()` usually work well for text assertions. When the locator is text-based, prefer `toBeVisible()`.

The aria snapshot does not need all the information. Capture only what the assertion needs, and use regular expressions for unstable values. These commands produce the locator and the expected values.

```bash
playwright-cli --raw generate-locator e5
playwright-cli --raw eval "el => el.textContent" e5
playwright-cli --raw eval "el => el.value" e5
playwright-cli --raw snapshot
playwright-cli --raw snapshot e5
```

These assertions use those outputs. The first aria snapshot matches a region anywhere on the page, and the second is scoped to the navigation.

```typescript
await page.getByRole('button', { name: 'Submit' }).click();

await expect(page.getByRole('alert', { name: 'Success' })).toBeVisible();
await expect(page.getByTestId('main-header')).toHaveText('Welcome, user');
await expect(page.getByRole('textbox', { name: 'Email' })).toHaveValue('user@example.com');
await expect(page.getByRole('checkbox', { name: 'Enable notifications' })).toBeChecked();

await expect(page).toMatchAriaSnapshot(`
  - heading "Welcome, user"
  - link /\\d+ new messages?/
  - button "Sign out"
`);

await expect(page.getByRole('navigation')).toMatchAriaSnapshot(`
  - link "Home"
  - link /\\d+ new messages?/
  - link "Profile"
`);
```
</assertions>
</how_generation_works>

<plan>
The goal is a spec file, such as `specs/<feature>.plan.md`, that lists the scenarios to test. Write the spec to a file.

<workspace>
Check that the workspace has Playwright installed before anything else. Either of these commands confirms it.

```bash
test -f playwright.config.ts || test -f playwright.config.js
npx --no-install playwright --version
```

If Playwright is missing, ask the user before you bootstrap it with `npm init playwright@latest`, and let the user pick the defaults.
</workspace>

<seed_test>
A seed test is a minimal test that brings the page to the state every scenario starts from. It covers navigation to the app, any required login, and settings such as feature toggles. Scenarios assume a fresh start after the seed. `--debug=cli` pauses inside this test, so every planning and generation session begins there.

The minimal seed lives in `tests/seed.spec.ts`.

```ts
import { test } from '@playwright/test';

test('seed', async ({ page }) => {
  await page.goto('https://example.com/');
});
```

The preferred form moves navigation into a fixture in `tests/fixtures.ts`, so scenario tests reuse it.

```ts
import { test as baseTest } from '@playwright/test';
export { expect } from '@playwright/test';

export const test = baseTest.extend({
  page: async ({ page }, use) => {
    await page.goto('https://example.com/');
    await use(page);
  },
});
```

The seed then has an empty body, because the fixture already navigates. The empty test marks where sessions start.

```ts
import { test } from './fixtures';

test('seed', async ({ page }) => {
});
```

If no seed exists, create one that at least navigates to the app.
</seed_test>

<explore>
Run the seed in the background and attach. Wait for "Debugging Instructions" and the session name `tw-XXXX` before you attach.

```bash
PLAYWRIGHT_HTML_OPEN=never npx playwright test tests/seed.spec.ts --debug=cli
playwright-cli attach tw-XXXX
```

`resume` lets the seed run to the end. Then probe the app. `snapshot` lists the interactive elements, `eval` reads the URL or state, and `show --annotate` lets the user point at something.

```bash
playwright-cli resume
playwright-cli snapshot
playwright-cli click e5
playwright-cli eval "location.href"
playwright-cli show --annotate
```

Map out these areas.
- Interactive surfaces, such as forms, buttons, lists, filters, and modals.
- The primary user journeys from end to end.
- Edge cases, such as empty states, validation errors, very long input, and boundary values.
- Persistence across a reload, in local or session storage, and in URL fragments.
- Navigation, meaning which controls change the URL and how back and forward behave.

Always start from the test, not from the app URL in `playwright-cli`. Then you capture the setup the test does. Stop the background test when you finish exploring.
</explore>

<spec_file>
Save the spec under `specs/<feature>.plan.md` with this structure.

```markdown
# <Feature> Test Plan

## Application Overview

<One paragraph describing what the feature does and why it matters.>

## Test Scenarios

### 1. <Group Name>

**Seed:** `tests/seed.spec.ts`

#### 1.1. <kebab-case-scenario-name>

**File:** `tests/<group>/<kebab-case-scenario-name>.spec.ts`

**Steps:**
  1. <Concrete user step>
    - expect: <observable outcome>
    - expect: <another observable outcome>
  2. <Next step>
    - expect: <outcome>

#### 1.2. <next-scenario>
...

### 2. <Next Group>

**Seed:** `tests/seed.spec.ts`
...
```

The spec follows these guidelines.
- Each scenario is independent and starts from the seed's fresh state. Never chain scenarios.
- Scenario names are kebab-case and match the test file name, as `should-add-single-todo` matches `should-add-single-todo.spec.ts`.
- Cover the happy path, edge cases, validation, negative flows, and persistence.
- Write steps at the user level, as in "Type 'Buy milk' into the input". Do not write them at the API level, as in "call `fill`".
- Put each observable outcome in an `- expect:` line, because each one becomes an assertion.
</spec_file>
</plan>

<generate>
The goal is Playwright test files from a spec file, with spec updates where it has drifted.

<inputs>
Generation takes three inputs.
- The spec file, such as `specs/basic-operations.plan.md`.
- The target, which is one scenario such as `1.2`, a whole group such as `1`, or all scenarios.
- The seed file, from the `Seed` line of the scenario's group.
</inputs>

<one_scenario>
Handle target scenarios one after another, never in parallel, because they share the seed session. Start the seed in the background, attach, and resume.

```bash
PLAYWRIGHT_HTML_OPEN=never npx playwright test <seed-file> --debug=cli
playwright-cli attach tw-XXXX
playwright-cli resume
```

Always start from the test, not from the app URL in `playwright-cli`. Then you capture the setup the test does.

Walk the scenario's steps one by one with `playwright-cli`. The spec is the plan, and the live app is the source of truth. A step can be vague, as in "click the button" with several buttons. It can name an element that no longer exists, or contradict what the app does. Then update the spec to match what the app really does, and continue. Editing the spec during generation is expected.

Every action prints the matching Playwright TypeScript, as `how_generation_works` describes.

```bash
playwright-cli snapshot
playwright-cli fill e3 "John Doe"
playwright-cli press Enter
playwright-cli click e7
```

Add an explicit assertion for each `- expect:` line. Collect the generated code and write the test file at the path the spec gives. Import from `./fixtures` if the project has that file, and from `@playwright/test` otherwise. In this example, the seed fixture handles navigation.

```ts
import { test, expect } from './fixtures';

test.describe('Signing in and out', () => {
  test('should sign in', async ({ page }) => {
    await page.getByRole('textbox', { name: 'username' }).fill('John Doe');
    await page.getByRole('textbox', { name: 'password' }).fill('TestPassword');
    await page.getByRole('textbox', { name: 'password' }).press('Enter');
    await expect(page.getByRole('heading')).toContainText('Welcome, John Doe!');
  });
});
```

Generated files follow these rules.
- Each file holds one test. The file path, describe name, and test name come verbatim from the spec.
- The describe name is the group name without its ordinal, so "1. Signing in and out" becomes "Signing in and out".
- Close the CLI session and stop the background test before you move to the next scenario.
</one_scenario>

<several_scenarios>
Repeat `one_scenario` for each target scenario. Restart the seed between scenarios, so every test starts from a clean page. Stop each test run before you start the next.
</several_scenarios>

<run_generated_tests>
Run each new test once after generation. A failure goes to `heal`.

```bash
PLAYWRIGHT_HTML_OPEN=never npx playwright test tests/<group>/<scenario>.spec.ts
```
</run_generated_tests>
</generate>

<heal>
The goal is to fix failing tests, and to update the spec when the app's intended behavior changed.

<find_failures>
Run the suite and record each failing `<file>:<line>`. Fix them one at a time, not in parallel. Shared state and the single CLI session make parallel fixes fragile.

```bash
PLAYWRIGHT_HTML_OPEN=never npx playwright test
```
</find_failures>

<debug_one_failure>
Run the single failing test in debug mode in the background, wait for the session name, and attach.

```bash
PLAYWRIGHT_HTML_OPEN=never npx playwright test tests/<group>/<scenario>.spec.ts:<line> --debug=cli
playwright-cli attach tw-XXXX
```

The test pauses at the start. Step forward, or run to just before the failing action or assertion. Then diagnose the page.

`snapshot` shows whether the element changed, moved, or got a new name. `console` shows errors in the app. `requests` shows failed requests and wrong payloads. `show --annotate` lets the user point at something.

```bash
playwright-cli snapshot
playwright-cli console
playwright-cli requests
playwright-cli show --annotate
```

Common causes are selector drift, a new wrapper element, and a renamed label or ARIA name. Timing after a transition or async load is another. Others are assertion text that the app changed, and test data that leaks between runs. Rehearse the corrected interaction with `playwright-cli`, and paste the generated code back into the test.
</debug_one_failure>

<apply_the_fix>
Edit the test file to update the locator, assertion, step order, or inputs. Stop the background debug run, and run the single test again to confirm it passes. Never skip hooks or add sleeps as a fix, and never use `networkidle`.
</apply_the_fix>

<reconcile_with_the_spec>
Find the spec scenario whose file path matches the test file. Then compare the fix with the spec.
- A purely technical fix, such as locator drift or a better assertion, leaves the spec alone. That holds while the spec's user-level behavior still matches the app.
- A fix that changed user-visible steps, inputs, order, or expected outcomes needs a spec update. Keep the scenario id and file path, and change only the step and expect lines.
- When it is unclear whether the app change is intended or a regression, stop and ask the user. Give the scenario id and the spec lines that no longer match. Add the observed behavior from a snapshot excerpt or a concrete outcome.

After the user answers, update the spec for an intended change. For a regression, flag the test as covering a bug.
</reconcile_with_the_spec>

<iteration>
Fix failures one at a time, and run the test again after each fix. Sometimes the test is correct, the app is wrong, and the user confirms the bug. Then mark the test with `test.fixme()`, and give the user's decision or the issue link in its description. Never skip a test silently.
</iteration>
</heal>
