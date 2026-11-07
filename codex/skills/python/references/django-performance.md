<overview>
This file is a method for reviewing Django code for validated performance issues. It covers Django 5.2 LTS, 6.0, and 6.1, and Django REST framework (DRF). Research the codebase to confirm each issue before you report it, and report only what you can prove. This file is a modified version of Sentry's django-perf-review skill under Apache-2.0, and `credits.md` lists the changes.
</overview>

<review_approach>
The review follows four principles.
1. Research first. Trace the data flow, check for existing optimizations, and verify the data volume.
2. Validate before you report. Pattern matching is not validation.
3. Zero findings is an acceptable result. Do not manufacture issues to look thorough.
4. Severity matches impact. If a critical finding needs the word "minor" in its description, it is not critical. Downgrade it or skip it.
</review_approach>

<impact_categories>
Issues are grouped by impact. Focus on critical and high issues, because they cause real problems at scale.

| Priority | Category | Severity | Impact |
|----------|----------|----------|--------|
| 1 | N+1 queries | Critical | Multiplies with data and causes timeouts |
| 2 | Unbounded querysets | Critical | Exhausts memory and causes OOM kills |
| 3 | Missing indexes | High | Full table scans on large tables |
| 4 | Write loops | High | Lock contention and slow requests |
| 5 | Inefficient patterns | Low | Rarely worth a report |
</impact_categories>

<n_plus_one>
Each N+1 adds `O(n)` database round trips. With 100 rows that is 100 extra queries, and with 10,000 rows the request times out.

<prefetch_in_loops>
Prefetch related data that a loop accesses. Validate by tracing the path from view to queryset to template or serializer to the access inside the loop. This view runs one extra query for each user.

```python
def user_list(request):
    users = User.objects.all()
    return render(request, "users.html", {"users": users})
```

The template reads the profile of each user inside the loop.

```django
{% for user in users %}
    {{ user.profile.bio }}
{% endfor %}
```

This view fetches the profiles in the same query.

```python
def user_list(request):
    users = User.objects.select_related("profile")
    return render(request, "users.html", {"users": users})
```

On Django 6.1 and later, `fetch_mode(models.FETCH_PEERS)` on the queryset also reduces the loop to two queries. Check the installed Django version before you suggest it.
</prefetch_in_loops>

<prefetch_for_serializers>
DRF serializers that access related fields cause N+1 when the viewset queryset is not optimized. This `SerializerMethodField` runs one query for each user.

```python
class UserSerializer(serializers.ModelSerializer):
    order_count = serializers.SerializerMethodField()

    def get_order_count(self, obj):
        return obj.orders.count()
```

This version annotates the count in the viewset and reads it in the serializer.

```python
class UserViewSet(viewsets.ModelViewSet):
    def get_queryset(self):
        return User.objects.annotate(order_count=Count("orders"))


class UserSerializer(serializers.ModelSerializer):
    order_count = serializers.IntegerField(read_only=True)
```
</prefetch_for_serializers>

<querying_properties>
A model property that runs a query causes N+1 when a template loop reads it. This property queries on every access.

```python
class User(models.Model):
    @property
    def recent_orders(self):
        return self.orders.filter(created__gte=last_week)[:5]
```

Fix it with `Prefetch` and a custom queryset, or with an annotation.
</querying_properties>

<n_plus_one_checklist>
Confirm each item before you report an N+1.
- You traced the data flow from the view to the template or serializer.
- The related field is accessed inside a loop.
- You searched the codebase for an existing `select_related`, `prefetch_related`, or fetch mode.
- The table has a significant row count, such as 1000 rows or more.
- The code is a hot path, not the admin or a rare action.
</n_plus_one_checklist>
</n_plus_one>

<unbounded_querysets>
Loading an entire table exhausts memory. Large tables cause OOM kills and worker restarts.

<paginate_lists>
Paginate list endpoints. This view loads every row.

```python
class UserListView(ListView):
    model = User
    template_name = "users.html"
```

This view loads one page of 25 rows.

```python
class UserListView(ListView):
    model = User
    template_name = "users.html"
    paginate_by = 25
```
</paginate_lists>

<iterate_large_batches>
Use `iterator()` for large batch processing. This loop loads all objects into memory at once.

```python
for user in User.objects.all():
    process(user)
```

This loop streams the rows in chunks.

```python
for user in User.objects.iterator(chunk_size=1000):
    process(user)
```
</iterate_large_batches>

<avoid_list_on_unbounded>
Do not call `list()` on an unbounded queryset. This call forces the full result into memory.

```python
all_users = list(User.objects.all())
```

This version keeps a queryset and slices it.

```python
users = User.objects.all()[:100]
```
</avoid_list_on_unbounded>

<unbounded_checklist>
Confirm each item before you report an unbounded queryset.
- The table is large (10k rows or more) or grows without bound.
- No pagination class, `paginate_by`, or slice limits the result.
- The code runs on a user-facing request, not in a background job that chunks.
</unbounded_checklist>
</unbounded_querysets>

<missing_indexes>
A missing index causes a full table scan. The cost is negligible on small tables and severe on large ones.

<index_filter_fields>
Index fields that large tables filter on. A filter such as `User.objects.filter(email=email)` scans the whole table when `email` has no index.

```python
class User(models.Model):
    email = models.EmailField()
```

This field has an index.

```python
class User(models.Model):
    email = models.EmailField(db_index=True)
```
</index_filter_fields>

<index_sort_fields>
Index fields that large tables sort on. This query needs a full scan without an index on `created`.

```python
Order.objects.order_by("-created")
```

This model indexes the sort field.

```python
class Order(models.Model):
    created = models.DateTimeField(db_index=True)
```
</index_sort_fields>

<composite_indexes>
Use composite indexes for common query patterns. In this model, the first index serves `filter(user=x, status=y)`. The second serves `filter(status=x).order_by("-created")`.

```python
class Order(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    status = models.CharField(max_length=20)
    created = models.DateTimeField()

    class Meta:
        indexes = [
            models.Index(fields=["user", "status"]),
            models.Index(fields=["status", "-created"]),
        ]
```
</composite_indexes>

<index_checklist>
Confirm each item before you report a missing index.
- The table has 10k rows or more.
- The field is used in `filter()` or `order_by()` on a hot path.
- The model has no `db_index=True` or `Meta.indexes` entry for it.
- The field is not a foreign key, because Django indexes foreign keys automatically.
</index_checklist>
</missing_indexes>

<write_loops>
A write loop sends N database writes instead of one. It causes lock contention and slow requests.

<bulk_create>
Use `bulk_create()` instead of `create()` in a loop. This loop sends one insert per item.

```python
for item in items:
    Model.objects.create(name=item["name"])
```

This call sends a single bulk insert.

```python
Model.objects.bulk_create([Model(name=item["name"]) for item in items])
```
</bulk_create>

<bulk_update>
Use `update()` or `bulk_update()` instead of `save()` in a loop. This loop sends one update per object.

```python
for obj in queryset:
    obj.status = "done"
    obj.save()
```

When every row gets the same value, a single `UPDATE` statement does the work.

```python
queryset.update(status="done")
```

When the values differ, `bulk_update()` sends them in batches.

```python
for obj in objects:
    obj.status = compute_status(obj)
Model.objects.bulk_update(objects, ["status"], batch_size=500)
```
</bulk_update>

<bulk_delete>
Call `delete()` on the queryset, not inside a loop. This loop sends one delete per object.

```python
for obj in queryset:
    obj.delete()
```

This call sends a single delete.

```python
queryset.delete()
```
</bulk_delete>

<write_loop_checklist>
Confirm each item before you report a write loop.
- The loop runs over 100 items or more, or over an unbounded set.
- Each iteration calls `create()`, `save()`, or `delete()`.
- The code runs on a user-facing request, not in a one-time migration script.
</write_loop_checklist>
</write_loops>

<inefficient_patterns>
These patterns are rarely worth a report. Mention them only as minor notes next to real issues.

<count_versus_exists>
`queryset.exists()` is marginally faster than `queryset.count() > 0`. Usually skip this, because the difference is under 1 ms in most cases.

```python
if queryset.count() > 0:
    do_thing()

if queryset.exists():
    do_thing()
```
</count_versus_exists>

<len_versus_count>
`len(queryset)` fetches every row to count them, and `count()` runs a single `COUNT` query. Flag it only when the queryset is large and not yet evaluated.

```python
if len(queryset) > 0:
    do_thing()

if queryset.count() > 0:
    do_thing()
```
</len_versus_count>

<get_in_small_loops>
`get()` in a loop runs N queries, but a small N (under 20) is often fine. Flag it only when the loop is large or the path is very hot.

```python
for id in ids:
    obj = Model.objects.get(id=id)
```
</get_in_small_loops>
</inefficient_patterns>

<validation_requirements>
Complete every step before you report an issue. If you cannot validate all steps, do not report it.
1. Trace the data flow, and follow the queryset from creation to consumption.
2. Search for existing optimizations, such as `select_related`, `prefetch_related`, and pagination.
3. Verify the data volume, and check that the table is actually large.
4. Confirm the hot path, and trace the call sites to see that this code runs often.
5. Rule out mitigations, such as caching and rate limiting.
</validation_requirements>

<output_format>
The report follows the output style, so it uses plain paragraphs. It opens with the count of validated issues by severity, such as "Two validated issues, one critical and one high." Each finding then gets one short paragraph and its code.
- The first sentence names the issue, the severity, and the location, as in "N+1 query in `UserListView` at `views.py:45` (critical)."
- The next sentences give the validation evidence. Name the traced path, the search for existing optimizations, the table size, and why the path is hot.
- A code block shows the current code, and a second code block shows the fix.

This fix for the example finding adds the missing `select_related`.

```python
def get_queryset(self):
    return User.objects.filter(active=True).select_related("profile")
```

When you find no issues, say which files you reviewed and what you validated.

Check each finding once more before you submit. Remove it if the severity does not match the impact. Remove it if it is a style preference and not a performance issue. Remove it if the fix would not measurably improve performance.
</output_format>

<what_not_to_report>
Leave these out of a performance review.
- Test files.
- Admin-only views.
- Management commands.
- Migration files.
- One-time scripts.
- Code behind disabled feature flags.
- Tables with fewer than 1000 rows that will not grow.
- Patterns in cold paths that rarely run.
- Micro-optimizations without evidence, such as `exists()` versus `count()` or `only()` and `defer()`.
</what_not_to_report>

<false_positives>
<queryset_assignment>
Assigning a queryset to a variable is not an issue. Querysets are lazy, so the assignment runs nothing. These two forms perform the same.

```python
projects_qs = Project.objects.filter(org=org)
projects = list(projects_qs)

projects = list(Project.objects.filter(org=org))
```
</queryset_assignment>

<single_query>
A single query is not N+1. N+1 needs a loop that triggers additional queries, so one `list()` call on a filtered queryset is fine.

```python
projects = list(Project.objects.filter(org=org))
```
</single_query>

<single_object_fetch>
A missing `select_related` on a single object fetch is not N+1. This code runs two queries instead of one.

```python
state = AutofixState.objects.filter(pr_id=pr_id).first()
project_id = state.request.project_id
```

Report it as low at most, and only if relevant. Never report it as critical or high, because N+1 needs a loop.
</single_object_fetch>

<style_preferences>
Style preferences are not performance issues. If the only suggestion is to combine two lines or rename a variable, do not report it.
</style_preferences>
</false_positives>
