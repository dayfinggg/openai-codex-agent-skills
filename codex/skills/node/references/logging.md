<pino>
Use [pino](https://github.com/pinojs/pino) for fast, structured JSON logging. Pass context as an object first and the message second.

```typescript
import pino from 'pino';

const logger = pino({
  level: process.env.LOG_LEVEL || 'info',
});

logger.info({ userId: user.id }, 'User created');
logger.error({ err, orderId: order.id }, 'Failed to process payment');
```
</pino>

<log_levels>
Each level has one purpose. `debug` carries detail for debugging, and `info` carries normal operational events. `warn` marks unexpected but handled situations, and `error` marks errors that need attention.

```typescript
logger.debug({ itemId: item.id, step: 'validation' }, 'Processing item');
logger.info({ userId: user.id }, 'User created');
logger.warn({ currentRate: 95, limit: 100 }, 'Rate limit approaching');
logger.error({ err, orderId: order.id }, 'Failed to process payment');
```
</log_levels>

<transports>
Pino transports process logs outside the main thread. They format, filter, and send logs to external services.

[pino-pretty](https://github.com/pinojs/pino-pretty) gives human-readable output during development. Pipe the output through it.

```bash
node app.ts | pino-pretty
```

The same transport also works from code.

```typescript
import pino from 'pino';

const logger = pino({
  transport: {
    target: 'pino-pretty',
    options: {
      colorize: true,
    },
  },
});
```

Several targets send logs to several destinations. This logger prints info and above and writes errors to a file.

```typescript
import pino from 'pino';

const logger = pino({
  transport: {
    targets: [
      {
        target: 'pino-pretty',
        options: { colorize: true },
        level: 'info',
      },
      {
        target: 'pino/file',
        options: { destination: '/var/log/app.log' },
        level: 'error',
      },
    ],
  },
});
```

Transports exist for most log backends. Examples are [pino-elasticsearch](https://github.com/pinojs/pino-elasticsearch), [pino-loki](https://github.com/Julien-R44/pino-loki), and [pino-datadog](https://github.com/ovhemert/pino-datadog).
</transports>

<child_loggers>
Child loggers bind context to every line they write. This child adds the request and user IDs.

```typescript
const requestLogger = logger.child({
  requestId: req.id,
  userId: req.user?.id,
});

requestLogger.info('Processing request');
requestLogger.info({ itemId }, 'Item processed');
```
</child_loggers>


<redaction>
Pino redaction replaces sensitive fields with `[Redacted]`. With this config, the call below logs `{"password":"[Redacted]","msg":"User login"}`.

```typescript
const logger = pino({
  redact: ['password', 'token', 'apiKey', 'req.headers.authorization'],
});

logger.info({ password: 'secret123' }, 'User login');
```
</redaction>

<debug_module>
The [debug](https://github.com/debug-js/debug) module lets library authors emit tracing output. It is not meant for application logs, which belong to pino.

```typescript
import createDebug from 'debug';

const debug = createDebug('mymodule:connection');

debug('Connecting to %s:%d', host, port);
debug('Query executed in %dms', duration);
```

The `DEBUG` environment variable turns its output on.

```bash
DEBUG=mymodule:* node app.ts
```
</debug_module>

<util_debuglog>
`util.debuglog` traces a module without an external dependency. The `NODE_DEBUG` environment variable turns it on.

```typescript
import { debuglog } from 'node:util';

const debug = debuglog('mymodule');

debug('Starting operation %s', operationId);
debug('Connection established to %s', host);
```

```bash
NODE_DEBUG=mymodule node app.ts
NODE_DEBUG=mymodule,http,net node app.ts
```

`NODE_DEBUG` also traces Node.js internals, as in `NODE_DEBUG=http,net,tls`.
</util_debuglog>

<sensitive_data>
Never log credentials, tokens, or personal data. This call logs a password.

```typescript
logger.info({ email, password }, 'User login');
```

Log only safe identifiers instead.

```typescript
logger.info({ email }, 'User login');
```
</sensitive_data>
