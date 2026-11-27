---
name: designing-interfaces
description: Gives measurable limits and a design procedure for interfaces that look designed and work for every user, covering contrast, target size, type, spacing, states, forms, motion and speed. Use when building or changing a page, component, form, layout, styles or theme, or when asked for a design, redesign, landing page, dashboard or better look. Load before the first change to a page, a component, a form, a layout, styles or a theme.
---

# Designing interfaces

Build with the project's existing tokens, components, spacing scale, fonts and breakpoints, and add a new value only when none fits, so that a new screen matches its neighbours.

## When there is no design

Decide the direction before writing markup. Note what the product is, who uses it and three words for its character. Write five directions that fit the subject, each one sentence with a heading typeface, a palette and a layout idea, differing in all three. Draw a number from one to five with a shell command and build that direction, because a model that chooses for itself picks the same one in every run.

Keep one text typeface and at most one heading typeface with character, loaded as a web font with a system fallback, a spacing scale on one base unit, one accent with a neutral scale and one radius scale, all in CSS variables.

Name the model defaults you will avoid before building, and after the first render replace any that came back. The usual ones are Inter, Roboto or Arial everywhere, the system stack with Georgia headings, a purple gradient on white, cream or beige with a brown or terracotta accent, a centred hero over three identical rounded cards with a soft shadow, italic accent words, numbered section labels, monospace labels and pill buttons. A safe page that avoids all of these and still looks like any other page is a default too.

## Limits

Use at most three text sizes per view, with less space inside a group than between groups. Body text is at least 16 CSS pixels in regular weight or heavier, with a line height near 1.5 and lines under about 80 characters. A view has one primary button, two at most.

Text needs a contrast ratio of 4.5 to 1, large text 3 to 1, and control edges and meaningful parts of graphics 3 to 1. Carry a state or an error with text or an icon in addition to colour, and check every surface and text pair in both themes when there are two.

A target is at least 24 by 24 CSS pixels, 44 by 44 for touch. The page works at 320 CSS pixels wide without sideways scrolling and with text zoomed to 200 percent. Animate `transform` and `opacity`, and reduce motion under `prefers-reduced-motion`.

Aim for a largest contentful paint within 2.5 seconds, an interaction response within 200 milliseconds and a layout shift of 0.1 or less, which needs width and height on every image.

## States and forms

Controls have rest, hover, visible focus, active and disabled states, and icon-only buttons have an accessible name. Views that load data have loading, empty and error states, with the spinner or skeleton shown after a short delay so a fast response does not flash.

Put a visible label above each field, since a placeholder vanishes on input. Keep input text at 16 CSS pixels or more on phones so the browser does not zoom. Validate on submit, keep what the user typed, put the message next to the field with how to fix it, and allow paste.

## Check

Look at the page in a browser at 320 pixels and at desktop width, in both themes, with the keyboard alone and with reduced motion, and squint to see whether the most important element still stands out. Run Lighthouse or axe when installed and fix what they report, then still look, because they find only part of the problems.
