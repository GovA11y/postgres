# Set image to Postgres:15
FROM postgres:15

# Set env vars
ENV PGDATA /var/lib/postgresql/data
ENV POSTGRES_PORT 5432
ENV TZ	America/New_York

# Copy init.sql script into the docker-entrypoint-initdb.d directory
COPY startup/init.sql /docker-entrypoint-initdb.d/

# Copy custom configuration files to the container
COPY config/pg_hba.conf /etc/postgresql/
COPY config/pg_ident.conf /etc/postgresql/
COPY config/postgresql.conf /etc/postgresql/

HEALTHCHECK --interval=2s --timeout=2s --retries=10 CMD pg_isready -U postgres -h localhost
STOPSIGNAL SIGINT
EXPOSE $POSTGRES_PORT
