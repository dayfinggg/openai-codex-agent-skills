<server_rendering>
Server work runs before the user sees anything, so its waterfalls and repeated I/O add directly to response time. These rules cover React Server Components, Server Actions, and server rendering. Framework-specific APIs, such as Next.js request helpers, are in the framework's own docs.

<authenticate_server_actions>
A Server Action, which is a function marked `"use server"`, is a public endpoint like an API route. Check authentication and authorization inside each action. Middleware, layout guards, and page checks do not protect it, because a client can call the action directly. This action lets anyone delete any user.

```typescript
'use server'

export async function deleteUser(userId: string) {
  await db.user.delete({ where: { id: userId } })
  return { success: true }
}
```

This action checks the session and the caller's rights before the mutation.

```typescript
'use server'

import { verifySession } from '@/lib/auth'
import { unauthorized } from '@/lib/errors'

export async function deleteUser(userId: string) {
  const session = await verifySession()

  if (!session) {
    throw unauthorized('Must be logged in')
  }

  if (session.user.role !== 'admin' && session.user.id !== userId) {
    throw unauthorized('Cannot delete other users')
  }

  await db.user.delete({ where: { id: userId } })
  return { success: true }
}
```

Validate the input of an action too, because its arguments come from the client. Use the validation library the project already has. This action uses Zod 4 to validate, then authenticates and authorizes.

```typescript
'use server'

import { verifySession } from '@/lib/auth'
import { z } from 'zod'

const updateProfileSchema = z.object({
  userId: z.uuid(),
  name: z.string().min(1).max(100),
  email: z.email()
})

export async function updateProfile(data: unknown) {
  const validated = updateProfileSchema.parse(data)

  const session = await verifySession()
  if (!session) {
    throw new Error('Unauthorized')
  }

  if (session.user.id !== validated.userId) {
    throw new Error('Can only update own profile')
  }

  await db.user.update({
    where: { id: validated.userId },
    data: { name: validated.name, email: validated.email }
  })

  return { success: true }
}
```
</authenticate_server_actions>

<parallel_component_fetching>
Server Components that await in a parent block their children, so the tree fetches in sequence. Move each fetch into the component that needs it, so sibling components fetch in parallel. In this version, `Sidebar` starts only after the header data arrives.

```tsx
export default async function Page() {
  const header = await fetchHeader()
  return (
    <div>
      <div>{header}</div>
      <Sidebar />
    </div>
  )
}

async function Sidebar() {
  const items = await fetchSidebarItems()
  return <nav>{items.map(renderItem)}</nav>
}
```

In this version, `Header` and `Sidebar` fetch at the same time.

```tsx
async function Header() {
  const data = await fetchHeader()
  return <div>{data}</div>
}

async function Sidebar() {
  const items = await fetchSidebarItems()
  return <nav>{items.map(renderItem)}</nav>
}

export default function Page() {
  return (
    <div>
      <Header />
      <Sidebar />
    </div>
  )
}
```

Passing a fetching component as `children` to a layout component gives the same parallel result.
</parallel_component_fetching>

<parallel_nested_fetching>
Chain each item's dependent fetch inside that item's promise, so one slow item does not block the rest. In this version, one slow `getChat` call holds back the authors of all other chats.

```tsx
const chats = await Promise.all(
  chatIds.map(id => getChat(id))
)

const chatAuthors = await Promise.all(
  chats.map(chat => getUser(chat.author))
)
```

In this version, each chat fetches its author as soon as the chat arrives.

```tsx
const chatAuthors = await Promise.all(
  chatIds.map(id => getChat(id).then(chat => getUser(chat.author)))
)
```
</parallel_nested_fetching>

<no_shared_module_state>
Never store request data in a mutable module-level variable on the server. Server renders run concurrently in one process, so one request can overwrite the value while another still reads it. The result is a race condition, or one user's data in another user's response. In this version, request B can overwrite `currentUser` before request A renders `Dashboard`.

```tsx
let currentUser: User | null = null

export default async function Page() {
  currentUser = await auth()
  return <Dashboard />
}

async function Dashboard() {
  return <div>{currentUser?.name}</div>
}
```

This version keeps the request data inside the render tree.

```tsx
export default async function Page() {
  const user = await auth()
  return <Dashboard user={user} />
}

function Dashboard({ user }: { user: User | null }) {
  return <div>{user?.name}</div>
}
```

Module scope on the server is shared process memory. It may safely hold immutable assets or config, caches keyed for cross-request reuse, and singletons without request or user data.
</no_shared_module_state>

<hoist_static_io>
Load static assets and config at module level, so the read runs once per process instead of once per request. This handler reads the config and the template on every call.

```typescript
import fs from 'node:fs/promises'

export async function processRequest(data: Data) {
  const config = JSON.parse(
    await fs.readFile('./config.json', 'utf-8')
  )
  const template = await fs.readFile('./template.html', 'utf-8')

  return render(template, data, config)
}
```

This version starts both reads when the module loads and awaits the same promises on every call.

```typescript
import fs from 'node:fs/promises'

const configPromise = fs
  .readFile('./config.json', 'utf-8')
  .then(JSON.parse)
const templatePromise = fs.readFile('./template.html', 'utf-8')

export async function processRequest(data: Data) {
  const [config, template] = await Promise.all([
    configPromise,
    templatePromise,
  ])

  return render(template, data, config)
}
```

The pattern fits fonts for generated images, logos, static config, and email templates. Do not use it for assets that vary per request or user, or for files that change at runtime. Large files and sensitive data should not stay in memory either. In serverless runtimes, each cold start runs module-level code again, and warm calls reuse the result.
</hoist_static_io>

<per_request_cache>
Wrap repeated server work, such as the current-user lookup or a database query, in `cache()` from `react`. Within one request, every call after the first returns the stored result.

```typescript
import { cache } from 'react'

export const getCurrentUser = cache(async () => {
  const session = await auth()
  if (!session?.user?.id) return null
  return await db.user.findUnique({
    where: { id: session.user.id }
  })
})
```

`cache()` compares arguments with `Object.is`, so a new inline object misses the cache every time. Pass primitive arguments instead. This version always runs the query twice.

```typescript
const getUser = cache(async (params: { uid: number }) => {
  return await db.user.findUnique({ where: { id: params.uid } })
})

getUser({ uid: 1 })
getUser({ uid: 1 })
```

This version runs the query once.

```typescript
const getUser = cache(async (uid: number) => {
  return await db.user.findUnique({ where: { id: uid } })
})

getUser(1)
getUser(1)
```

`cache()` works only in Server Components and lasts for one request. Some frameworks already deduplicate `fetch` calls, so check the framework docs before you wrap `fetch`. In React 19.2 and later, `cacheSignal()` gives an `AbortSignal` that fires when the cache lifetime ends.
</per_request_cache>

<cross_request_cache>
`cache()` does not help when several requests in a row need the same data. Two clicks a few seconds apart are an example. Use a bounded in-process cache with a time limit for that case. This version uses `lru-cache`, if the project already has it.

```typescript
import { LRUCache } from 'lru-cache'

const cache = new LRUCache<string, User>({
  max: 1000,
  ttl: 5 * 60 * 1000
})

export async function getUser(id: string) {
  const cached = cache.get(id)
  if (cached) return cached

  const user = await db.user.findUnique({ where: { id } })
  if (user) cache.set(id, user)
  return user
}
```

An in-process cache lives only as long as its process. When each request runs in a separate instance, use the shared cache the project already has, such as Redis.
</cross_request_cache>

<minimize_serialization>
React serializes every prop that crosses from a Server Component to a Client Component into the HTML and the payload. Pass only the fields the client uses. This version sends all fields of the user to show one name.

```tsx
async function Page() {
  const user = await fetchUser()
  return <Profile user={user} />
}
```

This version sends one string.

```tsx
async function Page() {
  const user = await fetchUser()
  return <Profile name={user.name} />
}
```

Serialization deduplicates by object reference, not by value. A derived copy of an array, such as `usernames.toSorted()` passed next to `usernames`, is sent a second time. Arrays of primitives cost the most, because every value repeats. Arrays of objects repeat only the array, because the nested objects keep their references. Send the original once and derive the copy in the client. Pass derived data only when the transformation is expensive or the client needs no original.
</minimize_serialization>
</server_rendering>
