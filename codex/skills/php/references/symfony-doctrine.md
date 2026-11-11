<overview>
This file covers Doctrine ORM 3 and DBAL 4 in Symfony projects. It holds relations, fetching, read models, large datasets, transactions, multiple entity managers, and the ORM 3 removals. ORM 3.7 is the current release in November 2026, and DoctrineBundle 3.3 pairs with Symfony 7.4 and 8.x and requires PHP 8.4.
</overview>
<contents>
This file has these sections, in order.
- orm3 facts
- relations
- fetching
- large datasets
- transactions and locking
- multiple entity managers
- dbal4
</contents>


<orm3_facts>
ORM 3 and DBAL 4 removed APIs that older code and training data still use. Check `composer.lock` for `doctrine/orm` and `doctrine/dbal` before you write against either major.

| Old API | Status in ORM 3 or DBAL 4 | Use instead |
| --- | --- | --- |
| Annotation mapping | Removed in ORM 3.0 | PHP attributes such as `#[ORM\Entity]` |
| `Query::iterate()` | Removed in ORM 3.0 | `Query::toIterable()` |
| `EntityManager::transactional()` | Removed in ORM 3.0 | `wrapInTransaction()` |
| `EntityManager::merge()` | Throws on every call since ORM 3.0 | Load the entity and copy the changes |
| `getPartialReference()` and `NOTIFY` change tracking | Removed in ORM 3.0 | `getReference()` and `DEFERRED_EXPLICIT` |
| `PARTIAL` in DQL | Missing in 3.0 and 3.1, arrays only in 3.2, back for objects in 3.3 | `SELECT NEW` DTOs |
| `Tools\Pagination\Paginator` | Deprecated in ORM 3.7 | `OffsetPaginator` with a `Window` |
| DBAL `query()`, `exec()`, `fetchAll()` | Removed in DBAL 4 | `fetchAllAssociative()`, `executeQuery()`, `executeStatement()` |

On PHP 8.4, ORM 3.5 deprecates disabling native lazy objects, which replace generated proxy classes. DoctrineBundle 3.1 and later always enable them and deprecate the `enable_native_lazy_objects` option. With DBAL 4, the `AUTO` id strategy on PostgreSQL resolves to `IDENTITY` instead of a sequence.
</orm3_facts>

<relations>
<owning_side>
Doctrine writes only what the owning side holds. The owning side is the `ManyToOne` side, which holds the foreign key. Setting a relation only on the inverse `OneToMany` collection changes nothing in the database. The inverse side keeps both sides in sync in its `add` and `remove` methods.

```php
#[ORM\Entity]
class Product
{
    #[ORM\ManyToOne(inversedBy: 'products')]
    #[ORM\JoinColumn(nullable: false, onDelete: 'CASCADE')]
    private ?Category $category = null;

    public function setCategory(?Category $category): static
    {
        $this->category = $category;

        return $this;
    }
}
```

```php
#[ORM\Entity]
class Category
{
    /** @var Collection<int, Product> */
    #[ORM\OneToMany(targetEntity: Product::class, mappedBy: 'category', orphanRemoval: true)]
    private Collection $products;

    public function __construct()
    {
        $this->products = new ArrayCollection();
    }

    public function addProduct(Product $product): static
    {
        if (!$this->products->contains($product)) {
            $this->products->add($product);
            $product->setCategory($this);
        }

        return $this;
    }
}
```

ORM 3 infers `targetEntity` of a `ManyToOne` from the property type. A collection property still needs `targetEntity`.
</owning_side>

<cascade_and_orphans>
`cascade: ['persist']` saves new children together with the parent, which suits an aggregate root and its parts. `cascade: ['remove']` on a large collection loads and deletes each row one by one. Prefer `onDelete: 'CASCADE'` on the join column so the database deletes the rows. `orphanRemoval: true` deletes a child once it leaves the parent collection. Use it only for true composition, never for an entity that other parents share.
</cascade_and_orphans>

<large_collections>
On a normal `OneToMany`, `contains()`, `count()`, and `slice()` load the whole collection first. The `add` method above calls `contains()`, so it becomes slow on a collection with thousands of rows. Mark such a collection `fetch: 'EXTRA_LAZY'` so these calls run targeted SQL instead. Or check membership on the owning side, as in `$product->getCategory() === $category`.

```php
#[ORM\OneToMany(targetEntity: Comment::class, mappedBy: 'post', fetch: 'EXTRA_LAZY')]
private Collection $comments;
```
</large_collections>
</relations>

<fetching>
<n_plus_one>
Relations are `LAZY` by default, so each first access to a relation runs one query. A loop over 100 posts that reads `$post->getAuthor()` runs 101 queries. Load the relation in the same query with a fetch join in the repository. Prefer a fetch join per use case over `fetch: 'EAGER'` on the mapping, which loads the relation on every query.

```php
public function findPublishedWithAuthor(): array
{
    return $this->createQueryBuilder('p')
        ->addSelect('a')
        ->leftJoin('p.author', 'a')
        ->where('p.publishedAt IS NOT NULL')
        ->orderBy('p.publishedAt', 'DESC')
        ->getQuery()
        ->getResult();
}
```

A fetch join of a collection together with `setMaxResults()` limits joined rows, not entities. Paginate such a query with `OffsetPaginator(fetchJoinCollection: true)` on ORM 3.7, or with `Paginator` on older 3.x. The Symfony profiler and `doctrine:query:dql "<DQL>" --show-sql` show the real queries.
</n_plus_one>

<read_models>
For read-only lists, project the columns into a DTO with `SELECT NEW`. It works on every ORM 3 minor and avoids half-loaded entities. The result is a list of DTOs, not managed entities, so never modify or flush them. The `NEW` arguments match the constructor order.

```php
final readonly class PostListItem
{
    public function __construct(
        public int $id,
        public string $title,
        public string $authorName,
    ) {
    }
}
```

```php
/** @return list<PostListItem> */
public function findListItems(): array
{
    return $this->createQueryBuilder('p')
        ->select('NEW App\Dto\PostListItem(p.id, p.title, a.name)')
        ->leftJoin('p.author', 'a')
        ->getQuery()
        ->getResult();
}
```

For entities you read but never change, `->setHint(Query::HINT_READ_ONLY, true)` skips change tracking. `createQueryBuilder('p', 'p.id')` indexes the result array by id.
</read_models>
</fetching>

<large_datasets>
`findAll()` on a big table loads every entity into memory. Stream the rows with `toIterable()`, and flush and clear the entity manager in batches. `toIterable()` cannot stream a query that fetch-joins a collection.

```php
$query = $this->entityManager->createQuery('SELECT p FROM App\Entity\Product p');
$i = 0;

foreach ($query->toIterable() as $product) {
    $product->markProcessed();

    if (++$i % 100 === 0) {
        $this->entityManager->flush();
        $this->entityManager->clear();
    }
}

$this->entityManager->flush();
$this->entityManager->clear();
```

After `clear()`, every entity you loaded before is detached, so reload what you still need. For a long job that writes, paginate by id (`WHERE p.id > :lastId ORDER BY p.id`) instead of by offset. A mass change runs fastest as one DQL `UPDATE` or `DELETE`, or as DBAL `executeStatement()`. Such statements skip lifecycle events and do not update entities already in memory.
</large_datasets>

<transactions_and_locking>
Each `flush()` runs in its own transaction. Do one flush per operation, and wrap work that must commit together in `wrapInTransaction()`. It flushes, commits, and rolls back and closes the entity manager when the callback throws. A closed entity manager cannot be used again, so do not reuse its entities after a failure. Keep HTTP calls and mail outside the transaction.

```php
$order = $this->entityManager->wrapInTransaction(function (EntityManagerInterface $em) use ($input): Order {
    $order = Order::place($input);
    $em->persist($order);

    return $order;
});
```

For optimistic locking, add an `#[ORM\Version]` integer column. A concurrent change then throws `OptimisticLockException` at flush. For pessimistic locking, call `find($id, LockMode::PESSIMISTIC_WRITE)` inside a transaction and keep that transaction short.
</transactions_and_locking>

<multiple_entity_managers>
A relation cannot span two entity managers. Each manager owns its own entity directories through its `mappings` config. Inject a non-default manager by its service id, which makes the choice explicit.

```php
public function __construct(
    #[Autowire(service: 'doctrine.orm.customer_entity_manager')]
    private readonly EntityManagerInterface $customerEntityManager,
) {
}
```

Get a repository for a named manager with `$registry->getRepository(Customer::class, 'customer')`. An entity managed by more than one manager needs a repository that extends `EntityRepository`, not `ServiceEntityRepository`. Fetch that repository through `ManagerRegistry::getRepository()`. Console and migration commands take `--em=customer`.
</multiple_entity_managers>

<dbal4>
Raw SQL through DBAL 4 uses the method API with bound parameters. Never concatenate input into the SQL string.

```php
$rows = $connection->fetchAllAssociative('SELECT id, title FROM post WHERE status = ?', [$status]);
$row = $connection->fetchAssociative('SELECT * FROM post WHERE id = ?', [$id]);
$count = $connection->fetchOne('SELECT COUNT(*) FROM post');
$affected = $connection->executeStatement('UPDATE post SET status = ? WHERE status = ?', ['archived', 'draft']);
```
</dbal4>
