# Verified examples and maintainer guidance

Tokio's maintained example returns `Result` from `main`, uses `?`, and awaits an async TCP write without hiding failure.
Axum's maintained testing example exposes an app factory and tests the router directly without starting a server.
The standard library's maintained channel module documents ownership transfer, bounded versus unbounded channels, and disconnect errors.
Niko Matsakis's ownership talk illustrates ownership, borrowing, channels, locks, and safe abstractions as one design model.
