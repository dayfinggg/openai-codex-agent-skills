# Performance

- Measure the user path before optimizing; use browser traces, network waterfalls, and real-user data rather than intuition.
- Keep the DOM, critical CSS, selector work, and shipped assets proportional to the page's actual needs.
- Remember that stylesheets can block first render; remove unused CSS, split genuinely route-specific CSS, and avoid oversized critical styles.
- Avoid unnecessary layout work and layout thrashing; batch DOM reads separately from writes and profile before choosing a workaround.
- Reserve image and media space with intrinsic dimensions or aspect ratios to reduce layout shifts.
- Prefer CSS and native HTML for simple visual states; do not add a dependency or client-side abstraction for a trivial platform feature.
- Do not apply `will-change`, forced layers, or compositor-oriented tricks globally; verify the cost and benefit in a trace.
- Load noncritical resources only when they are needed, but do not lazy-load content required for the initial user-visible result.
- Treat Lighthouse and DevTools as diagnostic tools, and use field data or RUM to judge real-world Core Web Vitals.
- Use browser-engineer guidance as a hypothesis, then confirm the cost in the target browser with a trace.
