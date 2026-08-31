# Accessibility

- Start with semantic HTML and native controls because their keyboard and assistive-technology behavior is already defined.
- Give every form control a programmatic label and every meaningful image useful alternative text.
- Use Angular attribute bindings for dynamic ARIA values, and prefer native semantics over adding a role that duplicates them.
- Manage focus, keyboard interaction, disabled states, and announcements as part of the component contract.
- Use Angular CDK `a11y` utilities for focus trapping and live announcements when implementing custom widgets.
- Use Angular Aria for headless WAI-ARIA patterns when custom styling is needed, or Angular Material for styled components.
- Test keyboard-only flows, focus order, zoom or reflow, screen-reader names, and error announcements with real browsers.
- Wrap observable deferred state in an appropriate live region when a screen reader must hear placeholder-to-content changes.
