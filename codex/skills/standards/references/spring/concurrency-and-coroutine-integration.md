# Concurrency and coroutine integration
- Choose Servlet-based blocking MVC, virtual-thread execution, or WebFlux and coroutines from the actual I/O model.
- Spring MVC asynchronous return values release the request thread, but response writes can remain blocking.
- Use WebFlux with non-blocking clients and drivers when the complete request path benefits from non-blocking I/O.
- Spring supports suspending controller methods and `Flow`; use the model consistently within a boundary.
- Do not assume a thread-bound imperative transaction follows work started on a new thread.
- Give `@Async` work an explicit bounded executor and configure context propagation when request context matters.
- Put unavoidable blocking calls on a deliberately chosen executor or dispatcher at the adapter boundary.
