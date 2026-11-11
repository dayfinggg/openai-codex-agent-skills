<triggers>
Apply this rule when a process or test run does not exit. Typical signs are a `node --test` run that never ends or "open handles" in the output. A CI timeout after the tests look done is another. A suite that passes file by file but hangs as a whole is another sign.
</triggers>

<procedure>
Work through five steps in order.

1. Isolate the hang. Reproduce it with one file, then with one test name.
2. Make it fail fast. Run with an explicit timeout and a reporter, so a hang reports where it happened.
3. Capture the handles. Run `why-is-node-running` and note which code owns each open handle.
4. Fix the teardown in the scope that created the resource. Use `t.after(...)` and await each close, terminate, or disconnect call.
5. Prove the fix. Repeat the isolated test many times, then run the full suite.

The issue is fixed only when step 5 passes, as the `verification` block of the coding instructions requires.
</procedure>

<commands>
These commands reproduce the full run with fail-fast settings, then narrow it to one file and one test.

```bash
node --test --test-reporter=spec --test-timeout=15000
node --test --test-timeout=15000 path/to/file.test.ts
node --test --test-timeout=15000 --test-name-pattern="should close resources" path/to/file.test.ts
```

`why-is-node-running` prints the open handles when it receives `SIGUSR1`. Start the hung run with it, then send the signal to the printed PID from another shell. Windows has no `SIGUSR1`, so run this step in WSL, Linux, or macOS.

```bash
node --import why-is-node-running/include --test path/to/file.test.ts
kill -SIGUSR1 <pid>
```

This loop reruns the isolated test 30 times and stops at the first failure. Linux provides `timeout`, and macOS provides `gtimeout` through coreutils.

```bash
TIMEOUT_BIN="$(command -v timeout || command -v gtimeout)"
for i in {1..30}; do
  "$TIMEOUT_BIN" 30s node --test path/to/file.test.ts || { echo "failed on run $i"; break; }
done
```

The current `why-is-node-running` release supports ESM on Node.js 20.11 and later. Projects on old CommonJS setups use `why-is-node-running@v2`. It is a dependency, so add it only when the user agrees, as `code_rules` requires. Use it only for diagnosis, and keep its output out of normal CI runs.
</commands>

<root_causes>
These causes explain most hangs.

- An HTTP server started and never closed, or `server.close()` not awaited
- A `setInterval` left running, or a timer that should be `unref()`ed
- Database, Redis, or Kafka clients not disconnected
- Worker threads, child processes, or message channels left alive
- File watchers or readline interfaces still open
- Promises from fire-and-forget async code that never settle
- Teardown hooks that throw before cleanup completes
</root_causes>

<example>
In a typical case, a CI job times out, and a local full run hangs after most tests pass. Run the five steps of the procedure, then compare the test with the fixed version below. This test starts a server and an interval and never cleans them up.

```typescript
it('serves requests', async () => {
  const server = await startServer({ port: 0 });
  const id = setInterval(() => {}, 1000);
});
```

The fixed test registers the teardown right after it creates the resources. It clears the interval and waits until the server has closed.

```typescript
import { once } from 'node:events';

it('serves requests', async (t) => {
  const server = await startServer({ port: 0 });
  const id = setInterval(() => {}, 1000);

  t.after(async () => {
    clearInterval(id);
    server.close();
    await once(server, 'close');
  });
});
```
</example>

<done_when>
The hang is fixed when four checks pass.

- [ ] The isolated test passes 30 runs in a row with no hang.
- [ ] The full `node --test` run exits with code 0.
- [ ] CI completes with no timeout.
- [ ] `why-is-node-running` shows no unexpected open handles.
</done_when>

<related>
The `testing` skill covers intermittent failures. [testing.md](testing.md) covers the test runner, and [graceful-shutdown.md](graceful-shutdown.md) covers server teardown.
</related>
