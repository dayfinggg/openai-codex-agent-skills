<contents>
This file has these sections, in order.
- env files
- validation
- avoid node env
- config object
- env file layout
- production secrets
</contents>

<env_files>
Node.js loads environment files with the built-in `--env-file` flag. The flag is stable since Node.js 24.10 and 22.21. With several files, later files override earlier ones.

```bash
node --env-file=.env app.ts
node --env-file=.env --env-file=.env.local app.ts
```

`--env-file-if-exists` does the same but does not fail when the file is missing. `process.loadEnvFile()` loads a file from code. Without an argument it reads `.env` in the current directory.

```typescript
import { loadEnvFile } from 'node:process';

loadEnvFile();
loadEnvFile('.env.local');
```
</env_files>

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

<config_object>
A typed configuration object puts every setting in one place. `requireEnv` fails at startup when a required variable is missing.

```typescript
interface Config {
  server: {
    port: number;
    host: string;
  };
  database: {
    url: string;
    poolSize: number;
  };
  auth: {
    jwtSecret: string;
    jwtExpiresIn: string;
  };
}

function createConfig(): Config {
  return {
    server: {
      port: parseInt(process.env.PORT || '3000', 10),
      host: process.env.HOST || '0.0.0.0',
    },
    database: {
      url: requireEnv('DATABASE_URL'),
      poolSize: parseInt(process.env.DB_POOL_SIZE || '10', 10),
    },
    auth: {
      jwtSecret: requireEnv('JWT_SECRET'),
      jwtExpiresIn: process.env.JWT_EXPIRES_IN || '1h',
    },
  };
}

function requireEnv(name: string): string {
  const value = process.env[name];
  if (!value) {
    throw new Error(`Missing required environment variable: ${name}`);
  }
  return value;
}

export const config = createConfig();
```
</config_object>

<env_file_layout>
Keep three kinds of env files. `.env.example` is committed to git and documents every variable with placeholder values.

```bash
PORT=3000
DATABASE_URL=postgresql://user:pass@localhost:5432/db
API_KEY=your-api-key-here
```

`.env` holds local development values and is never committed.

```bash
PORT=3000
DATABASE_URL=postgresql://dev:dev@localhost:5432/myapp
API_KEY=sk-dev-key-123
```

`.env.test` holds values for the test environment.

```bash
DATABASE_URL=postgresql://test:test@localhost:5432/myapp_test
```
</env_file_layout>

<production_secrets>
Never commit secrets to version control. In production, use the secrets service of the platform the project runs on. Examples are AWS Secrets Manager, Google Cloud Secret Manager, Azure Key Vault, HashiCorp Vault, Kubernetes Secrets, and CI secret stores. These services inject secrets as environment variables at runtime, so secrets stay out of the code and its history.
</production_secrets>
