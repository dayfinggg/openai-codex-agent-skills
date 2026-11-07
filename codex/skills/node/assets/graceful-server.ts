import { createServer, IncomingMessage, ServerResponse, Server } from 'node:http';
export function createHandler(isShuttingDown: () => boolean) {
  return (req: IncomingMessage, res: ServerResponse) => {
    if (isShuttingDown()) {
      res.setHeader('Connection', 'close');
    }

    if (req.url === '/health') {
      if (isShuttingDown()) {
        res.writeHead(503, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ status: 'shutting_down' }));
        return;
      }
      res.writeHead(200, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify({ status: 'healthy' }));
      return;
    }

    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({ message: 'Hello, World!' }));
  };
}

export function closeServer(server: Server): Promise<void> {
  return new Promise((resolve, reject) => {
    const timeout = setTimeout(() => server.closeAllConnections(), 5000);
    timeout.unref();
    server.close((err) => {
      clearTimeout(timeout);
      if (err && (err as NodeJS.ErrnoException).code !== 'ERR_SERVER_NOT_RUNNING') {
        reject(err);
        return;
      }
      resolve();
    });
    server.closeIdleConnections();

  });
}

export async function main(): Promise<void> {
  const { default: closeWithGrace } = await import('close-with-grace');
  let isShuttingDown = false;
  const server = createServer(createHandler(() => isShuttingDown));

  server.listen(3000, '0.0.0.0', () => {
    console.log('Server listening on http://0.0.0.0:3000');
  });

  closeWithGrace({ delay: 10000 }, async ({ signal, err }) => {
    if (err) {
      console.error('Error triggered shutdown:', err);
    }

    console.log(`${signal} received, starting graceful shutdown...`);
    isShuttingDown = true;

    await closeServer(server);
    console.log('Server closed successfully');
  });
}

const isMain = process.argv[1]?.endsWith('graceful-server.ts') ?? false;
if (isMain) {
  main().catch((err) => {
    console.error(err);
    process.exitCode = 1;
  });
}
