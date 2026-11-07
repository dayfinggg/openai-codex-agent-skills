<overview>
A builder builds a data structure through a chain of method calls. In TypeScript, each call can return a builder with an updated type. The type then tracks what the chain has added.
</overview>

<basic_concept>
Each method returns the builder with more type information. After this chain, the result knows that user `matt` and post `post1` exist.

```typescript
new DbSeeder()
  .addUser("matt", { name: "Matt" })
  .addPost("post1", { title: "Hello" })
  .transact();
```
</basic_concept>

<implementation>
The implementation takes three steps.

1. Define the entity types and a shape that constrains the generic.
2. Write a generic builder whose methods return the builder with an extended type.
3. Cast the stored values to the accumulated type in the final method.

These are the base types.

```typescript
interface User {
  id: string;
  name: string;
}

interface Post {
  id: string;
  title: string;
  authorId: string;
}

interface DbShape {
  users: Record<string, User>;
  posts: Record<string, Post>;
}
```

Each method of this builder returns `DbSeeder` with the new ID added to its type. The final method `transact` returns the stored records with the accumulated type.

```typescript
export class DbSeeder<TDatabase extends DbShape> {
  public users: DbShape["users"] = {};
  public posts: DbShape["posts"] = {};

  addUser = <Id extends string>(
    id: Id,
    user: Omit<User, "id">,
  ): DbSeeder<TDatabase & { users: TDatabase["users"] & Record<Id, User> }> => {
    this.users[id] = { ...user, id };
    return this;
  };

  addPost = <Id extends string>(
    id: Id,
    post: Omit<Post, "id">,
  ): DbSeeder<TDatabase & { posts: TDatabase["posts"] & Record<Id, Post> }> => {
    this.posts[id] = { ...post, id };
    return this;
  };

  transact = async () => {
    return {
      users: this.users as TDatabase["users"],
      posts: this.posts as TDatabase["posts"],
    };
  };
}
```

With this builder, `result.users.matt` is typed as `User`, and `result.posts.post1` and `result.posts.post2` are typed as `Post`.

```typescript
const result = await new DbSeeder()
  .addUser("matt", { name: "Matt" })
  .addPost("post1", { authorId: "matt", title: "Hello" })
  .addPost("post2", { authorId: "matt", title: "World" })
  .transact();

console.log(result.users.matt.name);
console.log(result.posts.post1.title);
```
</implementation>

<how_types_build_up>
Each call extends the type parameter. The chain above moves through four types.

1. `new DbSeeder()` starts with the constraint `DbShape`.
2. `.addUser("matt", ...)` adds `{ users: Record<"matt", User> }`.
3. `.addPost("post1", ...)` adds `{ posts: Record<"post1", Post> }`.
4. `.addPost("post2", ...)` adds `Record<"post2", Post>` to the posts.
</how_types_build_up>

<key_techniques>
Three techniques make the builder work.

- A type parameter with `extends string` captures a literal ID. In `addUser`, `Id` becomes `"matt"`, not `string`.
- An intersection with `&` adds type information and keeps what was there, as in `TDatabase & { users: TDatabase["users"] & Record<Id, User> }`.
- The final method casts, because the runtime type of the stored record does not match the accumulated compile-time type.
</key_techniques>

<query_builder>
This query builder allows `build` only after `from`. The `this` parameter of `build` requires a state where `table` is a string. The initial state has the explicit type `QueryState`, so `table` starts as `string | null`.

```typescript
interface QueryState {
  table: string | null;
  columns: string[];
  whereValue: boolean | null;
}

class QueryBuilder<TState extends QueryState> {
  private state: TState;

  private constructor(state: TState) {
    this.state = state;
  }

  static create() {
    return new QueryBuilder<QueryState>({
      table: null,
      columns: [],
      whereValue: null,
    });
  }

  from<T extends "users">(
    table: T
  ): QueryBuilder<TState & { table: T }> {
    if (table !== "users") throw new Error("Unknown table");
    return new QueryBuilder({ ...this.state, table });
  }

  select<C extends Array<"id" | "name" | "active">>(
    ...columns: C
  ): QueryBuilder<TState & { columns: C }> {
    if (columns.some(column => !["id", "name", "active"].includes(column))) {
      throw new Error("Unknown column");
    }
    return new QueryBuilder({ ...this.state, columns });
  }

  where<W extends boolean>(
    value: W
  ): QueryBuilder<TState & { whereValue: W }> {
    return new QueryBuilder({ ...this.state, whereValue: value });
  }

  build(this: QueryBuilder<TState & { table: string }>): { text: string; values: boolean[] } {
    const cols = this.state.columns.length
      ? this.state.columns.join(", ")
      : "*";
    const sql = `SELECT ${cols} FROM ${this.state.table}`;
    if (this.state.whereValue !== null) {
      return { text: `${sql} WHERE active = $1`, values: [this.state.whereValue] };
    }
    return { text: sql, values: [] };
  }
}
```

The first chain compiles. The second fails, because it calls `build` without `from`.

```typescript
const query = QueryBuilder.create()
  .from("users")
  .select("id", "name")
  .where(true)
  .build();

QueryBuilder.create().select("id").build();
```
</query_builder>

<required_fields_builder>
This config builder allows `build` only after `host` and `port`. The type parameter records which fields are set. The `declare` field makes the class depend on `TConfigured` structurally. Without it, every `ConfigBuilder` is assignable to every other, and the check in `build` never fails.

```typescript
interface ServerConfig {
  host: string;
  port: number;
  ssl?: boolean;
  timeout?: number;
}

type ConfiguredFields = Partial<Record<keyof ServerConfig, true>>;

class ConfigBuilder<TConfigured extends ConfiguredFields = {}> {
  declare private readonly configured: TConfigured;
  private config: Partial<ServerConfig> = {};

  host(value: string): ConfigBuilder<TConfigured & { host: true }> {
    this.config.host = value;
    return this as ConfigBuilder<TConfigured & { host: true }>;
  }

  port(value: number): ConfigBuilder<TConfigured & { port: true }> {
    this.config.port = value;
    return this as ConfigBuilder<TConfigured & { port: true }>;
  }

  ssl(value: boolean): ConfigBuilder<TConfigured & { ssl: true }> {
    this.config.ssl = value;
    return this as ConfigBuilder<TConfigured & { ssl: true }>;
  }

  build(this: ConfigBuilder<{ host: true; port: true }>): ServerConfig {
    return this.config as ServerConfig;
  }
}
```

The first chain compiles. The second fails, because `port` is missing.

```typescript
const config = new ConfigBuilder()
  .host("localhost")
  .port(3000)
  .ssl(true)
  .build();

new ConfigBuilder().host("localhost").build();
```
</required_fields_builder>

<default_values>
A default for the type parameter gives every builder a starting state. Here every new `DbSeeder` already has `users.defaultUser` in its type and at runtime.

```typescript
export class DbSeeder<
  TDatabase extends DbShape = {
    users: { defaultUser: User };
    posts: {};
  }
> {
  public users: DbShape["users"] = {
    defaultUser: { id: "default", name: "Default User" },
  };
  public posts: DbShape["posts"] = {};
}

const seeder = new DbSeeder();
```
</default_values>

<when_to_use>
A typed builder fits four situations.

- Construction of an object with many optional and required fields.
- Fluent APIs for queries, configuration, or test data.
- A type-level check that the required steps happened.
- Building pieces over time before a final step.
</when_to_use>

<pitfalls>
An unconstrained type parameter cannot be indexed. In the first class, `TDatabase["users"]` fails to compile. The constraint `extends DbShape` makes it valid.

```typescript
class DbSeederBad<TDatabase> {}

class DbSeederGood<TDatabase extends DbShape> {}
```

A final method without a cast returns the runtime type. In this version, `users` has the type `Record<string, User>` instead of `TDatabase["users"]`, so the IDs are lost.

```typescript
transact = async () => {
  return {
    users: this.users,
    posts: this.posts,
  };
};
```

A method that returns `this` keeps the old type and loses the added ID. Return the new instantiation of the generic instead, as `addUser` in the implementation does.

```typescript
addUser(id: string, user: Omit<User, "id">): this {
  return this;
}
```
</pitfalls>
