<overview>
TypeScript widens literal types when it infers objects and arrays. A type-safe API often needs the literal types deep inside a nested argument. A `const` type parameter keeps them without any library and without work for the caller.
</overview>

<the_problem>
Default inference widens nested literals. In this example, `TConfig` is inferred with `search: string[]`, not `["query", "page"]`.

```typescript
const makeRouter = <TConfig>(config: TConfig) => {
  return { config };
};

const router = makeRouter({
  "/": {},
  "/search": {
    search: ["query", "page"],
  },
});
```
</the_problem>

<const_type_parameters>
A `const` modifier on a type parameter infers the argument as if the caller wrote `as const`. Here `TConfig` keeps `search` as the tuple `["query", "page"]`. The modifier works with a constraint and needs no change at the call site.

```typescript
const makeRouter = <const TConfig extends BaseRouterConfig>(
  config: TConfig
) => {
  return { config };
};

const router = makeRouter({
  "/": {},
  "/search": {
    search: ["query", "page"],
  },
});
```

The modifier affects only literals written in the call. A variable passed as the argument keeps the type it already has. A mutable array constraint such as `string[]` infers a mutable tuple, and a `readonly string[]` constraint infers a readonly tuple.
</const_type_parameters>

<caller_as_const>
The caller can also write `as const` on the argument. The result is deeply readonly, so `search` becomes `readonly ["query", "page"]`. This needs no change in the API, but every caller must remember it. The readonly types may also need changes elsewhere. Prefer a `const` type parameter when you control the function.

```typescript
const router = makeRouter({
  "/": {},
  "/search": {
    search: ["query", "page"],
  },
} as const);
```

Older code may use `F.Narrow` from the ts-toolbelt library or a hand-written `Narrow` type for the same purpose. A `const` type parameter replaces both.
</caller_as_const>

<router_example>
This router derives the allowed search parameters of each route from the config. The keys passed to `goTo` must be among the search names of that route. The last call fails to compile, because `invalid` is not a search parameter of `/dashboard`.

```typescript
type BaseRouterConfig = Record<string, { search?: string[] }>;

type TupleToSearchParams<T extends string[]> = {
  [K in T[number]]?: string;
};

const makeRouter = <const TConfig extends BaseRouterConfig>(
  config: TConfig
) => {
  return {
    config,
    goTo: <TRoute extends keyof TConfig>(
      route: TRoute,
      search?: TConfig[TRoute]["search"] extends string[]
        ? TupleToSearchParams<TConfig[TRoute]["search"]>
        : never
    ) => {},
  };
};

const router = makeRouter({
  "/": {},
  "/dashboard": {
    search: ["page", "perPage", "sort"],
  },
});

router.goTo("/dashboard", {
  page: "1",
  perPage: "10",
  sort: "name",
});

router.goTo("/dashboard", { invalid: "value" });
```
</router_example>

<common_uses>
Deep inference matters for configuration objects, route definitions, and event maps. In this theme, `theme.primary` is `"#0066cc"`, not `string`.

```typescript
const createTheme = <const TTheme extends Record<string, string>>(
  theme: TTheme
): TTheme => theme;

const theme = createTheme({
  primary: "#0066cc",
  secondary: "#666666",
});
```

Literal types in the config also drive conditional and indexed types. Here `user` is `"User"` and `post` is `"Post"`.

```typescript
const makeApi = <const TConfig extends Record<string, { returns: string }>>(
  config: TConfig
) => {
  return {
    call: <TMethod extends keyof TConfig>(
      method: TMethod
    ): TConfig[TMethod]["returns"] => config[method].returns,
  };
};

const api = makeApi({
  getUser: { returns: "User" },
  getPost: { returns: "Post" },
});

const user = api.call("getUser");
const post = api.call("getPost");
```
</common_uses>

<comparison>
Two techniques keep deep literal types.

| Technique | Advantages | Drawbacks |
|---|---|---|
| `const` type parameter | Built in, no caller work, works with constraints | Applies only to literals in the call |
| Caller writes `as const` | Needs no API change | Every caller must remember it, and the result is readonly |
</comparison>

<pitfalls>
`as const` makes arrays readonly, so mutating methods disappear. Here `config.values` is `readonly [1, 2, 3]`. The call to `push` reports "Property 'push' does not exist on type 'readonly [1, 2, 3]'".

```typescript
const config = {
  values: [1, 2, 3],
} as const;

config.values.push(4);
```

A constraint guides inference. Add one that describes the expected shape. Callers then get errors at the argument and not deep inside the result type.

Very deep literal types can slow the compiler. Keep inferred configs as shallow as the API allows.
</pitfalls>
