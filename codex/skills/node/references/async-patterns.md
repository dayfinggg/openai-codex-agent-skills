<prefer_async_await>
Use async/await over raw promise chains, because the code reads top to bottom. This function processes items in order with `await`.

```typescript
async function processItems(items: Item[]): Promise<Result[]> {
  const results: Result[] = [];
  for (const item of items) {
    const result = await processItem(item);
    results.push(result);
  }
  return results;
}
```

This callback-style chain does the same work and is harder to read, so avoid it.

```typescript
function processItems(items: Item[]): Promise<Result[]> {
  return Promise.resolve([])
    .then((results) => {
      return items.reduce((chain, item) => {
        return chain.then((r) => processItem(item).then((res) => [...r, res]));
      }, Promise.resolve(results));
    });
}
```
</prefer_async_await>

<parallel_execution>
Use `Promise.all` for independent operations. This function starts every fetch at once and waits for all of them.

```typescript
async function fetchAllData(ids: string[]): Promise<Data[]> {
  const promises = ids.map((id) => fetchData(id));
  return Promise.all(promises);
}
```
</parallel_execution>

<controlled_concurrency>
Limit concurrent operations to prevent resource exhaustion and extreme memory use. [p-limit](https://github.com/sindresorhus/p-limit) and [p-map](https://github.com/sindresorhus/p-map) both do this. This code runs at most five operations at the same time with p-limit.

```typescript
import pLimit from 'p-limit';

const limit = pLimit(5);

const results = await Promise.all(
  items.map((item) => limit(() => processItem(item)))
);
```

p-map gives the same limit with a shorter call.

```typescript
import pMap from 'p-map';

const results = await pMap(items, processItem, { concurrency: 5 });
```
</controlled_concurrency>

<fault_tolerance>
Use `Promise.allSettled` when some failures are acceptable. This function maps each URL to its text or to its error.

```typescript
async function fetchMultiple(urls: string[]): Promise<Map<string, string | Error>> {
  const results = await Promise.allSettled(
    urls.map((url) => fetch(url).then((r) => r.text()))
  );

  const map = new Map<string, string | Error>();
  urls.forEach((url, i) => {
    const result = results[i];
    map.set(
      url,
      result.status === 'fulfilled' ? result.value : result.reason
    );
  });

  return map;
}
```
</fault_tolerance>

<async_construction>
Constructors cannot be async, so a constructor cannot await a connection. Use a static async factory instead. Callers then write `const db = await Database.create(config)`.

```typescript
class Database {
  private constructor(private connection: Connection) {}

  static async create(config: Config): Promise<Database> {
    const connection = await connect(config);
    return new Database(connection);
  }
}
```

Parameter properties such as `private connection` need a TypeScript transform. Under Node.js type stripping, declare the field explicitly as [typescript.md](typescript.md) shows.
</async_construction>

<cancellation>
Use `AbortController` to cancel long-running operations. This function aborts the fetch when the timeout fires and always clears the timer.

```typescript
async function fetchWithTimeout(
  url: string,
  timeoutMs: number
): Promise<Response> {
  const controller = new AbortController();
  const timeoutId = setTimeout(() => controller.abort(), timeoutMs);

  try {
    return await fetch(url, { signal: controller.signal });
  } finally {
    clearTimeout(timeoutId);
  }
}
```

For a plain timeout, `AbortSignal.timeout(ms)` gives the same result without a timer. `AbortSignal.any()` combines it with a caller's signal.
</cancellation>
