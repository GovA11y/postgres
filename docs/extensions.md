# Postgres Extensions

## PostGIS: Geo queries
PostGIS is a Postgres extension that allows you to interact with Geo data within Postgres. You can sort your data by geographic location, get data within certain geographic boundaries, and do much more with it.


[Official Docs](https://postgis.net/)

## pgRouting: Geospatial Routing
Extends the PostGIS functionality to provide geospatial routing functionality.


[Official Docs](https://pgrouting.org/)

## pgTAP
Database extension for writing TAP (Test Anything Protocol) compliant unit tests in psql scripts.


[Official Docs](https://pgtap.org/)

## pg_cron: Job Scheduling
Job scheduler for PostgreSQL, allowing scheduled tasks to be run at specific times.


[Official Docs](https://github.com/citusdata/pg_cron)

## PGAudit: Postgres Auditing
PGAudit is a PostgreSQL extension for logging session and object auditing over the standard PostgreSQL logging utility.

PGAudit grants fine grain control over which statements and objects are emitted to logs.


[Official Docs](https://www.pgaudit.org/)

## pgjwt: JSON Web Tokens
Implementation of JSON Web Tokens for PostgreSQL.


[Official Docs](https://github.com/michelp/pgjwt)

## pgsql-http
Provides the ability to make HTTP and HTTPS requests from PostgreSQL server programming functions.


[Official Docs]()

## plpgsql_check
Extension to check function validity in PL/pgSQL.


[Official Docs]()

## pg_safeupdate: Required Where Clauses
pg-safeupdate is a PostgreSQL extension designed to prevent users from accidentally updating or deleting too many records in a single statement by requiring a "where" clause in all update and delete statements.

The pg-safeupdate extension is a useful tool for protecting data integrity and preventing accidental data loss. Without it, a user could accidentally execute an update or delete statement that affects all records in a table. With pg-safeupdate, users are required to be more deliberate in their update and delete statements, which reduces the risk of significant error.


[Official Docs](https://github.com/eradman/pg-safeupdate)

## TimescaleDB: Time-Series data
An open-source time-series SQL database optimized for fast ingest and complex queries. It provides a scalable, high-performance solution for storing and querying time-series data on top of a standard PostgreSQL database.

TimescaleDB uses a time-series-aware storage model and indexing techniques to improve performance of PostgreSQL in working with time-series data. The extension divides data into chunks based on time intervals, allowing it to scale efficiently, especially for large data sets. The data is then compressed, optimized for write-heavy workloads, and partitioned for parallel processing. timescaledb also includes a set of functions, operators, and indexes that work with time-series data to reduce query times, and make data easier to work with.




[Official Docs](https://docs.timescale.com/use-timescale/latest/)

## wal2json
Output plugin for logical decoding to output replication changes as JSON.


[Official Docs]()

## PL/Java
Storing procedures and triggers written in Java.


[Official Docs]()

## PL/v8
Trusted JavaScript language extension for PostgreSQL.


[Official Docs]()

## pg_net
Provides network-related functions and data types.


[Official Docs]()

## RUM
Provides support for RUM (Rapidly Updatable Materialized views) index access method.


[Official Docs](https://github.com/postgrespro/rum)

## pg_hashids
Encode and decode big integers to and from short strings.


[Official Docs]()

## libsodium
Library for encryption, decryption, signatures, etc.


[Official Docs]()

## pgsodium
A PostgreSQL extension that adds crypto functions from libsodium.


[Official Docs]()

## pg-graphql
A GraphQL extension for PostgreSQL.


[Official Docs]()

## pg_stat_monitor
An advanced query monitoring extension.


[Official Docs]()

## pg_jsonschema
Validate JSON data against a schema.


[Official Docs]()

## Vault
A secure vault for storing and retrieving secrets within PostgreSQL.


[Official Docs]()

## Groonga
An open-source full-text search engine and column store.


[Official Docs]()

## pgroonga
A PostgreSQL extension for using Groonga as an index.


[Official Docs]()

## HypoPG
A PostgreSQL extension for creating hypothetical indexes.


[Official Docs]()

## pg_repack
Reorganizes tables in PostgreSQL databases with minimal locks.


[Official Docs]()

## pgvector
Vector similarities in PostgreSQL.


[Official Docs]()

## pg_tle
Two-Line Element set data type for PostgreSQL.


[Official Docs]()

## supautils
A collection of functions and tweaks to ease PostgreSQL administration.


[Official Docs]()

## wal-g
Archiving and restoration for PostgreSQL.


[Official Docs]()

