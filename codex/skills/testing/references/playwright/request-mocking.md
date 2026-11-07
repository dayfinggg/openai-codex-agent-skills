<overview>
`playwright-cli` can intercept, mock, change, and block network requests. Use it to test error states, empty states, and slow responses without changing the backend.
</overview>

<route_commands>
`route` takes a URL pattern and options for the status, the body, the content type, and headers. `--header` adds a header in the form `Name: Value`, and it can repeat. `--remove-header` takes a comma-separated list of request headers to strip. `unroute` removes one route, or all routes when you give no pattern.

```bash
playwright-cli route "**/*.jpg" --status=404
playwright-cli route "**/api/users" --body='[{"id":1,"name":"Alice"}]' --content-type=application/json
playwright-cli route "**/api/data" --body='{"ok":true}' --header="X-Custom: value"
playwright-cli route "**/*" --remove-header=cookie,authorization
playwright-cli route-list
playwright-cli unroute "**/*.jpg"
playwright-cli unroute
```
</route_commands>

<url_patterns>
Patterns use glob syntax.

| Pattern | Matches |
|---|---|
| `**/api/users` | That exact path |
| `**/api/*/details` | A wildcard segment in the path |
| `**/*.{png,jpg,jpeg}` | These file extensions |
| `**/search?q=*` | A query parameter |
</url_patterns>

<advanced_mocking>
Use `run-code` for conditional responses, request body checks, changed responses, or delays. This route answers based on the request body.

```bash
playwright-cli run-code "async page => {
  await page.route('**/api/login', route => {
    const body = route.request().postDataJSON();
    if (body.username === 'admin') {
      route.fulfill({ body: JSON.stringify({ token: 'mock-token' }) });
    } else {
      route.fulfill({ status: 401, body: JSON.stringify({ error: 'Invalid' }) });
    }
  });
}"
```

This route fetches the real response and changes one field.

```bash
playwright-cli run-code "async page => {
  await page.route('**/api/user', async route => {
    const response = await route.fetch();
    const json = await response.json();
    json.isPremium = true;
    await route.fulfill({ response, json });
  });
}"
```

This route simulates a network failure. Other error codes include `connectionrefused`, `timedout`, and `connectionreset`.

```bash
playwright-cli run-code "async page => {
  await page.route('**/api/offline', route => route.abort('internetdisconnected'));
}"
```

This route delays the response by 3 seconds.

```bash
playwright-cli run-code "async page => {
  await page.route('**/api/slow', async route => {
    await new Promise(r => setTimeout(r, 3000));
    route.fulfill({ body: JSON.stringify({ data: 'loaded' }) });
  });
}"
```
</advanced_mocking>
