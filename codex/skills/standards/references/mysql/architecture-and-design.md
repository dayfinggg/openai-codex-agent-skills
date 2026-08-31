# Architecture and design

- MySQL runs as a separate, multithreaded `mysqld` server that manages a data directory and accepts client connections. [M2]
- Clients can use TCP/IP, Unix sockets, named pipes, or shared memory according to platform and configuration. [M21]
- Treat the server, its data directory, its configuration, and its clients as separately operated components. [M2] [M1]
- InnoDB is the default MySQL storage engine in 9.7 and is the normal choice for transactional application tables. [M3]
- InnoDB uses a clustered primary-key index and provides ACID DML, crash recovery, MVCC, row locks, and foreign keys. [M3]
- A nontransactional engine does not gain InnoDB rollback or atomicity because a transaction is open. [M6]
- Mixing transactional and nontransactional tables can leave only the transactional portion rolled back after an error. [M6]
- Choose stable, narrow primary keys because the clustered key organizes InnoDB table data and is carried by secondary indexes. [M3]
- Normalize entities and relationships first, then denormalize only for a measured workload or a clear read model.
- Put ownership, nullability, uniqueness, and lifecycle rules in schema constraints instead of duplicating them only in application code.
