# Hotwire and browser behavior

- Start with server-rendered HTML and progressive enhancement before adding client-side state machinery.
- Use Turbo Drive for fast navigation, Turbo Frames for independently replaceable regions, and Turbo Streams for targeted updates.
- Reuse the same server-rendered partials for the initial page and subsequent Turbo updates.
- Provide an ordinary HTML redirect or render path when a Turbo-specific response is not required.
- Use `respond_to` to make HTML and Turbo Stream behavior explicit at the action boundary.
- Keep Turbo Stream actions small and predictable; use Stimulus controllers for behavior that is not a stream operation.
- Give replaceable elements stable DOM IDs and preserve focus, labels, errors, and keyboard behavior.
- Test the resulting HTML and important Turbo responses, not just that a controller branch executed.
- Prefer accessible semantics and progressive enhancement over JavaScript-only controls.
- Use a larger JavaScript framework only when the interaction model or team needs exceeds Hotwire's strengths.
