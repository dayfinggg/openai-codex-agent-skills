<overview>
A flaky test passes or fails without a code change. Flaky tests erode trust in the suite and waste debugging time. Find the root cause and fix it, as the `debugging` block of the coding instructions requires. A retry, a longer timeout, or a skipped test hides the fault. The `verification` block rules out each of them.
</overview>

<find_the_timing_out_test>
Six techniques find the test or file that times out.

1. Use a detailed reporter. The `tap` reporter prints each test file and name as it runs. The `spec` reporter shows the hierarchy, and `tee` keeps a log of where the run stopped.

```bash
node --test --test-reporter=tap
node --test --test-reporter=spec
node --test --test-reporter=spec 2>&1 | tee test-output.log
```

2. Set a global timeout. The failure message then names the test and its file and line.

```bash
node --test --test-timeout=5000
```

3. Run the test files one at a time to isolate the slow one.

```bash
for f in src/**/*.test.ts; do
  echo "Running: $f"
  timeout 30s node --test "$f" || echo "TIMEOUT or FAIL: $f"
done
```

4. Log from the test hooks. The last line in the output shows where the run stopped.

```typescript
import { describe, it, before, after, beforeEach, afterEach } from 'node:test';

describe('MyTests', () => {
  before(() => console.log('[BEFORE] MyTests starting'));
  after(() => console.log('[AFTER] MyTests complete'));
  beforeEach((t) => console.log(`[BEFORE EACH] Starting: ${t.name}`));
  afterEach((t) => console.log(`[AFTER EACH] Finished: ${t.name}`));

  it('test 1', () => {});
  it('test 2', () => {});
});
```

5. Debug the hanging test with the inspector. Connect Chrome DevTools at `chrome://inspect` and check the async call stack for pending work.

```bash
node --inspect --test src/hanging.test.ts
```

6. Use wtfnode to dump what keeps Node.js alive. Call `wtfnode.dump()` in an `after` hook.

```typescript
import { describe, it, after } from 'node:test';
import wtfnode from 'wtfnode';

describe('Debug hanging tests', () => {
  after(() => {
    wtfnode.dump();
  });

  it('might hang', async () => {});
});
```

For a process that never exits, follow [stuck-processes-and-tests.md](stuck-processes-and-tests.md).
</find_the_timing_out_test>

<common_causes>
<race_conditions>
A race condition makes a test pass locally and fail in CI or at random. This test sleeps 100 ms and fails when processing takes longer.

```typescript
it('should process after delay', async (t) => {
  let processed = false;
  processAsync(() => { processed = true; });

  await new Promise(resolve => setTimeout(resolve, 100));
  t.assert.equal(processed, true);
});
```

Wait for the actual result instead. This test awaits the operation itself.

```typescript
it('should process after delay', async (t) => {
  const result = await processAsync();
  t.assert.equal(result.processed, true);
});
```
</race_conditions>

<time_dependencies>
A dependency on the current time makes tests fail around midnight, at month boundaries, or in other time zones. This test hard-codes today's date and fails tomorrow.

```typescript
it('should format today', (t) => {
  const result = formatDate(new Date());
  t.assert.equal(result, '2024-01-15');
});
```

Pass a fixed date instead. This test always formats the same moment.

```typescript
it('should format date', (t) => {
  const fixedDate = new Date('2024-01-15T12:00:00Z');
  const result = formatDate(fixedDate);
  t.assert.equal(result, '2024-01-15');
});
```

When the code reads the clock itself, mock `Date` with the `node:test` mock timers. Mock timers are stable since Node.js 23.1.

```typescript
it('should format today', (t) => {
  t.mock.timers.enable({ apis: ['Date'] });
  t.mock.timers.setTime(new Date('2024-01-15T12:00:00Z').getTime());

  const result = formatDate(new Date());
  t.assert.equal(result, '2024-01-15');
});
```
</time_dependencies>

<port_conflicts>
A hard-coded port causes `EADDRINUSE` errors when tests run in parallel. This test always binds port 3000.

```typescript
it('should start server', async (t) => {
  const server = await startServer({ port: 3000 });
});
```

Use port 0 instead, so the operating system assigns a free port. Read the port from `server.address()`.

```typescript
it('should start server', async (t) => {
  const server = await startServer({ port: 0 });
  const address = server.address();
  const port = address.port;
});
```
</port_conflicts>

<shared_state>
Shared state makes tests pass alone and fail together. In this file, module-level state persists, so test 2 still sees the value from test 1.

```typescript
let cache = new Map();

it('test 1', (t) => {
  cache.set('key', 'value1');
  t.assert.equal(cache.get('key'), 'value1');
});

it('test 2', (t) => {
  t.assert.equal(cache.get('key'), undefined);
});
```

Reset the state in `beforeEach`, or keep it inside the test. Here each test gets a new `Map`, and test 2 passes.

```typescript
describe('cache tests', () => {
  let cache;

  beforeEach(() => {
    cache = new Map();
  });

  it('test 1', (t) => {
    cache.set('key', 'value1');
    t.assert.equal(cache.get('key'), 'value1');
  });

  it('test 2', (t) => {
    t.assert.equal(cache.get('key'), undefined);
  });
});
```
</shared_state>

<order_dependencies>
An order dependency makes tests pass in one order and fail in another. It often shows up with `--test-isolation=none`, a higher `--test-concurrency`, or `--test-name-pattern`. Here test 2 depends on the row that test 1 inserted.

```typescript
it('test 1: create user', async (t) => {
  await db.insert({ id: 1, name: 'John' });
  t.assert.ok(true);
});

it('test 2: find user', async (t) => {
  const user = await db.findById(1);
  t.assert.equal(user.name, 'John');
});
```

Let each test set up its own data. This version of test 2 inserts the row it reads.

```typescript
it('test 2: find user', async (t) => {
  await db.insert({ id: 1, name: 'John' });
  const user = await db.findById(1);
  t.assert.equal(user.name, 'John');
});
```
</order_dependencies>

<unhandled_rejections>
A fire-and-forget call can reject after the test ends. The test then looks green, but the process exits with an error. This test does not await the call.

```typescript
it('should send notification', async (t) => {
  sendNotification(user);
  t.assert.ok(true);
});
```

Await every async operation. This version waits for the notification.

```typescript
it('should send notification', async (t) => {
  await sendNotification(user);
  t.assert.ok(true);
});
```
</unhandled_rejections>

<resource_cleanup>
Missing cleanup causes "too many open files" errors or exhausted connections. This test never closes its file handle.

```typescript
it('should read file', async (t) => {
  const handle = await fs.open('test.txt');
  const content = await handle.read();
  t.assert.ok(content);
});
```

Register the cleanup with `t.after()` right after you create the resource.

```typescript
it('should read file', async (t) => {
  const handle = await fs.open('test.txt');
  t.after(() => handle.close());

  const content = await handle.read();
  t.assert.ok(content);
});
```
</resource_cleanup>
</common_causes>

<debugging_strategies>
<isolation>
Run one file, or one test by name.

```bash
node --test src/user.test.ts
node --test --test-name-pattern="should create user" src/user.test.ts
```
</isolation>

<expose_races>
Raise the concurrency or repeat a test many times to make a race show up.

```bash
node --test --test-concurrency=10
for i in {1..50}; do node --test src/flaky.test.ts || echo "Failed on run $i"; done
```

`--test-rerun-failures <file>` stores the failed tests of a run in a state file. The next run with the same file runs only those tests, so you can reproduce a failure fast. A test that fails and then passes on a rerun is flaky. Fix its cause instead of relying on the rerun.
</expose_races>

<diagnostic_logging>
Log timing and intermediate results to see what differs between a pass and a fail. Remove the logs once you fixed the cause.

```typescript
it('flaky test', async (t) => {
  console.log('Test started at:', Date.now());

  const result = await operation();
  console.log('Result:', JSON.stringify(result));

  t.assert.ok(result);
});
```
</diagnostic_logging>

<async_leaks>
Track handles that a test creates to find leaks. This suite reports every timer that a test did not clear.

```typescript
import { describe, it, after } from 'node:test';

describe('async leak detection', () => {
  const activeHandles = new Set();

  after(() => {
    if (activeHandles.size > 0) {
      console.error('Leaked handles:', [...activeHandles]);
    }
  });

  it('should not leak', async (t) => {
    const timer = setTimeout(() => {}, 10000);
    activeHandles.add(timer);

    clearTimeout(timer);
    activeHandles.delete(timer);
  });
});
```
</async_leaks>
</debugging_strategies>

<prevention>
<deterministic_ids>
Use predictable IDs in tests, because random IDs make a failure hard to trace. Derive the ID from the test name instead of `crypto.randomUUID()`.

```typescript
const id = `test-user-${t.name}`;
```
</deterministic_ids>

<mock_external_services>
Mock network calls in unit tests to avoid network flakiness. This test replaces `fetch` for its own duration.

```typescript
it('should fetch user', async (t) => {
  t.mock.method(globalThis, 'fetch', async () => ({
    ok: true,
    json: async () => ({ id: '1', name: 'John' }),
  }));

  const user = await fetchUser('1');
  t.assert.equal(user.name, 'John');
});
```

A mock that throws on an unknown URL also catches calls the test did not expect.

```typescript
t.mock.method(globalThis, 'fetch', async (url) => {
  if (url.includes('api.external.com')) {
    return { ok: true, json: async () => mockData };
  }
  throw new Error(`Unmocked URL: ${url}`);
});
```
</mock_external_services>

<explicit_waits>
Wait for a condition, not for a fixed time. `t.waitFor()` (Node.js 23.7 and 22.14) retries an assertion until it passes or its timeout elapses. The defaults are a 50 ms interval and a 1000 ms timeout.

```typescript
it('shows the element', async (t) => {
  await t.waitFor(() => {
    t.assert.ok(element.isVisible());
  }, { timeout: 5000 });
});
```
</explicit_waits>

<transactions>
Wrap each database test in a transaction and roll it back, so tests cannot see each other's rows.

```typescript
describe('database tests', () => {
  beforeEach(async () => {
    await db.query('BEGIN');
  });

  afterEach(async () => {
    await db.query('ROLLBACK');
  });

  it('should insert record', async (t) => {
    await db.insert({ name: 'test' });
    const records = await db.findAll();
    t.assert.equal(records.length, 1);
  });
});
```
</transactions>
</prevention>

<ci_flakiness>
CI machines often have less CPU and memory than a laptop. A test that fails only there usually has a race or a hidden time budget. Reproduce it locally with high concurrency or limited CPU, and fix the cause. Give a heavy test an explicit `timeout` only when the work really needs the time. Base the value on measured durations.

Run CI with a controlled concurrency so tests compete less for resources.

```bash
node --test --test-concurrency=2
```
</ci_flakiness>
