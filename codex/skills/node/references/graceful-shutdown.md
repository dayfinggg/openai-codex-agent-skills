<contents>
This file has these sections, in order.
- close with grace
- http server
- multiple resources
- health checks
- kubernetes
- manual signal handling
</contents>

<close_with_grace>
Use [close-with-grace](https://github.com/mcollina/close-with-grace) for graceful shutdown. It handles `SIGTERM`, `SIGINT`, `uncaughtException`, and `unhandledRejection`. It also forces an exit when cleanup takes longer than `delay` milliseconds. The callback receives the signal, or the error that triggered the shutdown.

```typescript
import closeWithGrace from 'close-with-grace';

closeWithGrace({ delay: 10000 }, async ({ signal, err }) => {
  if (err) {
    console.error('Error triggered shutdown:', err);
  }
  console.log(`Received ${signal}, shutting down...`);

  await server.close();
  await db.end();
});
```
</close_with_grace>

<http_server>
A plain `node:http` server closes through a promise around `server.close()`. This server stops accepting connections and resolves once the open ones finish.

```typescript
import { createServer } from 'node:http';
import closeWithGrace from 'close-with-grace';

const server = createServer((req, res) => {
  res.writeHead(200, { 'Content-Type': 'application/json' });
  res.end(JSON.stringify({ status: 'ok' }));
});

server.listen(3000, () => {
  console.log('Server listening on port 3000');
});

closeWithGrace({ delay: 10000 }, async ({ signal, err }) => {
  if (err) {
    console.error('Shutdown error:', err);
  }
  console.log(`${signal} received, closing server...`);

  await new Promise<void>((resolve, reject) => {
    server.close((err) => (err ? reject(err) : resolve()));
  });

  console.log('Server closed');
});
```

[assets/graceful-server.ts](../assets/graceful-server.ts) is a complete example. It stops accepting connections, closes idle keep-alive connections, and force-closes the rest after five seconds. [assets/graceful-server-test.ts](../assets/graceful-server-test.ts) tests its health and `Connection` header behavior.
</http_server>


<multiple_resources>
Close resources in the reverse order of their creation. Here the HTTP server stops first, then Redis, then the database.

```typescript
import closeWithGrace from 'close-with-grace';
import { createServer } from 'node:http';

const server = createServer(handler);
const db = await connectDatabase();
const redis = await connectRedis();

server.listen(3000);

closeWithGrace({ delay: 15000 }, async ({ signal, err }) => {
  if (err) {
    console.error('Error:', err);
  }
  console.log(`${signal} received`);

  await new Promise<void>((resolve) => server.close(() => resolve()));
  console.log('HTTP server closed');

  await redis.quit();
  console.log('Redis connection closed');

  await db.end();
  console.log('Database connection closed');
});
```
</multiple_resources>

<health_checks>
Health and readiness checks report the shutdown state. During shutdown they return 503, so the load balancer stops sending traffic. In this code, the shutdown callback then waits five seconds before cleanup.

```typescript
import closeWithGrace from 'close-with-grace';

let isShuttingDown = false;

function healthHandler(req: Request, res: Response) {
  if (isShuttingDown) {
    return res.status(503).json({ status: 'shutting_down' });
  }
  return res.json({ status: 'healthy' });
}

function readinessHandler(req: Request, res: Response) {
  if (isShuttingDown) {
    return res.status(503).json({ ready: false });
  }
  return res.json({ ready: true });
}

closeWithGrace({ delay: 10000 }, async ({ signal }) => {
  isShuttingDown = true;
  console.log(`${signal} received, marked as shutting down`);

  await new Promise((r) => setTimeout(r, 5000));

  await cleanup();
});
```
</health_checks>

<kubernetes>
Kubernetes sends `SIGTERM` and then waits `terminationGracePeriodSeconds`, which defaults to 30 seconds. Set the close-with-grace delay a little lower, so the process exits cleanly before Kubernetes kills it. This callback marks the pod as not ready at once and waits for in-flight requests before it closes resources.

```typescript
import closeWithGrace from 'close-with-grace';

closeWithGrace({ delay: 25000 }, async ({ signal }) => {
  console.log(`${signal} received`);

  isShuttingDown = true;

  await new Promise((r) => setTimeout(r, 5000));

  await server.close();
  await db.end();
});
```
</kubernetes>

<manual_signal_handling>
Handle signals yourself only when close-with-grace is not available. This handler runs cleanup once and forces an exit after ten seconds.

```typescript
const signals: NodeJS.Signals[] = ['SIGTERM', 'SIGINT'];
let isShuttingDown = false;

async function shutdown(signal: string): Promise<void> {
  if (isShuttingDown) return;
  isShuttingDown = true;

  console.log(`${signal} received, shutting down...`);

  const timeout = setTimeout(() => {
    console.error('Shutdown timeout, forcing exit');
    process.exit(1);
  }, 10000);

  try {
    await cleanup();
    clearTimeout(timeout);
    process.exit(0);
  } catch (error) {
    console.error('Shutdown error:', error);
    clearTimeout(timeout);
    process.exit(1);
  }
}

for (const signal of signals) {
  process.on(signal, () => shutdown(signal));
}
```
</manual_signal_handling>
