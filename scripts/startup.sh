#!/bin/bash
# scripts/startup.sh

# Get the current version from the database
current_version=$(psql -U myuser -d mydb -c "SELECT version FROM toolbox.db_version;")

# Get the latest version from the migrations folder
latest_version=$(ls -v /migrations/*.sql | tail -n1 | sed 's/.*\///; s/\.[^.]*$//')

# Compare the current version with the latest version
if [[ $current_version == "" ]] || ! [[ $current_version =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || [[ $current_version != $latest_version ]]; then

  # Loop through the migration files and run each one incrementally
  for migration_file in $(ls -v /migrations/*.sql); do
    migration_version=$(basename "$migration_file" | sed 's/.*\///; s/\.[^.]*$//')

    # Skip migrations that have already been applied or version is less than current_version
    if [[ $migration_version > $current_version && $migration_version <= $latest_version ]]; then
      echo "Applying migration: $migration_version"
      psql -U myuser -d mydb -f "$migration_file"
      psql -U myuser -d mydb -c "INSERT INTO toolbox.migration_log (version, migration_date, status) VALUES ('$migration_version', NOW(), 'Success');"
      echo "Migration applied: $migration_version"
    fi
  done

  # Update foreign keys and relations
  psql -U myuser -d mydb -f "/migrations/update_foreign_keys_relations.sql"

  # Update the current version in the database
  if [[ $current_version == "" ]] || ! [[ $current_version =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    psql -U myuser -d mydb -c "INSERT INTO toolbox.db_version (version, release_date, migration_date) VALUES ('$latest_version', NOW(), NOW());"
  else
    psql -U myuser -d mydb -c "UPDATE toolbox.db_version SET version = '$latest_version', migration_date = NOW() WHERE version = '$current_version';"
  fi

  echo "All migrations have been applied. Latest version: $latest_version"
fi

# Start the PostgreSQL server
exec "$@"