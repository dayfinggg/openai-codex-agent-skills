<contents>
This file has these sections, in order.
- request waterfalls
- bundle size
</contents>

<request_waterfalls>
Waterfalls cost the most load time. Each sequential `await` adds a full network round trip, so removing them gives the largest gains. These rules apply to any async JavaScript, including Server Components, Server Actions, and request handlers.

<parallel_independent_work>
Run async operations that do not depend on each other at the same time with `Promise.all()`. This version makes three round trips in a row.

```typescript
const user = await fetchUser()
const posts = await fetchPosts()
const comments = await fetchComments()
```

This version makes one round trip, because all three requests start together.

```typescript
const [user, posts, comments] = await Promise.all([
  fetchUser(),
  fetchPosts(),
  fetchComments()
])
```
</parallel_independent_work>

<partial_dependencies>
Start every promise as early as its inputs allow, and await them together at the end. In this version, the profile waits for the config although it needs only the user.

```typescript
const [user, config] = await Promise.all([
  fetchUser(),
  fetchConfig()
])
const profile = await fetchProfile(user.id)
```

In this version, the config and the profile load in parallel, because the profile chains only on the user.

```typescript
const userPromise = fetchUser()
const profilePromise = userPromise.then(user => fetchProfile(user.id))

const [user, config, profile] = await Promise.all([
  userPromise,
  fetchConfig(),
  profilePromise
])
```

The same rule holds in request handlers and Server Actions. Start independent work, such as the session and the config, before you await the first one. If the project already uses `better-all`, its `all()` helper starts each task at the earliest possible moment.
</partial_dependencies>

<defer_await>
Move each `await` into the branch that uses its result, so other paths do not wait for it. This version always waits for the permissions, even when the resource does not exist.

```typescript
async function updateResource(resourceId: string, userId: string) {
  const permissions = await fetchPermissions(userId)
  const resource = await getResource(resourceId)

  if (!resource) {
    return { error: 'Not found' }
  }

  if (!permissions.canEdit) {
    return { error: 'Forbidden' }
  }

  return await updateResourceData(resource, permissions)
}
```

This version fetches the permissions only after it knows the resource exists.

```typescript
async function updateResource(resourceId: string, userId: string) {
  const resource = await getResource(resourceId)

  if (!resource) {
    return { error: 'Not found' }
  }

  const permissions = await fetchPermissions(userId)

  if (!permissions.canEdit) {
    return { error: 'Forbidden' }
  }

  return await updateResourceData(resource, permissions)
}
```

The gain is largest when the skipped branch runs often or the deferred call is expensive.
</defer_await>

<cheap_condition_first>
When a branch needs both an awaited flag and a cheap synchronous condition, check the cheap condition first. This version pays for the flag lookup even when `someCondition` is false.

```typescript
const someFlag = await getFlag()

if (someFlag && someCondition) {
  enableFeature()
}
```

This version skips the lookup on that path.

```typescript
if (someCondition) {
  const someFlag = await getFlag()
  if (someFlag) {
    enableFeature()
  }
}
```

Keep the original order when the condition is expensive or depends on the flag. Also keep it when side effects need a fixed order.
</cheap_condition_first>

<suspense_boundaries>
Await data in the component that needs it, inside a `<Suspense>` boundary. The rest of the page then renders at once. In this version, the whole layout waits for data that only one section uses.

```tsx
async function Page() {
  const data = await fetchData()

  return (
    <div>
      <div>Sidebar</div>
      <div>Header</div>
      <div>
        <DataDisplay data={data} />
      </div>
      <div>Footer</div>
    </div>
  )
}
```

In this version, the sidebar, header, and footer render at once, and only `DataDisplay` waits.

```tsx
function Page() {
  return (
    <div>
      <div>Sidebar</div>
      <div>Header</div>
      <div>
        <Suspense fallback={<Skeleton />}>
          <DataDisplay />
        </Suspense>
      </div>
      <div>Footer</div>
    </div>
  )
}

async function DataDisplay() {
  const data = await fetchData()
  return <div>{data.content}</div>
}
```

Several components can share one request through a promise and `use()`. Start the fetch without `await` and pass the promise down. Both components in this version read the same promise, so only one fetch runs.

```tsx
function Page() {
  const dataPromise = fetchData()

  return (
    <div>
      <div>Sidebar</div>
      <div>Header</div>
      <Suspense fallback={<Skeleton />}>
        <DataDisplay dataPromise={dataPromise} />
        <DataSummary dataPromise={dataPromise} />
      </Suspense>
      <div>Footer</div>
    </div>
  )
}

function DataDisplay({ dataPromise }: { dataPromise: Promise<Data> }) {
  const data = use(dataPromise)
  return <div>{data.content}</div>
}

function DataSummary({ dataPromise }: { dataPromise: Promise<Data> }) {
  const data = use(dataPromise)
  return <div>{data.summary}</div>
}
```

Skip this pattern for data that decides the layout, for search-critical content above the fold, and for small fast queries. The tradeoff is a faster first paint against a possible layout shift.
</suspense_boundaries>
</request_waterfalls>

<bundle_size>
A smaller initial bundle improves Time to Interactive and Largest Contentful Paint. These rules apply to any bundler. On Next.js, check its bundled docs first, because the framework handles some of these cases itself.

<barrel_imports>
Import from the module file instead of a barrel file that re-exports a whole library. Icon and component libraries can re-export thousands of modules from one entry file. Importing them can cost hundreds of milliseconds in development and on every cold start. Tree shaking does not help when the library is external to the bundle. This import loads the full entry module of each library.

```tsx
import { Check, X, Menu } from 'lucide-react'
import { Button, TextField } from '@mui/material'
```

These imports load only the two components.

```tsx
import Button from '@mui/material/Button'
import TextField from '@mui/material/TextField'
```

Before you switch to deep imports, check that the library exports types and a stable path for them. Libraries with large barrels include `lucide-react`, `@mui/material`, `@mui/icons-material`, `@tabler/icons-react`, `react-icons`, `lodash`, `date-fns`, `rxjs`, and `react-use`.
</barrel_imports>

<lazy_heavy_components>
Load large components that the first render does not need with `React.lazy()` and `<Suspense>`. In this version, the editor ships in the main chunk.

```tsx
import { MonacoEditor } from './monaco-editor'

function CodePanel({ code }: { code: string }) {
  return <MonacoEditor value={code} />
}
```

In this version, the editor loads on demand.

```tsx
import { lazy, Suspense } from 'react'

const MonacoEditor = lazy(() =>
  import('./monaco-editor').then(m => ({ default: m.MonacoEditor }))
)

function CodePanel({ code }: { code: string }) {
  return (
    <Suspense fallback={<Skeleton />}>
      <MonacoEditor value={code} />
    </Suspense>
  )
}
```

Next.js has its own lazy-loading API, which its bundled docs describe. Load analytics, logging, and error tracking after hydration the same way, because they do not block user interaction.
</lazy_heavy_components>

<conditional_loading>
Load large data or modules only when the user turns on the feature that needs them. This component imports the animation frames only when the player is enabled.

```tsx
function AnimationPlayer({ enabled, setEnabled }: {
  enabled: boolean
  setEnabled: React.Dispatch<React.SetStateAction<boolean>>
}) {
  const [frames, setFrames] = useState<Frame[] | null>(null)

  useEffect(() => {
    if (enabled && !frames && typeof window !== 'undefined') {
      import('./animation-frames.js')
        .then(mod => setFrames(mod.frames))
        .catch(() => setEnabled(false))
    }
  }, [enabled, frames, setEnabled])

  if (!frames) return <Skeleton />
  return <Canvas frames={frames} />
}
```

The `typeof window !== 'undefined'` check keeps the module out of the server bundle.
</conditional_loading>

<preload_on_intent>
Start loading a heavy module when the user shows intent, such as a hover or a focus. It is then ready on click. This button starts the import before the click.

```tsx
function EditorButton({ onClick }: { onClick: () => void }) {
  const preload = () => {
    if (typeof window !== 'undefined') {
      void import('./monaco-editor')
    }
  }

  return (
    <button onMouseEnter={preload} onFocus={preload} onClick={onClick}>
      Open Editor
    </button>
  )
}
```
</preload_on_intent>

<analyzable_paths>
Keep import paths and file-system paths literal, so the build tool can see which files code may reach. A path hidden in a variable makes the tool include a broad set of files, warn, or widen file tracing. That leads to larger server bundles, slower builds, slower cold starts, and more memory use. The bundler cannot resolve this import.

```ts
const PAGE_MODULES = {
  home: './pages/home',
  settings: './pages/settings',
} as const

const Page = await import(PAGE_MODULES[pageName])
```

An explicit map of import functions keeps the set of modules narrow.

```ts
const PAGE_MODULES = {
  home: () => import('./pages/home'),
  settings: () => import('./pages/settings'),
} as const

const Page = await PAGE_MODULES[pageName]()
```

The same rule holds for file reads in server code. Write each final path as a literal at the call site, instead of joining a variable into it.

```ts
const baseDir =
  kind === ContentKind.Blog
    ? path.join(process.cwd(), 'content/blog')
    : path.join(process.cwd(), 'content/docs')
```
</analyzable_paths>
</bundle_size>
