<triggers>
Use `pipeline()` with explicit async generator transforms for CSV, ETL, ingestion, and large files. The same applies to transform streams, backpressure, and line-by-line processing.
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
For ingestion tasks, combine `pipeline`, an explicit `async function*` transform, and deduplicated async lookups. In this example, concurrent lookups for the same `planId` share one request.

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

<chained_transforms>
Several async generators can follow each other in one pipeline. Here the first stage splits lines, and the second drops empty ones.

```typescript
import { pipeline } from 'node:stream/promises';

async function* parseLines(source: AsyncIterable<Buffer>): AsyncGenerator<string> {
  let buffer = '';
  for await (const chunk of source) {
    buffer += chunk.toString();
    const lines = buffer.split('\n');
    buffer = lines.pop() ?? '';
    for (const line of lines) {
      yield line;
    }
  }
  if (buffer) yield buffer;
}

async function* filterNonEmpty(source: AsyncIterable<string>): AsyncGenerator<string> {
  for await (const line of source) {
    if (line.trim()) {
      yield line + '\n';
    }
  }
}

await pipeline(
  createReadStream('input.txt'),
  parseLines,
  filterNonEmpty,
  createWriteStream('output.txt')
);
```
</chained_transforms>

<async_iteration>
Readable streams are async iterables. `readline` with `crlfDelay: Infinity` yields each line of a file and handles both line endings.

```typescript
import { createReadStream } from 'node:fs';
import { createInterface } from 'node:readline';

async function processLines(filePath: string): Promise<void> {
  const fileStream = createReadStream(filePath);
  const rl = createInterface({
    input: fileStream,
    crlfDelay: Infinity,
  });

  for await (const line of rl) {
    await processLine(line);
  }
}
```
</async_iteration>

<readable_from>
`Readable.from` turns any iterable or async iterable into a readable stream. This stream emits 100 JSON lines.

```typescript
import { Readable } from 'node:stream';

async function* generateData(): AsyncGenerator<string> {
  for (let i = 0; i < 100; i++) {
    yield JSON.stringify({ id: i, timestamp: Date.now() }) + '\n';
  }
}

const stream = Readable.from(generateData());
```
</readable_from>

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

<stream_consumers>
`node:stream/consumers` reads a whole stream as text, JSON, or a buffer. These helpers collect the stream into one value.

```typescript
import { text, json, buffer } from 'node:stream/consumers';
import { Readable } from 'node:stream';

async function readStreamAsJson<T>(stream: Readable): Promise<T> {
  return json(stream) as Promise<T>;
}

async function readStreamAsText(stream: Readable): Promise<string> {
  return text(stream);
}
```
</stream_consumers>
