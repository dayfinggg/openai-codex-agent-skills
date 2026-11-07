<react_rendering>
Extra renders and slow commits make the UI feel sluggish. These rules reduce wasted work in components, hooks, and effects. When React Compiler is on, skip the rules that only add manual memoization. The `react` section of the skill explains why.

<no_inline_components>
Never define a component inside another component. Each render then creates a new component type, so React unmounts the old instance and mounts a new one. The inner component loses its state, reruns its effects, and rebuilds its DOM. Typical symptoms are inputs that lose focus on each keystroke, animations that restart, and scroll positions that reset. In this version, `Avatar` and `Stats` remount on every render of `UserProfile`.

```tsx
function UserProfile({ user, theme }) {
  const Avatar = () => (
    <img
      src={user.avatarUrl}
      className={theme === 'dark' ? 'avatar-dark' : 'avatar-light'}
    />
  )

  const Stats = () => (
    <div>
      <span>{user.followers} followers</span>
      <span>{user.posts} posts</span>
    </div>
  )

  return (
    <div>
      <Avatar />
      <Stats />
    </div>
  )
}
```

This version defines them at module level and passes props.

```tsx
function Avatar({ src, theme }: { src: string; theme: string }) {
  return (
    <img
      src={src}
      className={theme === 'dark' ? 'avatar-dark' : 'avatar-light'}
    />
  )
}

function Stats({ followers, posts }: { followers: number; posts: number }) {
  return (
    <div>
      <span>{followers} followers</span>
      <span>{posts} posts</span>
    </div>
  )
}

function UserProfile({ user, theme }) {
  return (
    <div>
      <Avatar src={user.avatarUrl} theme={theme} />
      <Stats followers={user.followers} posts={user.posts} />
    </div>
  )
}
```
</no_inline_components>

<derive_state_during_render>
Compute a value from current props and state during render. Do not store it in state and sync it in an effect. The effect version renders twice and can drift out of sync. To reset state when a prop changes, give the component a new `key`. This version keeps a redundant `fullName` state.

```tsx
function Form() {
  const [firstName, setFirstName] = useState('First')
  const [lastName, setLastName] = useState('Last')
  const [fullName, setFullName] = useState('')

  useEffect(() => {
    setFullName(firstName + ' ' + lastName)
  }, [firstName, lastName])

  return <p>{fullName}</p>
}
```

This version derives it.

```tsx
function Form() {
  const [firstName, setFirstName] = useState('First')
  const [lastName, setLastName] = useState('Last')
  const fullName = firstName + ' ' + lastName

  return <p>{fullName}</p>
}
```

React's guide [You Might Not Need an Effect](https://react.dev/learn/you-might-not-need-an-effect) covers more cases.
</derive_state_during_render>

<events_in_handlers>
Run a side effect caused by a user action, such as a submit or a click, in that event handler. Modeling the action as state plus an effect reruns the effect on unrelated changes and can repeat the action. In this version, a theme change can send the registration again.

```tsx
function Form() {
  const [submitted, setSubmitted] = useState(false)
  const theme = useContext(ThemeContext)

  useEffect(() => {
    if (submitted) {
      post('/api/register')
      showToast('Registered', theme)
    }
  }, [submitted, theme])

  return <button onClick={() => setSubmitted(true)}>Submit</button>
}
```

This version does the work in the handler.

```tsx
function Form() {
  const theme = useContext(ThemeContext)

  function handleSubmit() {
    post('/api/register')
    showToast('Registered', theme)
  }

  return <button onClick={handleSubmit}>Submit</button>
}
```
</events_in_handlers>

<effect_events>
`useEffectEvent` is stable since React 19.2. It reads the latest props and state in an effect without making them dependencies. Never list the Effect Event in the dependency array, because its identity changes on every render. Keep the real reactive values as dependencies.

Declare the Effect Event in the same component or hook as its effect. Use it only for logic that is an event fired from the effect. This effect reconnects only when `roomId` changes, while `onConnected` always sees the latest props.

```tsx
import { useEffect, useEffectEvent } from 'react'

function ChatRoom({ roomId, onConnected }: {
  roomId: string
  onConnected: () => void
}) {
  const handleConnected = useEffectEvent(onConnected)

  useEffect(() => {
    const connection = createConnection(roomId)
    connection.on('connected', handleConnected)
    connection.connect()

    return () => connection.disconnect()
  }, [roomId])
}
```

`useEffectEvent` replaces the older pattern of storing the latest handler in a ref. Use the current `eslint-plugin-react-hooks`, so the linter does not ask to add Effect Events as dependencies.
</effect_events>

<functional_set_state>
Use the functional form of a state setter when the new state depends on the old one. It always sees the latest state, so the callback needs no state dependency and cannot hold a stale value. In this version, `addItems` changes identity whenever `items` changes, and `removeItem` reads the stale initial `items`.

```tsx
function TodoList() {
  const [items, setItems] = useState(initialItems)

  const addItems = useCallback((newItems: Item[]) => {
    setItems([...items, ...newItems])
  }, [items])

  const removeItem = useCallback((id: string) => {
    setItems(items.filter(item => item.id !== id))
  }, [])

  return <ItemsEditor items={items} onAdd={addItems} onRemove={removeItem} />
}
```

This version has stable callbacks and no stale state.

```tsx
function TodoList() {
  const [items, setItems] = useState(initialItems)

  const addItems = useCallback((newItems: Item[]) => {
    setItems(curr => [...curr, ...newItems])
  }, [])

  const removeItem = useCallback((id: string) => {
    setItems(curr => curr.filter(item => item.id !== id))
  }, [])

  return <ItemsEditor items={items} onAdd={addItems} onRemove={removeItem} />
}
```

A direct value is fine when the new state does not depend on the old one, as in `setCount(0)`. The functional form stays correct with React Compiler too.
</functional_set_state>

<lazy_state_init>
Pass a function to `useState` when the initial value is expensive. A direct call runs on every render, although React uses the result only once. This version parses storage on every render.

```tsx
function UserProfile() {
  const [settings, setSettings] = useState(
    JSON.parse(localStorage.getItem('settings') || '{}')
  )

  return <SettingsForm settings={settings} onChange={setSettings} />
}
```

This version parses it only on the first render.

```tsx
function UserProfile() {
  const [settings, setSettings] = useState(() => {
    const stored = localStorage.getItem('settings')
    return stored ? JSON.parse(stored) : {}
  })

  return <SettingsForm settings={settings} onChange={setSettings} />
}
```

Use the function form for storage reads, index or map building, DOM reads, and heavy transformations. A primitive or a cheap literal needs no function.
</lazy_state_init>

<narrow_dependencies>
Depend on the narrowest value an effect uses. An effect that reads `user.id` should depend on `user.id`, not on `user`. When an effect reacts to a threshold, compute the boolean first and depend on it. This effect runs only when `isMobile` flips, not on every width change.

```tsx
const isMobile = width < 768
useEffect(() => {
  if (isMobile) {
    enableMobileMode()
  }
}, [isMobile])
```

The same idea applies to subscriptions. Subscribe to a derived boolean, such as `useMediaQuery('(max-width: 767px)')`, instead of a continuous value like the window width.
</narrow_dependencies>

<split_independent_work>
Split a hook that does independent tasks with different dependencies. One combined hook reruns every task when any dependency changes. These two memos recompute the filter only when the products or the category change.

```tsx
const filteredProducts = useMemo(
  () => products.filter((p) => p.category === category),
  [products, category]
)

const sortedProducts = useMemo(
  () =>
    filteredProducts.toSorted((a, b) =>
      sortOrder === "asc" ? a.price - b.price : b.price - a.price
    ),
  [filteredProducts, sortOrder]
)
```

The same holds for effects. Track a page view and set the document title in two effects, each with its own dependency.
</split_independent_work>

<defer_reads>
Do not subscribe to changing state that only a callback reads. Read it inside the callback instead. This button reads the search parameters on click, so URL changes do not re-render it.

```tsx
function ShareButton({ chatId }: { chatId: string }) {
  const handleShare = () => {
    const params = new URLSearchParams(window.location.search)
    shareChat(chatId, { ref: params.get('ref') })
  }

  return <button onClick={handleShare}>Share</button>
}
```
</defer_reads>

<refs_for_transient_values>
Keep a value that changes often and does not affect the rendered output in `useRef`, not in state. Updating a ref does not re-render. This tracker moves the dot through the DOM node without a render per mouse move.

```tsx
function Tracker() {
  const lastXRef = useRef(0)
  const dotRef = useRef<HTMLDivElement>(null)

  useEffect(() => {
    const onMove = (e: MouseEvent) => {
      lastXRef.current = e.clientX
      const node = dotRef.current
      if (node) {
        node.style.transform = `translateX(${e.clientX}px)`
      }
    }
    window.addEventListener('mousemove', onMove)
    return () => window.removeEventListener('mousemove', onMove)
  }, [])

  return <div ref={dotRef} className="tracker-dot" />
}
```
</refs_for_transient_values>

<transitions>
Mark non-urgent updates as transitions, so urgent input stays responsive. Wrap frequent updates, such as scroll position, in `startTransition`. Use `useTransition` instead of a manual loading flag, because its `isPending` resets even when the work throws. A newer transition also supersedes a pending one. This search updates the input at once and the results inside a transition.

```tsx
import { useTransition, useState } from 'react'

function SearchResults() {
  const [query, setQuery] = useState('')
  const [results, setResults] = useState([])
  const [isPending, startTransition] = useTransition()

  const handleSearch = (value: string) => {
    setQuery(value)
    startTransition(async () => {
      const data = await fetchResults(value)
      startTransition(() => setResults(data))
    })
  }

  return (
    <>
      <input value={query} onChange={(e) => handleSearch(e.target.value)} />
      {isPending && <Spinner />}
      <ResultsList results={results} />
    </>
  )
}
```

A state update after an `await` inside an async transition needs its own `startTransition` call, as the [useTransition docs](https://react.dev/reference/react/useTransition) explain.
</transitions>

<deferred_value>
Use `useDeferredValue` when input drives an expensive render, such as filtering a large list or redrawing a chart. The deferred value lags behind the input, so React renders the input first. Memoize the expensive work on the deferred value, or it still runs on every render. This search keeps the input responsive and dims stale results.

```tsx
function Search({ items }: { items: Item[] }) {
  const [query, setQuery] = useState('')
  const deferredQuery = useDeferredValue(query)
  const filtered = useMemo(
    () => items.filter(item => fuzzyMatch(item, deferredQuery)),
    [items, deferredQuery]
  )
  const isStale = query !== deferredQuery

  return (
    <>
      <input value={query} onChange={e => setQuery(e.target.value)} />
      <div style={{ opacity: isStale ? 0.7 : 1 }}>
        <ResultsList results={filtered} />
      </div>
    </>
  )
}
```

With React Compiler on, the compiler memoizes the filter, so plain code without `useMemo` works.
</deferred_value>

<manual_memoization>
These rules apply only to projects without React Compiler. Move expensive work into a component wrapped in `memo`, so an early return in the parent skips it. In this version, the avatar computes even while the profile is loading.

```tsx
function Profile({ user, loading }: Props) {
  const avatar = useMemo(() => {
    const id = computeAvatarId(user)
    return <Avatar id={id} />
  }, [user])

  if (loading) return <Skeleton />
  return <div>{avatar}</div>
}
```

This version skips the computation while loading.

```tsx
const UserAvatar = memo(function UserAvatar({ user }: { user: User }) {
  const id = useMemo(() => computeAvatarId(user), [user])
  return <Avatar id={id} />
})

function Profile({ user, loading }: Props) {
  if (loading) return <Skeleton />
  return (
    <div>
      <UserAvatar user={user} />
    </div>
  )
}
```

A default object, array, or function prop breaks the memoization of a `memo` component. Each render creates a new default value. Hoist the default to a module constant, such as `const NOOP = () => {}`. Do not wrap a simple expression with a primitive result in `useMemo`, because the hook costs more than the expression.
</manual_memoization>

<activity>
Wrap an expensive component that toggles often in `<Activity>`, stable since React 19.2. The `hidden` mode keeps its state and DOM, unmounts its effects, and defers its updates. This dropdown keeps its menu alive while closed.

```tsx
import { Activity } from 'react'

function Dropdown({ isOpen }: Props) {
  return (
    <Activity mode={isOpen ? 'visible' : 'hidden'}>
      <ExpensiveMenu />
    </Activity>
  )
}
```
</activity>

<conditional_rendering>
Use a ternary or an explicit comparison when a condition can be `0` or `NaN`, because `&&` renders those values. With `count` at 0, this badge renders the text "0".

```tsx
function Badge({ count }: { count: number }) {
  return <div>{count && <span className="badge">{count}</span>}</div>
}
```

This badge renders nothing at 0.

```tsx
function Badge({ count }: { count: number }) {
  return <div>{count > 0 ? <span className="badge">{count}</span> : null}</div>
}
```
</conditional_rendering>

<hydration_without_flicker>
Content that depends on client storage, such as a theme, breaks server rendering when read during render. Reading it in an effect causes a flash of the default value after hydration. An inline script that sets the DOM before hydration avoids both problems. This wrapper applies the stored theme before React hydrates.

```tsx
function ThemeWrapper({ children }: { children: ReactNode }) {
  return (
    <>
      <div id="theme-wrapper">{children}</div>
      <script
        dangerouslySetInnerHTML={{
          __html: `
            (function() {
              try {
                var theme = localStorage.getItem('theme') || 'light';
                var el = document.getElementById('theme-wrapper');
                if (el) el.className = theme;
              } catch (e) {}
            })();
          `,
        }}
      />
    </>
  )
}
```

The script text must be a constant. Never interpolate user data into it, because that creates an XSS hole. Some values must differ between server and client, such as a local time. Put `suppressHydrationWarning` on the element that holds such a value. Use it only for expected mismatches, not to hide real bugs. In React 19.3, `use(browser())` from `react-dom` renders a component only on the client, behind the nearest Suspense fallback.
</hydration_without_flicker>

<app_init_once>
Do not run app-wide initialization in a component's `useEffect` with empty dependencies. Components remount, and Strict Mode runs effects twice in development. Put the call in the entry module, or guard it with a module-level flag.

```tsx
let didInit = false

function App() {
  useEffect(() => {
    if (didInit) return
    didInit = true
    loadFromStorage()
    checkAuthToken()
  }, [])

  return <Main />
}
```
</app_init_once>

<client_data_fetching>
Fetch shared client data through the data library the project already uses, such as SWR or TanStack Query. These libraries deduplicate requests across components and cache and revalidate the result. A plain `fetch` in each component's effect sends one request per instance. With SWR, all instances of this list share one request.

```tsx
import useSWR from 'swr'

function UserList() {
  const { data: users } = useSWR('/api/users', fetcher)
  return <List items={users} />
}
```

SWR also exports `useSWRImmutable` from `swr/immutable` for data that never changes, and `useSWRMutation` from `swr/mutation` for writes. If the project has no such library, do not add one unless the user asks.
</client_data_fetching>
</react_rendering>
