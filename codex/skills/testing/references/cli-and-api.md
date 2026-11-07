<cli_testing>
Test a command-line tool through its process boundary, the way a user or a script runs it. Run the real binary or entry point in a subprocess, not its internal functions.

Each check covers one part of the contract.
- The exit code is 0 on success and nonzero on each documented failure. Many tools exit 2 on bad usage, as Python's `argparse` does.
- Stdout carries the data, and stderr carries diagnostics. Assert each stream on its own, so an error message cannot hide in the output.
- Machine-readable output, such as `--json`, parses cleanly and contains no log lines.
- Input comes from arguments, files, an empty stdin, and piped stdin. Behavior that differs on a TTY gets a test for each case.
- The test runs in a temporary directory with a controlled environment. Set `NO_COLOR=1`, a fixed `TZ`, and a fixed locale when output depends on them.

Golden files hold the expected output of a command in a file next to the test. Compare the output with the file. Give the test an explicit update mode, such as the `-update` flag common in Go tests. Normalize unstable parts before the comparison, such as timestamps, temporary paths, colors, and Windows line endings. Review every change to a golden file as a code change. Regenerating a golden file to pass a failing test hides the fault that the `verification` block forbids.

This pytest test checks the exit code and both streams for an unknown flag.

```python
import os
import subprocess


def test_unknown_flag_exits_2_with_usage_on_stderr(tmp_path):
    result = subprocess.run(
        ["mytool", "--bogus"],
        cwd=tmp_path,
        capture_output=True,
        text=True,
        env={"PATH": os.environ["PATH"], "NO_COLOR": "1"},
    )
    assert result.returncode == 2
    assert result.stdout == ""
    assert "usage:" in result.stderr
```
</cli_testing>

<api_testing>
Test an HTTP API through real requests, with the framework's test client or against a local server. Reuse the client the project already has, such as Supertest, the Django or FastAPI test client, or Laravel HTTP tests.

For each endpoint, assert the status code, the body shape, and the key values. Assert the headers that matter too, such as `Content-Type` and `Location`. Cover the success case and each error the endpoint can return. These include 400 or 422 for bad input, 401, 403, 404, and 409.

Check that each protected endpoint rejects a missing token. Also check that it rejects a valid token for another user's object. Broken object-level authorization ranks first in the [OWASP API Security Top 10](https://api-security.owasp.org/editions/2023/en/0x11-t10). Check a write through a later read, not through the database.

This Supertest suite checks the success case, a validation error, and a missing token.

```typescript
import request from 'supertest';
import { app } from '../src/app';

describe('POST /api/tasks', () => {
  it('creates a task and returns 201', async () => {
    const response = await request(app)
      .post('/api/tasks')
      .send({ title: 'Test Task' })
      .set('Authorization', `Bearer ${testToken}`)
      .expect(201);

    expect(response.body).toMatchObject({
      id: expect.any(String),
      title: 'Test Task',
      status: 'pending',
    });
  });

  it('returns 422 for invalid input', async () => {
    const response = await request(app)
      .post('/api/tasks')
      .send({ title: '' })
      .set('Authorization', `Bearer ${testToken}`)
      .expect(422);

    expect(response.body.error.code).toBe('VALIDATION_ERROR');
  });

  it('returns 401 without authentication', async () => {
    await request(app)
      .post('/api/tasks')
      .send({ title: 'Test' })
      .expect(401);
  });
});
```
</api_testing>

<contract_testing>
A contract test checks that the API and its consumers agree on the shape of requests and responses. When the project keeps a schema, such as OpenAPI, JSON Schema, GraphQL SDL, or protobuf, validate test responses against it. Then the code and the published contract cannot drift apart unnoticed.

When the API changes, compare the new schema with the one on the main branch. Tools such as `oasdiff breaking` for OpenAPI and `buf breaking` for protobuf report breaking changes. A removed field, a new required field, a narrower type, or a changed status code breaks existing clients. Another team's service may consume the API. Then consumer-driven contracts such as Pact run the consumer's expectations against the provider in CI. Use the contract tooling the project already has.

Mock an external API at the boundary with recorded, realistic responses. Each mock mirrors the complete real structure, as [good-tests.md](good-tests.md) explains.
</contract_testing>
