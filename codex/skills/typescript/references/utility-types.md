<overview>
TypeScript ships utility types that transform types in common ways. Prefer them over a hand-written mapped or conditional type with the same effect.
</overview>

<parameters>
`Parameters<T>` returns the parameter types of a function type as a tuple. Here `FetchUserParams` is `[id: string, opts?: { timeout?: number } | undefined]`. A wrapper can reuse that tuple for its rest parameter.

```typescript
declare function fetchUser(id: string, opts?: { timeout?: number }): Promise<User>;

type FetchUserParams = Parameters<typeof fetchUser>;

const fetchUserWithLogging = async (
  ...args: Parameters<typeof fetchUser>
): Promise<User> => {
  console.log("Fetching user:", args[0]);
  return fetchUser(...args);
};
```
</parameters>

<return_type>
`ReturnType<T>` returns the return type of a function type. Here `User` is `{ id: string; name: string; email: string; createdAt: Date }`.

```typescript
function createUser(name: string, email: string) {
  return {
    id: crypto.randomUUID(),
    name,
    email,
    createdAt: new Date(),
  };
}

type User = ReturnType<typeof createUser>;
```
</return_type>

<awaited>
`Awaited<T>` unwraps the type inside a promise, also through nested promises. Here `Unwrapped1` is `string`, `Unwrapped2` is `number`, and `FetchUserResult` is `User` instead of `Promise<User>`.

```typescript
type PromiseString = Promise<string>;
type NestedPromise = Promise<Promise<number>>;

type Unwrapped1 = Awaited<PromiseString>;
type Unwrapped2 = Awaited<NestedPromise>;

declare function fetchUser(id: string): Promise<User>;

type FetchUserResult = Awaited<ReturnType<typeof fetchUser>>;
```
</awaited>

<wrap_library_functions>
A library function often has types that the library does not export. `Parameters`, `ReturnType`, and `Awaited` recover them, so a wrapper can extend the result.

```typescript
import { fetchUser } from "external-lib";

type FetchUserReturn = Awaited<ReturnType<typeof fetchUser>>;

export const fetchUserWithFullName = async (
  ...args: Parameters<typeof fetchUser>
): Promise<FetchUserReturn & { fullName: string }> => {
  const user = await fetchUser(...args);
  return {
    ...user,
    fullName: `${user.firstName} ${user.lastName}`,
  };
};
```
</wrap_library_functions>

<record>
`Record<Keys, Type>` creates an object type with the given keys and one value type. With a union of keys, the object must have every key.

```typescript
type Role = "admin" | "user" | "guest";
type Permissions = Record<Role, string[]>;

const rolePermissions: Permissions = {
  admin: ["read", "write", "delete"],
  user: ["read", "write"],
  guest: ["read"],
};

function createLookup<K extends string, V>(
  keys: K[],
  getValue: (key: K) => V
): Record<K, V> {
  const result = {} as Record<K, V>;
  for (const key of keys) {
    result[key] = getValue(key);
  }
  return result;
}
```
</record>

<partial_and_required>
`Partial<T>` makes every property optional, which fits update and patch inputs. Here `UpdateUserInput` is `{ id?: string; name?: string; email?: string }`, so a call may pass only `name`.

```typescript
interface User {
  id: string;
  name: string;
  email: string;
}

type UpdateUserInput = Partial<User>;

declare function updateUser(id: string, updates: Partial<User>): User;

updateUser("123", { name: "New Name" });
```

`Required<T>` does the opposite and makes every property required. Here `RequiredConfig` is `{ host: string; port: number; debug: boolean }`.

```typescript
interface Config {
  host?: string;
  port?: number;
  debug?: boolean;
}

type RequiredConfig = Required<Config>;
```
</partial_and_required>

<omit_and_pick>
`Omit<T, Keys>` removes properties, and `Pick<T, Keys>` keeps only the named ones. Here `PublicUser` drops `password`, and `CreateUserInput` drops `id`. `UserCredentials` keeps only `email` and `password`.

```typescript
interface User {
  id: string;
  name: string;
  email: string;
  password: string;
}

type PublicUser = Omit<User, "password">;

type CreateUserInput = Omit<User, "id">;

type UserCredentials = Pick<User, "email" | "password">;
```
</omit_and_pick>

<union_filters>
`Extract<T, U>` keeps the union members that match `U`, and `Exclude<T, U>` removes them. `NonNullable<T>` removes `null` and `undefined`. Here `PrimaryColors` is `"red" | "blue"`, `NonPrimaryColors` is `"green" | "yellow"`, and `DefiniteString` is `string`.

```typescript
type AllColors = "red" | "green" | "blue" | "yellow";

type PrimaryColors = Extract<AllColors, "red" | "blue">;

type NonPrimaryColors = Exclude<AllColors, "red" | "blue">;

type MaybeString = string | null | undefined;
type DefiniteString = NonNullable<MaybeString>;
```
</union_filters>

<reusable_wrapper>
Utility types combine into reusable helpers. This `WrapFunction` type describes an async wrapper that adds fields to the result of any function.

```typescript
type WrapFunction<
  TFunc extends (...args: any) => any,
  TAdditional = {}
> = (
  ...args: Parameters<TFunc>
) => Promise<Awaited<ReturnType<TFunc>> & TAdditional>;

import { fetchUser } from "external-lib";

const fetchUserWithMeta: WrapFunction<
  typeof fetchUser,
  { meta: { fetchedAt: Date } }
> = async (...args) => {
  const user = await fetchUser(...args);
  return {
    ...user,
    meta: { fetchedAt: new Date() },
  };
};
```
</reusable_wrapper>

<which_utility>
Each utility type has a typical use.

| Utility | Typical use |
|---|---|
| `Parameters<T>` | Wrapping a function or creating a variant of it |
| `ReturnType<T>` | Getting a return type that the code does not export |
| `Awaited<T>` | Unwrapping a promise type |
| `Record<K, V>` | Object types with a set of keys |
| `Partial<T>` | Update and patch inputs |
| `Required<T>` | Making sure every config option is set |
| `Omit<T, K>` | Removing sensitive or internal fields |
| `Pick<T, K>` | Focused subsets of a type |
| `Exclude<T, U>` | Filtering a union |
| `Extract<T, U>` | Selecting from a union |
| `NonNullable<T>` | Removing `null` and `undefined` after validation |
</which_utility>

<pitfalls>
`ReturnType` on an async function returns the promise type. Here `Wrong` is `Promise<string[]>`, and `Right` unwraps it to `string[]`.

```typescript
async function getData(): Promise<string[]> {
  return ["data"];
}

type Wrong = ReturnType<typeof getData>;

type Right = Awaited<ReturnType<typeof getData>>;
```

A function name is a value, so a utility type needs `typeof` in front of it. The first line fails to compile, and the second gives `[x: number]`.

```typescript
function myFunc(x: number): string {
  return String(x);
}

type Params = Parameters<myFunc>;

type Params = Parameters<typeof myFunc>;
```
</pitfalls>
