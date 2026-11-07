<event_loop>
Never run CPU-intensive work synchronously, because it blocks the event loop for every request. This function blocks while it hashes.

```typescript
function hashPasswordSync(password: string): string {
  return crypto.pbkdf2Sync(password, salt, 100000, 64, 'sha512').toString('hex');
}
```

The async API runs the work on the libuv thread pool instead.

```typescript
function hashPassword(password: string): Promise<string> {
  return new Promise((resolve, reject) => {
    crypto.pbkdf2(password, salt, 100000, 64, 'sha512', (err, key) => {
      if (err) reject(err);
      else resolve(key.toString('hex'));
    });
  });
}
```
</event_loop>

<worker_threads>
Use [piscina](https://github.com/piscinajs/piscina) for CPU-intensive tasks. It manages the worker pool, the task queue, and load balancing. The worker module exports the function that does the work.

```typescript
export default function heavyComputation(data: { input: string }): string {
  return compute(data.input);
}
```

The main module creates the pool and runs tasks on it.

```typescript
import Piscina from 'piscina';

const piscina = new Piscina({
  filename: new URL('./worker.ts', import.meta.url).href,
});

const result = await piscina.run({ input: 'data' });
```
</worker_threads>

<connection_pooling>
Use a connection pool for databases. This helper takes a client from the pool and always releases it.

```typescript
import { Pool } from 'pg';

const pool = new Pool({
  max: 20,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 2000,
});

async function query<T>(sql: string, params: unknown[]): Promise<T[]> {
  const client = await pool.connect();
  try {
    const result = await client.query(sql, params);
    return result.rows;
  } finally {
    client.release();
  }
}
```
</connection_pooling>

<memory_leaks>
An unbounded cache is a common memory leak. This `Map` grows forever.

```typescript
const cache = new Map();
function addToCache(key: string, value: unknown) {
  cache.set(key, value);
}
```

An LRU cache with a maximum size bounds the memory.

```typescript
import { LRUCache } from 'lru-cache';

const cache = new LRUCache<string, unknown>({
  max: 500,
  ttl: 1000 * 60 * 5,
});
```

A listener that is never removed also leaks. This function adds a listener and gives no way to remove it.

```typescript
function subscribe(emitter: EventEmitter) {
  emitter.on('event', handler);
}
```

Return a cleanup function instead, and call it when the subscriber goes away.

```typescript
function subscribe(emitter: EventEmitter): () => void {
  emitter.on('event', handler);
  return () => emitter.off('event', handler);
}
```
</memory_leaks>

<lazy_loading>
Load heavy modules only when needed, so startup stays fast. This function imports the module on first use and reuses it.

```typescript
let heavyModule: HeavyModule | null = null;

async function getHeavyModule(): Promise<HeavyModule> {
  if (!heavyModule) {
    const { HeavyModule } = await import('./heavy-module.js');
    heavyModule = new HeavyModule();
  }
  return heavyModule;
}
```
</lazy_loading>

<related>
[caching.md](caching.md) covers caching patterns and libraries. [profiling.md](profiling.md) covers profiling and benchmarks.
</related>
