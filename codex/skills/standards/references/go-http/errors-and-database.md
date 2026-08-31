# Errors and database

- Add operation context with %w when callers should inspect an underlying error.
- Use errors.Is for stable categories and errors.As for typed details across wrapping.
- Define domain errors for not found, conflict, invalid input, forbidden, and dependency failure when callers need stable categories.
- Map domain errors to HTTP statuses only at the transport boundary.
- Keep internal details in logs and expose short, stable client messages.
- Open one long-lived *sql.DB per database and share it safely across handlers.
- Pass request-derived contexts to QueryContext, ExecContext, QueryRowContext, and BeginTx.
- Use placeholders and driver arguments; never assemble SQL with fmt.Sprintf or concatenation.
- Map sql.ErrNoRows to a domain not-found result.
- Close Rows on every path and check Rows.Err after iteration.
- Run all operations that must be atomic through sql.Tx and do not call sql.DB methods inside that transaction.
- Tune pool limits from observed database capacity and monitor DB.Stats.
- Use a short PingContext for readiness, not for every application request.
