<contents>
This file has these sections, in order.
- validation
- avoid node env
</contents>

<validation>
Validate environment variables once at startup, because they are a system boundary. Use the validation library the project already has.

[env-schema](https://github.com/fastify/env-schema) with [TypeBox](https://github.com/sinclairzx81/typebox) gives type-safe validation. TypeBox 1.x ships as the unscoped `typebox` package. The 0.x line used `@sinclair/typebox`.

```typescript
import { envSchema } from 'env-schema';
import { Static, Type } from 'typebox';

const schema = Type.Object({
  PORT: Type.Number({ default: 3000 }),
  DATABASE_URL: Type.String(),
  API_KEY: Type.String({ minLength: 1 }),
  LOG_LEVEL: Type.Union([
    Type.Literal('debug'),
    Type.Literal('info'),
    Type.Literal('warn'),
    Type.Literal('error'),
  ], { default: 'info' }),
});

type Env = Static<typeof schema>;

export const env = envSchema<Env>({ schema });
```

[Zod](https://zod.dev) 4 does the same job. It uses top-level format schemas such as `z.url()` and reports errors through `z.treeifyError()`.

```typescript
import * as z from 'zod';

const EnvSchema = z.object({
  PORT: z.coerce.number().default(3000),
  DATABASE_URL: z.url(),
  API_KEY: z.string().min(1),
  LOG_LEVEL: z.enum(['debug', 'info', 'warn', 'error']).default('info'),
});

type Env = z.infer<typeof EnvSchema>;

function loadEnv(): Env {
  const result = EnvSchema.safeParse(process.env);

  if (!result.success) {
    console.error('Invalid environment variables:');
    console.error(z.treeifyError(result.error));
    process.exit(1);
  }

  return result.data;
}

export const env = loadEnv();
```
</validation>

<avoid_node_env>
`NODE_ENV` is an antipattern, because one variable mixes several separate concerns. It mixes environment detection, behavior toggles such as verbose logging, optimization flags, and security settings. In this code, one check changes logging, security, and infrastructure at once.

```typescript
if (process.env.NODE_ENV === 'development') {
  enableDebugLogging();
  disableRateLimiting();
  useMockDatabase();
}
```

Use one explicit variable for each concern instead. This config reads a separate variable for each setting.

```typescript
const config = {
  logging: {
    level: process.env.LOG_LEVEL || 'info',
    pretty: process.env.LOG_PRETTY === 'true',
  },
  security: {
    rateLimitEnabled: process.env.RATE_LIMIT_ENABLED !== 'false',
    httpsOnly: process.env.HTTPS_ONLY === 'true',
  },
  database: {
    url: process.env.DATABASE_URL,
  },
};
```

Explicit variables make configuration discoverable and give fine-grained control per environment. They also avoid hidden behavior changes and make each setting easy to test. Libraries and frameworks may still read `NODE_ENV`, so keep it where a dependency needs it.
</avoid_node_env>

