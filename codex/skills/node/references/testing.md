<contents>
This file has these sections, in order.
- scope
- built in runner
- mocking
- snapshots
- event emitter timing
- running tests
- flaky runs
</contents>

<scope>
Use the test runner and the test layout the project already has. Add tests only when the `code_rules` block allows it. The patterns here use the built-in `node:test` runner, and most of them carry over to Vitest or Jest.
</scope>

<built_in_runner>
The built-in runner needs no dependency. `t.assert` gives the `node:assert` methods bound to the test context.

```typescript
import { describe, it, before } from 'node:test';

describe('UserService', () => {
  let service: UserService;

  before(() => {
    service = new UserService();
  });

  it('should create a user', async (t) => {
    const user = await service.create({ name: 'John' });
    t.assert.equal(user.name, 'John');
    t.assert.ok(user.id);
  });

  it('should throw on invalid input', async (t) => {
    await t.assert.rejects(
      () => service.create({ name: '' }),
      { message: 'Name is required' }
    );
  });
});
```
</built_in_runner>

<mocking>
`t.mock` creates mocks that the runner restores after the test. This test passes a mock function as the email provider and checks its calls.

```typescript
import { describe, it } from 'node:test';

describe('EmailService', () => {
  it('should send email via provider', async (t) => {
    const sendMock = t.mock.fn(async () => ({ success: true }));
    const provider = { send: sendMock };
    const service = new EmailService(provider);

    await service.sendWelcome('user@example.com');

    t.assert.equal(sendMock.mock.calls.length, 1);
    t.assert.deepEqual(sendMock.mock.calls[0].arguments, [
      'user@example.com',
      'Welcome!',
    ]);
  });
});
```

`t.mock.method` replaces a method on an object. This test replaces the global `fetch`.

```typescript
import { describe, it } from 'node:test';

describe('UserController', () => {
  it('should fetch user from API', async (t) => {
    t.mock.method(globalThis, 'fetch', async () => ({
      ok: true,
      json: async () => ({ id: '1', name: 'John' }),
    }));

    const user = await fetchUser('1');
    t.assert.equal(user.name, 'John');
  });
});
```

`t.mock.property` (Node.js 24.3 and 22.20) replaces a property value. `t.mock.module` replaces a whole module. It is still early development and needs the `--experimental-test-module-mocks` flag. Pass the replacement as one `exports` object, because the `defaultExport` and `namedExports` options are deprecated.

```typescript
t.mock.module('./dependency.ts', {
  exports: { default: defaultMock, parse: parseMock },
});
```
</mocking>

<snapshots>
Snapshots fit complex output. `t.assert.snapshot` stores values in a snapshot file next to the test. `t.assert.fileSnapshot(value, path)` (Node.js 23.7 and 22.14) stores one value in a file of your choice. Run with `--test-update-snapshots` to create or update the snapshots.

```typescript
import { describe, it } from 'node:test';

describe('ReportGenerator', () => {
  it('should generate expected report', async (t) => {
    const report = await generateReport(sampleData);
    t.assert.snapshot(report);
  });
});
```
</snapshots>

<event_emitter_timing>
Register an `EventEmitter` listener before you trigger the action that emits the event. An event emitted before `on()`, `once()`, or `events.once()` is attached is lost. The test then hangs or fails at random. This test subscribes first and starts the work second.

```typescript
import { EventEmitter, once } from 'node:events';

it('waits for ready event', async (t) => {
  const emitter = new EventEmitter();

  const readyPromise = once(emitter, 'ready');

  startWorkThatEmitsReady(emitter);

  const [payload] = await readyPromise;
  t.assert.equal(payload.status, 'ok');
});
```
</event_emitter_timing>

<running_tests>
These commands run all tests, one file, TypeScript test files, coverage, and watch mode. TypeScript files run without a flag on Node.js 22.18, 23.6, and later.

```bash
node --test
node --test src/user/user.service.test.ts
node --test "src/**/*.test.ts"
node --test --experimental-test-coverage
node --test --watch
```

Coverage is still experimental. `--test-coverage-lines`, `--test-coverage-branches`, and `--test-coverage-functions` set minimum thresholds. [node-lts.md](node-lts.md) lists newer runner features, such as global setup, tags, reruns, and expected failures.
</running_tests>

<flaky_runs>
For a test that fails only sometimes, follow the flaky test procedure of the `testing` skill. These `node:test` options serve it. `--test-name-pattern="<name>"` runs one test, and `--test-timeout=<ms>` makes a hang fail with the test name. `--test-concurrency=<n>` raises the load to expose a race, and a shell loop repeats a file. `--test-rerun-failures <file>` (24.7) stores the failed tests of a run and runs only those next time. `t.waitFor()` (23.7 and 22.14) retries an assertion until it passes, with a 50 ms interval and a 1000 ms timeout by default, so no test needs a fixed sleep. `t.mock.timers.enable({ apis: ['Date'] })` pins the clock, and mock timers are stable since 23.1. Register cleanup with `t.after()` right after you create a resource, and bind port 0 so the system assigns a free port.
</flaky_runs>
