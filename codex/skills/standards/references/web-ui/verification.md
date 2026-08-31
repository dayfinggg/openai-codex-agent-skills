# Verification

- Run the project's formatter, linter, build, and focused tests, then inspect the final HTML and CSS diff.
- Validate HTML and CSS with the Nu Html Checker or the repository's equivalent conformance checker.
- Test with keyboard only from entry to completion, including menus, dialogs, errors, and dynamically inserted content.
- Check the accessibility tree for names, roles, values, landmarks, heading levels, descriptions, and live updates.
- Test at 200 percent text or page zoom, narrow reflow, long labels, large text, high contrast, forced colors, and reduced motion.
- Test loading and interaction on a throttled connection with empty and warm caches to expose shifts and blocking work.
- Test representative current engines and devices, and consult compatibility data before adopting a feature that lacks a safe fallback.
- Combine automated audits with manual review; automated tools cannot judge every label, reading order, interaction, or user expectation.
- Test meaningful states such as empty, loading, success, failure, disabled, selected, invalid, and permission-limited states.
- Use maintained W3C APG and MDN CSS examples as executable references, and keep validation or lint checks in CI where appropriate.
