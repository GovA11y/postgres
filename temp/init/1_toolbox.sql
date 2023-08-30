-- Create toolbox schema
CREATE SCHEMA toolbox;

-- Create tables
CREATE TABLE toolbox.schema_version (
  version VARCHAR PRIMARY KEY,
  release_date timestamptz NOT NULL,
  migration_date timestamptz NOT NULL
);

CREATE TABLE toolbox.migration_log (
  id SERIAL PRIMARY KEY,
  version VARCHAR NOT NULL,
  migration_date timestamptz NOT NULL,
  status VARCHAR NOT NULL,
  details TEXT
);

CREATE TABLE toolbox.configuration (
  parameter_name VARCHAR PRIMARY KEY,
  parameter_value VARCHAR NOT NULL,
  parameter_description VARCHAR NULL
);

CREATE TABLE toolbox.maintenance_schedule (
  task_name VARCHAR PRIMARY KEY,
  scheduled_date timestamptz NOT NULL,
  completion_date timestamptz,
  status VARCHAR NOT NULL
);

CREATE TABLE toolbox.audit_log (
  id SERIAL PRIMARY KEY,
  action VARCHAR NOT NULL,
  action_date timestamptz NOT NULL,
  details TEXT
);
