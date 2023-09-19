#!/bin/bash
# PostgreSQL Migration Script
# scripts/migrate.sh

echo "Beginning Migration..."
MIGRATIONS_DIR="/docker-entrypoint-initdb.d/migrations/"

# Check if the gova11y database exists, and if not, create it
db_exists=$(psql -U ${POSTGRES_USER} -tAc "SELECT 1 FROM pg_database WHERE datname='gova11y'")

if [[ "$db_exists" != "1" ]]; then
    createdb -U ${POSTGRES_USER} gova11y
    if [ $? -ne 0 ]; then
        echo "Error creating gova11y database."
        exit 1
    fi
fi

# Connect to the gova11y database
export PGPASSWORD="${POSTGRES_PASSWORD}"
export PGUSER="${POSTGRES_USER}"
export PGDATABASE='gova11y'

# Check if the toolbox schema exists, and if not, create it
schema_exists=$(psql -tAc "SELECT 1 FROM information_schema.schemata WHERE schema_name='toolbox'")

if [[ "$schema_exists" != "1" ]]; then
    psql -c "CREATE SCHEMA toolbox;"
    if [ $? -ne 0 ]; then
        echo "Error creating toolbox schema."
        exit 1
    fi
fi

# Check if the migrations table exists in toolbox schema, and if not, create it
table_exists=$(psql -tAc "SELECT 1 FROM information_schema.tables WHERE table_schema='toolbox' AND table_name='migrations'")

if [[ "$table_exists" != "1" ]]; then
    psql -c "
        CREATE TABLE toolbox.migrations
        (
            migration_name TEXT,
            applied_at TIMESTAMPTZ DEFAULT now()
        );"
    if [ $? -ne 0 ]; then
        echo "Error creating migrations table."
        exit 1
    fi
fi

# Loop through migration scripts in order
for migration in $(ls $MIGRATIONS_DIR | sort); do
    # Check if the migration has been applied already
    applied=$(psql -tAc "SELECT 1 FROM toolbox.migrations WHERE migration_name='$migration'")
    if [[ "$applied" != "1" ]]; then
        echo "Processing migration file: $migration"
        psql -a -f "$MIGRATIONS_DIR/$migration"
        if [ $? -ne 0 ]; then
            echo "Error applying migration $migration"
            exit 1
        else
            echo "Applied migration $migration"
            psql -c "INSERT INTO toolbox.migrations (migration_name) VALUES ('$migration')"
            if [ $? -ne 0 ]; then
                echo "Error recording migration $migration"
                exit 1
            fi
        fi
    else
        echo "Migration $migration already applied, skipping"
    fi
done
