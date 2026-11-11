<contents>
This file has these sections, in order.
- pino
- transports
- redaction
</contents>

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

<redaction>
Pino redaction replaces sensitive fields with `[Redacted]`. With this config, the line that the call below logs carries `"password":"[Redacted]"`. Keep credentials, tokens, and personal data out of log calls in the first place.

```typescript
const logger = pino({
  redact: ['password', 'token', 'apiKey', 'req.headers.authorization'],
});

logger.info({ password: 'secret123' }, 'User login');
```
</redaction>

