# Set image to Postgres:15
FROM postgres:15

# Set env vars
ENV PGDATA /var/lib/postgresql/data
ENV POSTGRES_DB gova11y
ENV POSTGRES_USER deva11y
ENV POSTGRES_PASSWORD SuperSecura11y
ENV POSTGRES_PORT 5432
ENV TZ America/New_York

HEALTHCHECK --interval=2s --timeout=2s --retries=10 CMD pg_isready -U deva11y -h localhost
STOPSIGNAL SIGINT
EXPOSE $POSTGRES_PORT

# Copy the migration script
COPY scripts/* scripts/

# Copy migrations
COPY migrations/* /migrations

# Make the scripts executable
RUN chmod -R +x scripts/
RUN chmod -R +x migrations/

# Set the new startup script as the entrypoint
COPY scripts/startup.sh /docker-entrypoint-initdb.d/startup.sh
RUN chmod +x /docker-entrypoint-initdb.d/startup.sh

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE $POSTGRES_PORT
# Copy migrations
#COPY migrations/* /migrations

# Copy the migration script
#COPY scripts/* scripts/

# Make the scripts executable
#RUN chmod -R +x scripts/
#RUN chmod -R +x migrations/