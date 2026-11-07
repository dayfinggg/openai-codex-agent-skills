<custom_errors>
Use [@fastify/error](https://github.com/fastify/fastify-error) to create custom errors with codes. Each factory takes a code, a message format, and a status code.

```typescript
import createError from '@fastify/error';

const NotFoundError = createError('NOT_FOUND', '%s not found', 404);
const ValidationError = createError('VALIDATION_ERROR', '%s', 400);
const DatabaseError = createError('DATABASE_ERROR', 'Database operation failed: %s', 500);

throw new NotFoundError('User');
throw new ValidationError('Email is required');
```

Without a dependency, a small factory gives the same result. It sets `code` and `statusCode` and keeps the `cause`.

```typescript
interface AppErrorOptions {
  code: string;
  statusCode?: number;
  cause?: Error;
}

function createAppError(message: string, options: AppErrorOptions): Error {
  const error = new Error(message, { cause: options.cause });
  (error as any).code = options.code;
  (error as any).statusCode = options.statusCode ?? 500;
  Error.captureStackTrace(error, createAppError);
  return error;
}

function notFound(resource: string): Error {
  return createAppError(`${resource} not found`, { code: 'NOT_FOUND', statusCode: 404 });
}

function validationError(message: string): Error {
  return createAppError(message, { code: 'VALIDATION_ERROR', statusCode: 400 });
}

function databaseError(message: string, cause?: Error): Error {
  return createAppError(message, { code: 'DATABASE_ERROR', statusCode: 500, cause });
}

throw notFound('User');
throw validationError('Email is required');
```
</custom_errors>

<checking_error_codes>
Check errors by code, not by class. A code survives duplicate package copies and serialization, and a class check does not.

```typescript
function isAppError(error: unknown): error is Error & { code: string; statusCode: number } {
  return error instanceof Error && 'code' in error && 'statusCode' in error;
}

try {
  await fetchUser(id);
} catch (error) {
  if (isAppError(error) && error.code === 'NOT_FOUND') {
    return null;
  }
  throw error;
}
```
</checking_error_codes>

<async_errors>
Use try/catch with async/await and propagate errors. This function rethrows known errors and wraps unknown ones with their cause.

```typescript
async function fetchUser(id: string): Promise<User> {
  try {
    const user = await db.users.findById(id);
    if (!user) {
      throw notFound('User');
    }
    return user;
  } catch (error) {
    if (isAppError(error)) {
      throw error;
    }
    throw databaseError('Failed to fetch user', error as Error);
  }
}
```
</async_errors>

<process_level_errors>
Do not write your own `unhandledRejection` and `uncaughtException` handlers. [close-with-grace](https://github.com/fastify/close-with-grace) handles both and starts a graceful shutdown. [graceful-shutdown.md](graceful-shutdown.md) shows the setup.
</process_level_errors>


<never_swallow>
Never leave a catch block empty, because it hides the error. This block swallows the failure.

```typescript
try {
  await riskyOperation();
} catch (error) {
}
```

Handle the error or rethrow it. This block logs the failure and rethrows it.

```typescript
try {
  await riskyOperation();
} catch (error) {
  logger.error({ err: error }, 'Operation failed');
  throw error;
}
```
</never_swallow>

<cause_chain>
Use the `cause` option to keep the chain of errors. The new error then carries the original one.

```typescript
try {
  await externalService.call();
} catch (error) {
  throw new Error('Service call failed', { cause: error });
}
```
</cause_chain>
