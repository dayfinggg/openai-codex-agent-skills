---
name: designing-interfaces
description: Gives rules for interfaces that look designed and work for every user, with measurable limits for contrast, target size, type, spacing, states, forms, motion and page speed. Use when building or changing a page, a component, a form, a layout, styles or a theme, when the user asks for a design, a redesign, a landing page, a dashboard or a better look, and before reporting visual work as done. Load before the first change to a page, a component, a form, a layout, styles or a theme.
---

# Designing interfaces

An interface is done when it fits the product it belongs to, works with a keyboard and on a small screen, and was looked at in a browser.

## Fit what exists

Read the existing styles first. Use the project's tokens, components, spacing scale, fonts and breakpoints, and add a new value only when none of them fits. A new screen in an existing product looks like the screens next to it.

## When there is no design

Take the direction from the subject, and decide it before you write markup. Note what the product is, who uses it and three words for its character. List five directions that all fit the subject, each in one sentence with a heading typeface, a palette and a layout idea, and make them differ from one another in all three. Then draw a random number from one to five with a shell command and build the direction with that number. A model that chooses for itself picks the same direction in every run, and the draw is what makes two pages differ.

Pick one typeface for text and at most one for headings, a spacing scale built on one base unit, one accent colour with a neutral scale, and one corner radius scale, and keep them in CSS variables. Choose a heading typeface with character that suits the subject. When the page may load from the network, load it as a web font with a system fallback.

Models fall back on the same defaults, and readers recognise them. Name the ones you will avoid before you build. The usual ones are Inter, Roboto or Arial for everything, the system font stack with Georgia headings, a purple gradient on white, a cream or beige background with a brown or terracotta accent, a centred hero above three identical rounded cards with a soft shadow, italic accent words, numbered section labels, monospace labels and pill-shaped buttons. A safe choice that avoids every item on this list and still looks like any other page is also a default. After the first render, check which defaults came back, and replace them.

## Layout and type

Show hierarchy with size, weight and space, and use at most three text sizes in one view. Space inside a group is smaller than the space between groups. Keep a line of text under about 80 characters. Body text is at least 16 CSS pixels, with a line height near 1.5. Avoid thin and light font weights for text. Give a view one primary button, or two at most.

## Colour and contrast

Text needs a contrast ratio of at least 4.5 to 1 against its background, and large text needs 3 to 1. The edges of controls and the parts of a graphic that carry meaning need 3 to 1. Never let colour alone carry a state or an error. Pair each surface colour with a text colour and check both in the light and in the dark theme. Support `prefers-color-scheme` when the product has two themes.

## States

Every control has a rest, hover, focus, active and disabled state, and the focus state is visible for keyboard use. Every view that loads data has a loading, an empty and an error state. Show a spinner or a skeleton only after a short delay, so that a fast response does not flash. An icon-only button has an accessible name.

## Forms

Use one column, with a visible label above each field. A placeholder is not a label. Size a field for the input it expects, and keep input text at 16 CSS pixels or more on phones, so that the browser does not zoom. Validate on submit, keep what the user typed, and put the message next to the field. A message says what went wrong and how to fix it. Do not block paste.

## Touch, motion and screens

A target is at least 24 by 24 CSS pixels, and 44 by 44 for touch. The page works at a width of 320 CSS pixels with no sideways scrolling, and it still works when the user zooms text to 200 percent. Animate `transform` and `opacity`, give motion a purpose, and reduce it under `prefers-reduced-motion`. Use semantic elements such as `button`, `a`, `label` and headings in order before any ARIA attribute.

## Speed

Give images a width and a height so that the layout does not shift, load images below the fold lazily, and avoid layout changes after the first paint. The targets are a largest contentful paint within 2.5 seconds, an interaction response within 200 milliseconds and a layout shift score of 0.1 or less.

## Check

Open the page in a browser and look at it. Check it at 320 pixels and at desktop width, in both themes, with the keyboard alone, and with reduced motion. Squint at it and see whether the most important element still stands out. Run Lighthouse or axe when they are installed, and fix what they report. Automated checks find only part of the problems, so they do not replace looking.

## Related skills

Load `clean-code` for the code of the interface, and `verifying-work` before you report.
