# Set image to Postgres:15
FROM postgres:15

# Set env vars
ENV PGDATA /var/lib/postgresql/data
ENV POSTGRES_DB gova11y
ENV POSTGRES_USER deva11y
ENV POSTGRES_PASSWORD SuperSecura11y
ENV POSTGRES_PORT 5432
ENV TZ	America/New_York

HEALTHCHECK --interval=2s --timeout=2s --retries=10 CMD pg_isready -U deva11y -h localhost
STOPSIGNAL SIGINT
EXPOSE $POSTGRES_PORT

# ENTRYPOINT ["scripts/startup.sh"]
# Copy migrations
#COPY migrations/* /migrations

# Copy the migration script
#COPY scripts/* scripts/

# Make the scripts executable
#RUN chmod -R +x scripts/
#RUN chmod -R +x migrations/