# UI examples (web)

These examples are illustrative. Adapt names and values to the project's design system.

## Contents

- Tokens as CSS custom properties
- Button with all states
- Accessible form field
- Empty state

## Tokens as CSS custom properties

```css
:root {
  --color-background: #ffffff;
  --color-surface: #f5f6f8;
  --color-text-primary: #111827;
  --color-text-secondary: #4b5563;
  --color-border: #6b7280;
  --color-action: #1d4ed8;
  --color-action-hover: #1e40af;
  --color-on-action: #ffffff;
  --color-danger: #b91c1c;
  --color-focus: #1d4ed8;

  --space-1: 0.25rem;
  --space-2: 0.5rem;
  --space-3: 0.75rem;
  --space-4: 1rem;
  --space-6: 1.5rem;
  --space-8: 2rem;

  --font-body: system-ui, -apple-system, "Segoe UI", Roboto, sans-serif;
  --text-sm: 0.875rem;
  --text-md: 1rem;
  --text-lg: 1.25rem;
  --text-xl: 1.5rem;

  --radius-md: 0.5rem;
  --duration-fast: 150ms;
}

@media (prefers-color-scheme: dark) {
  :root {
    --color-background: #0f1115;
    --color-surface: #1a1d24;
    --color-text-primary: #f3f4f6;
    --color-text-secondary: #c4c9d2;
    --color-border: #9ca3af;
    --color-action: #93b4ff;
    --color-action-hover: #b4cbff;
    --color-on-action: #0f1115;
    --color-danger: #fca5a5;
    --color-focus: #93b4ff;
  }
}

@media (prefers-reduced-motion: reduce) {
  :root {
    --duration-fast: 0ms;
  }
}
```

Every text and background pair in both themes meets at least 4.5:1 contrast. Check new pairs with a contrast tool.

## Button with all states

```html
<button class="button button--primary" type="button">Save changes</button>
```

```css
.button {
  min-height: 2.75rem;
  padding: var(--space-2) var(--space-4);
  border: 1px solid transparent;
  border-radius: var(--radius-md);
  font: 600 var(--text-md) / 1.25 var(--font-body);
  cursor: pointer;
  transition: background-color var(--duration-fast) ease-out;
}

.button--primary {
  background: var(--color-action);
  color: var(--color-on-action);
}

.button--primary:hover {
  background: var(--color-action-hover);
}

.button:focus-visible {
  outline: 3px solid var(--color-focus);
  outline-offset: 2px;
}

.button:active {
  transform: translateY(1px);
}

.button:disabled,
.button[aria-busy="true"] {
  opacity: 0.6;
  cursor: not-allowed;
}
```

The button is 44 pixels tall, has a visible focus ring for keyboard users only, and its label names the result.

## Accessible form field

```html
<div class="field">
  <label for="email">Email</label>
  <p id="email-hint" class="field__hint">We send the receipt here.</p>
  <input
    id="email"
    name="email"
    type="email"
    autocomplete="email"
    required
    aria-describedby="email-hint email-error"
    aria-invalid="true"
  />
  <p id="email-error" class="field__error">Enter an email address like name@example.com.</p>
</div>
```

```css
.field {
  display: grid;
  gap: var(--space-1);
}

.field input {
  min-height: 2.75rem;
  padding: var(--space-2) var(--space-3);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-md);
  font: var(--text-md) / 1.5 var(--font-body);
}

.field input:focus-visible {
  outline: 3px solid var(--color-focus);
  outline-offset: 1px;
}

.field input[aria-invalid="true"] {
  border-color: var(--color-danger);
}

.field__hint {
  color: var(--color-text-secondary);
  font-size: var(--text-sm);
}

.field__error {
  color: var(--color-danger);
  font-size: var(--text-sm);
}
```

The label is always visible, the hint and error are read by screen readers, and the error says how to fix the input rather than only that it is wrong. Render the error paragraph and `aria-invalid` only when validation fails.

## Empty state

```html
<section class="empty-state" aria-labelledby="empty-title">
  <h2 id="empty-title">No projects yet</h2>
  <p>Projects keep your files and team in one place.</p>
  <button class="button button--primary" type="button">Create project</button>
</section>
```

An empty screen explains what belongs there and offers the one action that fills it.
