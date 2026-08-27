# Visual verification

Read this reference before completing any rendered UI change or visual review.

## Stabilize the render

- Use the real application or the narrowest faithful route. Load representative content for each affected state.
- Fix viewport, device scale factor, browser, color scheme, locale, time, animation, and data when producing comparable screenshots.
- Wait for `document.fonts.ready`, images, and essential asynchronous content. Do not capture a transient fallback font or half-loaded layout as the final design.
- Disable only genuinely volatile content for comparison. Never hide a layout defect, missing state, or unstable component to make a screenshot pass.

## Capture the evidence

- Capture at least one representative desktop viewport and one mobile viewport. Add the narrowest supported width, widest content width, and both sides of structural breakpoints when responsive behavior changed.
- Capture the full page and focused crops for the first screen, navigation, forms, dense tables or dashboards, overlays, and every affected empty, loading, error, success, permission, and expanded state.
- For each captured state, verify the visible DOM matches the state model. Count or inspect rendered items so an empty, loading, error, or permission message cannot contradict content still displayed by CSS.
- Use the same environment for baseline and comparison screenshots. Review every baseline update as a design decision.
- Open each screenshot at full resolution. A successful browser command or image file is not visual inspection.

## Measure the DOM

For each key anchor, record `getBoundingClientRect()` and relevant computed styles. Measure:

- viewport and document `clientWidth`, `scrollWidth`, `clientHeight`, and `scrollHeight`
- main container left, right, and width
- grid columns, gutters, page margins, and repeated alignment edges
- headers, controls, rows, cards when justified, charts, dialogs, and fixed or sticky regions
- computed `font-family`, loaded font status, font size, weight, line height, letter spacing, and text wrapping
- margin, padding, gap, border width, radius, and repeated vertical baselines
- target width and height, focus indicator bounds, clipped content, and elements outside the viewport

Fail the visual check when page-level horizontal overflow is unintended, important content is clipped or overlapped, fixed controls hide content, text truncates without a recovery path, or a repeated alignment drifts visibly.

## Add pixel guides and overlays

Create at least one annotated copy of a desktop or mobile screenshot outside production assets for every implemented interface. For a small component change, the overlay may focus on that component and its alignment context.

1. Draw vertical guides at viewport edges, content-container edges, column boundaries, centers, and repeated left or right alignment anchors.
2. Draw horizontal guides through repeated control tops, text baselines, row boundaries, and aligned panel edges.
3. Outline measured component bounds and label important widths, heights, gutters, and gaps.
4. Use thin, high-contrast guide colors that remain distinct from the interface. Keep the unannotated screenshot beside the overlay.
5. Compare the overlay to the intended grid and spacing scale. Correct systematic drift in layout rules rather than applying isolated pixel offsets to each component.

## Inspect in priority order

1. Confirm content order, primary action, first-screen usefulness, and major responsive structure.
2. Correct overflow, clipping, overlap, wrong fonts, broken states, and inaccessible focus or targets.
3. Correct container width, columns, alignment, wrapping, density, and large spacing errors.
4. Refine type rhythm, small gaps, borders, radii, icons, and optical alignment.
5. Re-render all representative viewports and states after structural changes.

Do not stop because the page looks acceptable at one width. Stop when the desktop and mobile screenshots, geometry measurements, overlays where needed, and state checks agree with the intended art direction and no observed defect remains.
