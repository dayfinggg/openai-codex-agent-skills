# Avoid relational imitation and unbounded documents
Do not translate every relational table into a collection and every foreign key into an array by reflex.
Do not add `$lookup` chains where a measured embedded or denormalized read model is simpler.
Do not embed all related data when only a small subset is read together.
Do not grow arrays without a bound, because updates rewrite the document and indexes multiply keys.
Use subset, bucket, outlier, or parent-reference patterns to bound growth.
Split large or independently accessed fields into separate documents or collections.
Prefer a smaller document that matches the hot read path over a bloated “everything” document.
Treat duplicated fields as a consistency contract with an owner, update path, and staleness budget.
The [unbounded-array anti-pattern](https://www.mongodb.com/docs/manual/data-modeling/design-antipatterns/unbounded-arrays/) shows subset and reference remedies.
