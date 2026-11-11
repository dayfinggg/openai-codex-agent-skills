<contents>
This file has these sections, in order.
- browser loading
- dom and events
- storage
- hot paths
</contents>

<browser_loading>
The browser's loading and painting work decides how fast a page appears. These rules have a high impact, because each one removes blocking work from the first load.

<script_defer_async>
A script tag without `defer` or `async` blocks HTML parsing while it downloads and runs. `defer` downloads in parallel and runs after parsing, in document order. `async` downloads in parallel and runs as soon as it arrives, in any order. Use `defer` for scripts that need the DOM or other scripts, and `async` for independent scripts such as analytics. This head loads both scripts without blocking.

```tsx
export default function Document() {
  return (
    <html>
      <head>
        <script src="https://example.com/analytics.js" async />
        <script src="/scripts/utils.js" defer />
      </head>
      <body>
        <Main />
      </body>
    </html>
  )
}
```

Frameworks often have their own script component, such as Next.js, so check its docs first.
</script_defer_async>

<resource_hints>
React DOM exports functions that tell the browser early about resources it will need. In Server Components, they start the loads before the client receives the HTML. Each function fits one case.

| Function | Use |
|---|---|
| `prefetchDNS(href)` | Third-party domains the page connects to later |
| `preconnect(href)` | Servers the page fetches from soon, with DNS, TCP, and TLS done ahead |
| `preload(href, options)` | Stylesheets, fonts, scripts, or images the current page needs |
| `preloadModule(href)` | ES modules for a likely next navigation |
| `preinit(href, options)` | Stylesheets or scripts that must load and run early |
| `preinitModule(href)` | ES modules that must load and run early |

This layout preloads a font and applies a critical stylesheet early.

```tsx
import { preload, preinit } from 'react-dom'

export default function RootLayout({ children }) {
  preload('/fonts/inter.woff2', { as: 'font', type: 'font/woff2', crossOrigin: 'anonymous' })
  preinit('/styles/critical.css', { as: 'style', precedence: 'high' })

  return (
    <html>
      <body>{children}</body>
    </html>
  )
}
```

The [React DOM resource APIs](https://react.dev/reference/react-dom#resource-preloading-apis) list all options.
</resource_hints>

<content_visibility>
Apply `content-visibility: auto` to the items of a long list, so the browser skips layout and paint for items off screen. Set `contain-intrinsic-size` to a typical item size, so the scrollbar stays stable. For a list of 1000 messages, the browser then lays out only the few on screen.

```css
.message-item {
  content-visibility: auto;
  contain-intrinsic-size: 0 80px;
}
```
</content_visibility>
</browser_loading>

<dom_and_events>
DOM writes, layout reads, and event listeners run on the main thread. These rules keep it free for input and animation.

<layout_thrashing>
Do not interleave style writes with layout reads. Reading `offsetWidth`, `getBoundingClientRect()`, or `getComputedStyle()` after a style change forces a synchronous reflow. This function forces two reflows.

```typescript
function layoutThrashing(element: HTMLElement) {
  element.style.width = '100px'
  const width = element.offsetWidth
  element.style.height = '200px'
  const height = element.offsetHeight
}
```

This function does all reads first and all writes after.

```typescript
function avoidThrashing(element: HTMLElement) {
  const rect = element.getBoundingClientRect()
  const offsetWidth = element.offsetWidth

  element.style.width = '100px'
  element.style.height = '200px'
}
```

Prefer toggling a CSS class over setting several inline styles. In React, compute the class name from props instead of writing styles in an effect.
</layout_thrashing>

<passive_listeners>
Add `{ passive: true }` to `touchstart`, `touchmove`, and `wheel` listeners that never call `preventDefault()`. Without it, the browser waits for the listener before it scrolls. Leave out `passive` for custom swipe gestures, custom zoom, and any listener that calls `preventDefault()`. These listeners do not delay scrolling.

```typescript
useEffect(() => {
  const handleTouch = (e: TouchEvent) => trackTouch(e.touches[0].clientX)
  const handleWheel = (e: WheelEvent) => trackWheel(e.deltaY)

  document.addEventListener('touchstart', handleTouch, { passive: true })
  document.addEventListener('wheel', handleWheel, { passive: true })

  return () => {
    document.removeEventListener('touchstart', handleTouch)
    document.removeEventListener('wheel', handleWheel)
  }
}, [])
```
</passive_listeners>

<idle_work>
Schedule non-critical work, such as analytics, saves to storage, or prefetches, with `requestIdleCallback()`. The main thread then stays free for input and animation. Pass a `timeout` when the work must run within a bound time. Do not defer work the user waits for. This search shows its results at once and defers the rest.

```typescript
function handleSearch(query: string) {
  const results = searchItems(query)
  setResults(results)

  requestIdleCallback(() => analytics.track('search'))
  requestIdleCallback(
    () => prefetchTopResults(results.slice(0, 3)),
    { timeout: 2000 }
  )
}
```

Use analytics only when the product already authorizes it. Keep raw searches and other free text out of telemetry and persistent storage unless the feature explicitly requires them and protects them.

A large job can run in chunks while `deadline.timeRemaining()` is above zero. It then schedules the next chunk. Check that the target browsers support `requestIdleCallback`, and fall back to `setTimeout` where they do not.
</idle_work>
</dom_and_events>

<storage>
Browser storage is synchronous and can throw. These rules keep reads cheap and stored data safe.

<cache_storage_reads>
`localStorage`, `sessionStorage`, and `document.cookie` read synchronously and slowly. Cache reads in a module-level `Map` and update the cache on every write. This cache works in utilities and event handlers, not only in components.

```typescript
const storageCache = new Map<string, string | null>()

function getLocalStorage(key: string) {
  if (!storageCache.has(key)) {
    storageCache.set(key, localStorage.getItem(key))
  }
  return storageCache.get(key)
}

function setLocalStorage(key: string, value: string) {
  localStorage.setItem(key, value)
  storageCache.set(key, value)
}

window.addEventListener('storage', (e) => {
  if (e.key) storageCache.delete(e.key)
})
```

Clear the cache when storage can change elsewhere. Another tab fires the `storage` event, and the server can set cookies.
</cache_storage_reads>

<versioned_storage>
Add a version to storage keys, store only the fields the UI needs, and wrap every call in `try`. Storage calls throw in some private browsing modes, when the quota is full, or when storage is off. Storing only needed fields also keeps tokens and personal data out of storage. These functions save and load a versioned config.

```typescript
const VERSION = 'v2'

function saveConfig(config: { theme: string; language: string }) {
  try {
    localStorage.setItem(`userConfig:${VERSION}`, JSON.stringify(config))
  } catch {
    return
  }
}

function loadConfig() {
  try {
    const data = localStorage.getItem(`userConfig:${VERSION}`)
    return data ? JSON.parse(data) : null
  } catch {
    return null
  }
}
```

When the schema changes, read the old key once, write the new shape, and remove the old key.
</versioned_storage>
</storage>

<hot_paths>
These micro-optimizations matter only in code that runs often, such as render loops, event handlers, or large data sets. Measure first, and keep the clearer form elsewhere.

<immutable_array_methods>
Use `toSorted()` instead of `sort()` on props and state. `sort()` mutates the array in place, and React treats props and state as read-only. This memo sorts a copy and leaves the prop unchanged.

```typescript
const sorted = useMemo(
  () => users.toSorted((a, b) => a.name.localeCompare(b.name)),
  [users]
)
```

`toReversed()`, `toSpliced()`, and `with()` are the immutable forms of `reverse()`, `splice()`, and index assignment. They are ES2023, Baseline since 2023, and in Node.js 20. For older targets, copy first, as in `[...items].sort(compare)`.
</immutable_array_methods>

<hoist_regexp>
Create a `RegExp` outside render, at module level, or memoize it on its inputs. Escape user input with `RegExp.escape()` where the targets support it. A global regex with the `g` flag keeps state in `lastIndex`. A shared instance then gives different results on repeated `test()` calls. This highlighter builds its regex only when the query changes.

```tsx
function Highlighter({ text, query }: Props) {
  const regex = useMemo(
    () => new RegExp(`(${RegExp.escape(query)})`, 'gi'),
    [query]
  )
  const parts = text.split(regex)
  return <>{parts.map((part, i) => <Part key={i} text={part} />)}</>
}
```
</hoist_regexp>
</hot_paths>
