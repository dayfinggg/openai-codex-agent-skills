# Router and server

- Start with a private http.ServeMux and an explicit http.Server.
- Avoid DefaultServeMux and package-global registration because they hide route ownership and complicate tests.
- On Go 1.22 and later, use method-aware and wildcard-aware ServeMux patterns when they express the contract clearly.
- Treat route registration as startup configuration because invalid or conflicting patterns panic during registration.
- Use one router per server and expose its http.Handler to the server constructor.
- Use method-specific routes and make 404 and 405 behavior explicit.
- Keep route patterns stable enough to use as metric and log dimensions.
- Configure ReadHeaderTimeout, ReadTimeout where appropriate, WriteTimeout, IdleTimeout, and MaxHeaderBytes for the deployment and endpoint mix.
- Give each slow dependency a narrower context deadline than the overall request budget.
- Serve production traffic over HTTPS with managed certificates and a reviewed TLS policy.
- Keep crypto/tls defaults unless compatibility or compliance requires an explicit change.
- Never use InsecureSkipVerify in production.
- Start the server in a goroutine only when the lifecycle owner waits for it and observes startup errors.
- On shutdown, stop accepting work, call Server.Shutdown with a deadline, wait for owned workers, then close databases and clients.
- Handle hijacked connections such as WebSockets separately because Server.Shutdown does not wait for them.
