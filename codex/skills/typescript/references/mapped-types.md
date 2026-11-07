<overview>
A mapped type builds a new type by transforming each property of an existing type. It iterates over keys and applies the same transformation to each one.
</overview>

<syntax>
A mapped type iterates over a union of keys, usually `keyof T`.

```typescript
type MappedType<T> = {
  [K in keyof T]: TransformedType;
};
```
</syntax>

<modifiers>
The modifiers `?` and `readonly` can be added or removed with `+` and `-`. `MyPartial<User>` is `{ id?: string; name?: string; email?: string }`. The `-?` in `MyRequired` removes optionality, and `-readonly` in `Mutable` removes readonly.

```typescript
type MyPartial<T> = {
  [K in keyof T]?: T[K];
};

type MyRequired<T> = {
  [K in keyof T]-?: T[K];
};

type MyReadonly<T> = {
  readonly [K in keyof T]: T[K];
};

type Mutable<T> = {
  -readonly [K in keyof T]: T[K];
};

interface User {
  id: string;
  name: string;
  email: string;
}

type PartialUser = MyPartial<User>;
```

A mapping over `keyof T` keeps the original keys and modifiers. Such a mapping is called homomorphic.
</modifiers>

<key_remapping>
An `as` clause changes each key during the mapping.

```typescript
type RemapKeys<T> = {
  [K in keyof T as NewKeyType]: T[K];
};
```

A template in the `as` clause adds a prefix. Here `PrefixedUser` is `{ user_name: string; user_age: number }`.

```typescript
type Prefixed<T, P extends string> = {
  [K in keyof T as K extends string ? `${P}${K}` : K]: T[K];
};

interface User {
  name: string;
  age: number;
}

type PrefixedUser = Prefixed<User, "user_">;
```

A key that maps to `never` disappears. With the earlier `User` that has `email`, `UserWithoutEmail` is `{ id: string; name: string }`.

```typescript
type RemoveFields<T, K extends keyof T> = {
  [P in keyof T as P extends K ? never : P]: T[P];
};

type UserWithoutEmail = RemoveFields<User, "email">;
```

A conditional type in the `as` clause transforms keys. Here `CleanData` is `{ longitude: string; latitude: string }`.

```typescript
type RemoveMaps<T> = T extends `maps:${infer Rest}` ? Rest : T;

type RemoveMapsPrefixFromObj<T> = {
  [K in keyof T as RemoveMaps<K>]: T[K];
};

interface ApiData {
  "maps:longitude": string;
  "maps:latitude": string;
}

type CleanData = RemoveMapsPrefixFromObj<ApiData>;
```
</key_remapping>

<filtering_keys>
A condition on the value type in the `as` clause keeps only matching properties. Here `StringProps` is `{ name: string; email: string }`.

```typescript
type OnlyStrings<T> = {
  [K in keyof T as T[K] extends string ? K : never]: T[K];
};

interface Mixed {
  name: string;
  age: number;
  email: string;
  active: boolean;
}

type StringProps = OnlyStrings<Mixed>;
```

A mapped type indexed with `[keyof T]` returns a union of keys. These helpers split required and optional properties.

```typescript
type RequiredKeys<T> = {
  [K in keyof T]-?: undefined extends T[K] ? never : K;
}[keyof T];

type OnlyRequired<T> = Pick<T, RequiredKeys<T>>;

type OptionalKeys<T> = {
  [K in keyof T]-?: undefined extends T[K] ? K : never;
}[keyof T];

type OnlyOptional<T> = Pick<T, OptionalKeys<T>>;
```
</filtering_keys>

<transforming_values>
The value side can wrap or change each property type. With `Promisify`, a method type becomes a promise of the method, so `AsyncApi` is `{ getUser: Promise<() => User>; getPost: Promise<() => Post> }`. `Multiple` is `{ name: string[]; count: number[] }`.

```typescript
type Promisify<T> = {
  [K in keyof T]: Promise<T[K]>;
};

interface SyncApi {
  getUser(): User;
  getPost(): Post;
}

type AsyncApi = Promisify<SyncApi>;

type Arrayify<T> = {
  [K in keyof T]: T[K][];
};

interface Single {
  name: string;
  count: number;
}

type Multiple = Arrayify<Single>;

type Nullable<T> = {
  [K in keyof T]: T[K] | null;
};
```
</transforming_values>

<deep_mapped_types>
A mapped type can recurse into nested objects. `DeepReadonly` makes every level readonly, and `DeepPartial` makes every level optional. Both treat a function as an object, so they suit plain data only. For types with methods, use the safe version in the pitfalls.

```typescript
type DeepReadonly<T> = {
  readonly [K in keyof T]: T[K] extends object
    ? DeepReadonly<T[K]>
    : T[K];
};

type DeepPartial<T> = {
  [K in keyof T]?: T[K] extends object ? DeepPartial<T[K]> : T[K];
};
```
</deep_mapped_types>

<practical_examples>
Key remapping with `Capitalize` builds accessor types. `PersonGetters` is `{ getName: () => string; getAge: () => number }`. `PersonSetters` is `{ setName: (value: string) => void; setAge: (value: number) => void }`.

```typescript
type Getters<T> = {
  [K in keyof T as `get${Capitalize<string & K>}`]: () => T[K];
};

type Setters<T> = {
  [K in keyof T as `set${Capitalize<string & K>}`]: (value: T[K]) => void;
};

interface Person {
  name: string;
  age: number;
}

type PersonGetters = Getters<Person>;

type PersonSetters = Setters<Person>;
```

The same idea builds change handlers. `StateHandlers` has `onCountChange` with two `number` arguments and `onNameChange` with two `string` arguments.

```typescript
type EventHandlers<T> = {
  [K in keyof T as `on${Capitalize<string & K>}Change`]: (
    newValue: T[K],
    oldValue: T[K]
  ) => void;
};

interface State {
  count: number;
  name: string;
}

type StateHandlers = EventHandlers<State>;
```

A mapped type gives each form field an optional error list. `RegistrationErrors` is `{ email?: string[]; password?: string[]; confirmPassword?: string[] }`.

```typescript
type ValidationErrors<T> = {
  [K in keyof T]?: string[];
};

interface RegistrationForm {
  email: string;
  password: string;
  confirmPassword: string;
}

type RegistrationErrors = ValidationErrors<RegistrationForm>;
```
</practical_examples>

<combining_mapped_types>
Mapped types combine with conditions and unions of keys. `PickAndTransform` picks keys and makes non-function values readonly. `Merge` combines two types, and `B` wins for shared keys.

```typescript
type PickAndTransform<T, K extends keyof T> = {
  [P in K]: T[P] extends Function ? T[P] : Readonly<T[P]>;
};

type Merge<A, B> = {
  [K in keyof A | keyof B]: K extends keyof B
    ? B[K]
    : K extends keyof A
    ? A[K]
    : never;
};
```

A mapping over a union of string literals creates an object with those keys. Here `Dict` is `{ a: number; b: number; c: number }`, the same as `Record<"a" | "b" | "c", number>`.

```typescript
type FromUnion<K extends string, V> = {
  [P in K]: V;
};

type Dict = FromUnion<"a" | "b" | "c", number>;
```
</combining_mapped_types>

<pitfalls>
A template in the `as` clause cannot take a symbol key. The first type fails, because `keyof T` can include symbols and a template does not accept them. The second filters them out.

```typescript
type Wrong<T> = {
  [K in keyof T as `prefix_${K}`]: T[K];
};

type Correct<T> = {
  [K in keyof T as K extends string ? `prefix_${K}` : never]: T[K];
};
```

A remap over `keyof T` keeps the optional and readonly modifiers of each property. Adding `+?` or `-readonly` changes them for every key, so use those only when all keys need the change.

A recursive mapped type without a base case maps function properties too. This `DeepReadonly` keeps primitives as they are, but a method becomes an object without call signatures. A call to it then reports "This expression is not callable".

```typescript
type DeepReadonly<T> = {
  readonly [K in keyof T]: DeepReadonly<T[K]>;
};
```

A conditional base case keeps functions callable.

```typescript
type DeepReadonlySafe<T> = T extends (...args: any[]) => any
  ? T
  : T extends object
  ? { readonly [K in keyof T]: DeepReadonlySafe<T[K]> }
  : T;
```
</pitfalls>

<when_to_use>
Mapped types fit five situations.

- Optional or readonly modifiers need to change.
- Keys need a prefix, a suffix, or another rename.
- Some properties need removing or keeping.
- Every property needs the same transformation.
- A reusable helper type transforms other types.
</when_to_use>
