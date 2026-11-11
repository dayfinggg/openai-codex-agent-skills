<contents>
This file has these sections, in order.
- triggers
- pipeline
- csv etl pattern
- backpressure
</contents>

<triggers>
Use `pipeline()` for CSV, ETL, ingestion, large files, and line-by-line processing, so memory stays bounded. Reuse the stream stages and the parser the project already has, and write an `async function*` transform when they cannot express the step simply.
</triggers>

<pipeline>
Use `pipeline` from `node:stream/promises` instead of `.pipe()`. `pipeline` forwards errors from every stage and destroys all streams on failure, and `.pipe()` does neither. This function gzips a file.

```typescript
import { pipeline } from 'node:stream/promises';
import { createReadStream, createWriteStream } from 'node:fs';
import { createGzip } from 'node:zlib';

async function compressFile(input: string, output: string): Promise<void> {
  await pipeline(
    createReadStream(input),
    createGzip(),
    createWriteStream(output)
  );
}
```

An async generator can be a transform stage. This one upper-cases each chunk.

```typescript
import { pipeline } from 'node:stream/promises';
import { createReadStream, createWriteStream } from 'node:fs';

async function* toUpperCase(source: AsyncIterable<Buffer>): AsyncGenerator<string> {
  for await (const chunk of source) {
    yield chunk.toString().toUpperCase();
  }
}

async function processFile(input: string, output: string): Promise<void> {
  await pipeline(
    createReadStream(input),
    toUpperCase,
    createWriteStream(output)
  );
}
```
</pipeline>

<csv_etl_pattern>
When an ingestion task needs a remote lookup for each row, combine `pipeline`, an `async function*` transform, and deduplicated async lookups. In this example, concurrent lookups for the same `planId` share one request.

```typescript
import { pipeline } from 'node:stream/promises';
import { createReadStream, createWriteStream } from 'node:fs';
import { createCache } from 'async-cache-dedupe';

const cache = createCache({
  ttl: 60,
  stale: 5,
  storage: { type: 'memory' },
});

cache.define('lookupPlan', async (planId: string) => {
  return await fetch(`https://billing.internal/plans/${planId}`).then(async (res) => await res.json());
});

async function* enrichCsvRows(source: AsyncIterable<Buffer>): AsyncGenerator<string> {
  let tail = '';

  for await (const chunk of source) {
    tail += chunk.toString('utf8');
    const lines = tail.split('\n');
    tail = lines.pop() ?? '';

    for (const line of lines) {
      if (line.trim().length === 0) continue;
      const [userId, planId] = line.split(',');
      const plan = await cache.lookupPlan(planId);
      yield `${userId},${planId},${plan.tier}\n`;
    }
  }

  if (tail.trim().length > 0) {
    const [userId, planId] = tail.split(',');
    const plan = await cache.lookupPlan(planId);
    yield `${userId},${planId},${plan.tier}\n`;
  }
}

await pipeline(
  createReadStream('users.csv'),
  enrichCsvRows,
  createWriteStream('users-enriched.csv')
);
```

This simple split does not handle quoted CSV fields that contain commas or newlines. Use the CSV parser the project already has for real CSV input. [caching.md](caching.md) explains the cache choice.
</csv_etl_pattern>

<backpressure>
`pipeline()` handles backpressure for you. When you call `write()` yourself, respect its return value. This function waits for `drain` whenever the buffer is full.

```typescript
import { Writable } from 'node:stream';
import { once } from 'node:events';

async function writeData(
  writable: Writable,
  data: string[]
): Promise<void> {
  for (const chunk of data) {
    const canContinue = writable.write(chunk);
    if (!canContinue) {
      await once(writable, 'drain');
    }
  }
}
```
</backpressure>

