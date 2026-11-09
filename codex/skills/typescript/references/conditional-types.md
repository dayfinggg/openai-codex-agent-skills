<overview>
Conditional types express if and else logic at the type level. They use `extends` to test whether one type is assignable to another and return a type for each case.
</overview>
<contents>
This file has these sections, in order.
- syntax
- null check
- chained conditions
- distribution
- optional features
- filtering
- recursive conditions
- tuple checks
- common patterns
- when to use
- pitfalls
</contents>


<syntax>
The condition checks whether `SomeType` is assignable to `OtherType`.

```typescript
type Conditional = SomeType extends OtherType ? TrueType : FalseType;
```

In these examples, `Test1` and `Test3` are `true`, because a string literal extends `string`. `Test2` is `false`. `Result1` and `Result3` are `"yes"`, and `Result2` is `"no"`.

```typescript
type IsString<T> = T extends string ? true : false;

type Test1 = IsString<string>;
type Test2 = IsString<number>;
type Test3 = IsString<"hello">;

type Result1 = string extends string ? "yes" : "no";
type Result2 = string extends number ? "yes" : "no";
type Result3 = "hello" extends string ? "yes" : "no";
```
</syntax>

<null_check>
Putting the known type on the left tests whether a type includes it. Here `Test1` is `true` and `Test2` is `false`. `Test3` is `false` too, because `null` and `undefined` are different types.

```typescript
type IsNullable<T> = null extends T ? true : false;

type Test1 = IsNullable<string | null>;
type Test2 = IsNullable<string>;
type Test3 = IsNullable<undefined>;
```
</null_check>

<chained_conditions>
Conditions chain like nested ternaries. Here `T1` is `"string"`, `T2` is `"number"`, `T3` is `"function"`, and `T4` is `"object"`.

```typescript
type TypeName<T> = T extends string
  ? "string"
  : T extends number
  ? "number"
  : T extends boolean
  ? "boolean"
  : T extends undefined
  ? "undefined"
  : T extends Function
  ? "function"
  : "object";

type T1 = TypeName<string>;
type T2 = TypeName<number>;
type T3 = TypeName<() => void>;
type T4 = TypeName<{ a: 1 }>;
```
</chained_conditions>

<distribution>
A conditional type on a bare type parameter distributes over a union. It applies to each member and joins the results. Here `Result` is `string[] | number[]`, not `(string | number)[]`.

```typescript
type ToArray<T> = T extends any ? T[] : never;

type Result = ToArray<string | number>;
```

Wrapping both sides in a tuple stops the distribution. Here `Result` is `(string | number)[]`.

```typescript
type ToArrayNonDistributive<T> = [T] extends [any] ? T[] : never;

type Result = ToArrayNonDistributive<string | number>;
```

From TypeScript 7.1 beta, a type parameter inside a distributive branch is treated as a narrower type parameter. Code that relied on the wider type there can get new errors.
</distribution>

<optional_features>
A condition can turn a feature on only when the config defines it. Here a route gets search parameters only when its `search` is a string array.

```typescript
interface BaseRouterConfig {
  search?: string[];
}

type TupleToSearchParams<T extends string[]> = {
  [K in T[number]]?: string;
};

type SearchParams<TConfig extends BaseRouterConfig, TRoute extends keyof TConfig> =
  TConfig[TRoute]["search"] extends string[]
    ? TupleToSearchParams<TConfig[TRoute]["search"]>
    : undefined;
```

The same condition works on a function parameter. In this router, `goTo("/")` accepts no search object, and `goTo("/search", ...)` accepts `query` and `page`.

```typescript
const makeRouter = <TConfig extends Record<string, { search?: string[] }>>(
  config: TConfig
) => {
  return {
    goTo: <TRoute extends keyof TConfig>(
      route: TRoute,
      search?: TConfig[TRoute]["search"] extends string[]
        ? { [K in TConfig[TRoute]["search"][number]]?: string }
        : never
    ) => {},
  };
};

const router = makeRouter({
  "/": {},
  "/search": { search: ["query", "page"] },
});

router.goTo("/");
router.goTo("/search", { query: "test", page: "1" });
```
</optional_features>

<filtering>
Returning `never` for a member removes it from a union. Here `OnlyStrings` is `"a" | "b"`.

```typescript
type ExtractStrings<T> = T extends string ? T : never;

type Mixed = "a" | "b" | 1 | 2 | true;
type OnlyStrings = ExtractStrings<Mixed>;
```

The built-in `Extract` and `Exclude` types work this way.

```typescript
type Extract<T, U> = T extends U ? T : never;
type Exclude<T, U> = T extends U ? never : T;
```
</filtering>

<recursive_conditions>
A conditional type can call itself to walk a structure. This `DeepReadonly` makes every nested property readonly and leaves functions unchanged.

```typescript
type DeepReadonly<T> = T extends Function
  ? T
  : T extends object
  ? { readonly [K in keyof T]: DeepReadonly<T[K]> }
  : T;

interface User {
  name: string;
  address: {
    city: string;
    country: string;
  };
  greet: () => void;
}

type ReadonlyUser = DeepReadonly<User>;
```
</recursive_conditions>

<tuple_checks>
Conditions on tuple shapes test for empty and non-empty arrays. Here `Test1` is `true` and `Test2` is `false`. `Test3` is `boolean`, because the length of `string[]` is unknown at compile time.

```typescript
type IsEmptyArray<T extends any[]> = T extends []
  ? true
  : T extends [any, ...any[]]
  ? false
  : boolean;

type Test1 = IsEmptyArray<[]>;
type Test2 = IsEmptyArray<[1]>;
type Test3 = IsEmptyArray<string[]>;
```

The pattern `[string, ...string[]]` matches an array with at least one element. Here `HasFields` is `true` when `fields` is a non-empty tuple.

```typescript
type HasFields<T extends { fields?: string[] }> =
  T["fields"] extends [string, ...string[]]
    ? true
    : false;
```
</tuple_checks>

<common_patterns>
Three short patterns come up often. `UnwrapPromise<Promise<string>>` is `string`, and `UnwrapPromise<string>` passes `string` through. `UnwrapArray<string[]>` is `string`, and `UnwrapArray<number>` passes `number` through. `Nullable` adds `null` to each property of an object, or to the type itself.

```typescript
type UnwrapPromise<T> = T extends Promise<infer U> ? U : T;

type UnwrapArray<T> = T extends (infer U)[] ? U : T;

type Nullable<T> = T extends object
  ? { [K in keyof T]: T[K] | null }
  : T | null;
```

For promises, prefer the built-in `Awaited`, which also unwraps nested promises.
</common_patterns>

<when_to_use>
Conditional types fit five situations.

- The output type depends on the input type.
- A union needs filtering, to keep or remove members.
- A feature exists only when a config defines it.
- A type guard returns different types for different inputs.
- A recursive type needs a base case.
</when_to_use>

<pitfalls>
Distribution can change the result for a union. `WrongIsArray<string | number[]>` is `boolean`, because it distributes. The tuple form checks the whole union, so `CorrectIsArray<string | number[]>` is `false`.

```typescript
type WrongIsArray<T> = T extends any[] ? true : false;
type Test = WrongIsArray<string | number[]>;

type CorrectIsArray<T> = [T] extends [any[]] ? true : false;
type Test2 = CorrectIsArray<string | number[]>;
```

A discriminated union is often simpler than a chain of conditions. The first type maps input types to results. The second states the two results directly and is easier to read.

```typescript
type ProcessResult<T> = T extends string
  ? { type: "string"; value: string }
  : T extends number
  ? { type: "number"; value: number }
  : never;

type Result =
  | { type: "string"; value: string }
  | { type: "number"; value: number };
```

Choose the false branch on purpose. Here `ExtractName<{ age: number }>` is `never`, which callers may not expect.

```typescript
type ExtractName<T> = T extends { name: infer N } ? N : never;

type Test = ExtractName<{ age: number }>;
```
</pitfalls>
