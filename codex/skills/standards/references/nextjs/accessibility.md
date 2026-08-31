# Accessibility

- Use semantic HTML and native controls before adding ARIA; a native button carries keyboard behavior that a clickable `div` does not. [Next.js accessibility](https://nextjs.org/docs/architecture/accessibility)
- Give every form control an accessible name through a visible label or a correctly associated `htmlFor` and `id`.
- Provide meaningful image alternatives, clear headings, landmarks, and descriptive link text in route output.
- Ensure custom controls are reachable and operable with keyboard focus, visible focus indicators, and expected key bindings.
- Manage focus when dialogs, menus, conditional content, and client navigation would otherwise disorient users.
- Give each route a unique descriptive title and useful first heading because Next.js uses them for route announcements. [Next.js accessibility](https://nextjs.org/docs/architecture/accessibility)
- Expose validation, loading, status, and server errors to assistive technology instead of relying only on color, motion, or position.
- Check color contrast and honor `prefers-reduced-motion` for animated route and loading states.
- Use ARIA patterns only with the keyboard behavior and state semantics required by the pattern. [WAI-ARIA APG](https://www.w3.org/WAI/ARIA/apg/)
- Run `eslint-plugin-jsx-a11y`, keyboard checks, and representative screen-reader flows; automated lint is not proof of usable interaction.
