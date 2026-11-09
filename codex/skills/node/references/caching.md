<contents>
This file has these sections, in order.
- triggers
- cache selection
- sync memoization
- async cache dedupe
- lru cache
- invalidation
- when to cache
</contents>

<triggers>
Choose a cache strategy and state the reason when the task has repeated async lookups. Other signals are duplicate concurrent requests, CSV enrichment, ETL transforms, N+1 remote calls, and hot keys.
</triggers>

<cache_selection>
Three choices cover most cases.

- Use `lru-cache` for process-local, bounded in-memory reuse when deduplicating concurrent requests is not the main concern.
- Use `async-cache-dedupe` when concurrent calls can request the same key and you want one in-flight request per key.
- In stream or ETL code, prefer `async-cache-dedupe` for enrichment calls inside an `async function*` transform.
</cache_selection>

<sync_memoization>
Use [mnemonist](https://github.com/Yomguithereal/mnemonist) for synchronous memoization. This function returns a cached user or loads and stores it.

```typescript
import { LRUCache } from 'mnemonist';

const cache = new LRUCache<string, User>(1000);

function getUser(id: string): User | undefined {
  if (cache.has(id)) {
    return cache.get(id);
  }
  const user = fetchUserSync(id);
  cache.set(id, user);
  return user;
}
```
</sync_memoization>

<async_cache_dedupe>
Use [async-cache-dedupe](https://github.com/mcollina/async-cache-dedupe) for async operations with request deduplication. In this setup, `ttl` is the fresh time in seconds. `stale` is the extra time in which the cache serves a stale value while it revalidates.

```typescript
import { createCache } from 'async-cache-dedupe';

const cache = createCache({
  ttl: 60,
  stale: 5,
  storage: { type: 'memory' },
});

cache.define('getUser', async (id: string) => {
  return await db.users.findById(id);
});

cache.define('getPost', {
  ttl: 300,
  stale: 30,
}, async (id: string) => {
  return await db.posts.findById(id);
});

const user = await cache.getUser('123');
const post = await cache.getPost('456');
```

The library deduplicates concurrent requests automatically. These three concurrent calls cause only one database query.

```typescript
const [user1, user2, user3] = await Promise.all([
  cache.getUser('123'),
  cache.getUser('123'),
  cache.getUser('123'),
]);
```

Use the deduplicated cache inside an `async function*` transform when rows often reference the same key. Each `planId` then has at most one in-flight call.

```typescript
import { createCache } from 'async-cache-dedupe';

const cache = createCache({ ttl: 120, stale: 10, storage: { type: 'memory' } });

cache.define('getPlan', async (planId: string) => {
  return await db.plans.findById(planId);
});

async function* enrichRows(source: AsyncIterable<{ userId: string, planId: string }>) {
  for await (const row of source) {
    const plan = await cache.getPlan(row.planId);
    yield { ...row, planName: plan.name };
  }
}
```

Redis storage shares the cache across several instances.

```typescript
import { createCache } from 'async-cache-dedupe';
import Redis from 'ioredis';

const redis = new Redis();

const cache = createCache({
  ttl: 60,
  storage: {
    type: 'redis',
    options: { client: redis },
  },
});
```
</async_cache_dedupe>

<lru_cache>
Use [lru-cache](https://github.com/isaacs/node-lru-cache) for bounded in-memory caching. This cache holds at most 500 items for five minutes each.

```typescript
import { LRUCache } from 'lru-cache';

const cache = new LRUCache<string, User>({
  max: 500,
  ttl: 1000 * 60 * 5,
  updateAgeOnGet: true,
});

cache.set('user:123', user);
const cached = cache.get('user:123');
```
</lru_cache>

<invalidation>
Time-based expiration needs only `ttl` and `stale`. This cache keeps entries fresh for 60 seconds and serves them stale for 30 more seconds while it revalidates.

```typescript
const cache = createCache({
  ttl: 60,
  stale: 30,
});
```

Manual invalidation works per entry, per function, or for the whole cache. The three calls below do each in that order.

```typescript
await cache.invalidate('getUser', '123');

await cache.clear('getUser');

await cache.clear();
```

Reference-based invalidation tags entries with references and then clears every entry that carries a reference. Here `invalidateAll` clears both cached functions for user 123.

```typescript
const cache = createCache({
  ttl: 60,
  storage: { type: 'memory' },
});

cache.define('getUser', {
  references: (args, key, result) => [`user:${result.id}`],
}, async (id: string) => {
  return await db.users.findById(id);
});

cache.define('getUserPosts', {
  references: (args, key, result) => [`user:${args[0]}`],
}, async (userId: string) => {
  return await db.posts.findByUserId(userId);
});

await cache.invalidateAll(`user:123`);
```
</invalidation>

<when_to_cache>
Cache these kinds of data.

- Database query results
- External API responses
- Computed values that are expensive to calculate
- Configuration that rarely changes

Do not cache these kinds of data.

- User-specific sensitive data without proper isolation
- Rapidly changing data
- Data that must always be consistent
- Large objects that would exhaust memory
</when_to_cache>
