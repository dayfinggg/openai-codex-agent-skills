# Planning example

This example is illustrative. The task was "add export of orders to CSV" in a Django and React project.

## Contents

- What exploration settled
- First round of questions
- Agreed plan

## What exploration settled

- Orders already have a filtered list endpoint at `orders/views.py::OrderListView` with filters by date and status.
- The project uses Celery for background jobs and stores files in S3 through `core/storage.py`.
- Admin pages already export users to CSV with `csv.writer` in `users/admin_export.py`, which is the pattern to reuse.
- Tests run with `pytest`, the frontend with `npm test`.

## First round of questions

The first round holds three independent questions.

1. **Who uses the export?**
   - Staff in the admin panel (Recommended). Smallest change, reuses the admin export pattern.
   - Customers for their own orders. Needs per-customer authorization and a UI in the customer app.
   - Both. Roughly twice the work.

2. **How large can one export get?**
   - Up to about 10,000 rows, generated during the request (Recommended). Simple and fast to build.
   - Any size, generated in the background with a download link. Needs a Celery task, storage, and a notification.

3. **Which columns?**
   - The columns shown in the orders list (Recommended). Matches what staff already see.
   - Every order field including line items. One row per line item, larger files.

Decided without asking, and listed as assumptions. UTF-8 with a byte order mark so Excel opens it correctly, ISO dates, and the same filters as the list view.

## Agreed plan

```markdown
## Goal
Staff can download the currently filtered order list as a CSV file from the admin panel.

## Decisions
- Staff only, in the admin panel, reusing the users export pattern
- Synchronous generation, capped at 10,000 rows with a clear message above the cap
- Columns from the orders list view
- Assumption: UTF-8 with BOM, ISO 8601 dates, existing list filters apply

## Approach
A streaming response writes rows from the same filtered queryset the list view uses.

## Changes
- orders/admin_export.py: new export function with csv.writer and StreamingHttpResponse
- orders/admin.py: "Export CSV" action on the changelist
- orders/tests/test_admin_export.py: tests for columns, filters, the row cap, and permissions

## Out of scope
Customer-facing export, background generation, XLSX format.

## Risks
Large querysets could be slow, handled by the row cap and iterator() to avoid loading all rows.

## Steps
1. Write tests for the export function, then implement it
2. Add the admin action and a permission test
3. Run pytest and try the export manually with filters

## Verification
pytest orders passes, and an export from the admin with a status filter contains only matching orders.
```

After approval the implementation follows the steps, and the final report shows the test output and the manual check.
