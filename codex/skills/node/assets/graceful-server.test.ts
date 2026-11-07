import { describe, it, before, after } from 'node:test';
import assert from 'node:assert/strict';
import { createServer, Server } from 'node:http';
import { createHandler, closeServer } from './graceful-server.ts';

describe('graceful server shutdown', () => {
  let server: Server;
  let isShuttingDown = false;

  before(async () => {
    server = createServer(createHandler(() => isShuttingDown));
    await new Promise<void>((resolve) => server.listen(0, resolve));
  });

  after(async () => {
    await closeServer(server);
  });

  function getPort(): number {
    const address = server.address();
    if (typeof address === 'object' && address !== null) {
      return address.port;
    }
    throw new Error('Server not listening');
  }

  it('should return healthy status when not shutting down', async () => {
    const port = getPort();
    const response = await fetch(`http://localhost:${port}/health`);

    assert.equal(response.status, 200);
    const body = await response.json();
    assert.deepEqual(body, { status: 'healthy' });
  });

  it('should return 503 and shutting_down status during shutdown', async () => {
    isShuttingDown = true;
    const port = getPort();

    const response = await fetch(`http://localhost:${port}/health`);

    assert.equal(response.status, 503);
    const body = await response.json();
    assert.deepEqual(body, { status: 'shutting_down' });

    isShuttingDown = false;
  });

  it('should set Connection: close header during shutdown', async () => {
    isShuttingDown = true;
    const port = getPort();

    const response = await fetch(`http://localhost:${port}/`);

    assert.equal(response.headers.get('connection'), 'close');

    isShuttingDown = false;
  });

  it('should not set Connection: close header when not shutting down', async () => {
    const port = getPort();

    const response = await fetch(`http://localhost:${port}/`);

    assert.notEqual(response.headers.get('connection'), 'close');
  });
});
