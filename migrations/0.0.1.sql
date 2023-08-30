-- 0.0.1
-- Create initial schemas
CREATE SCHEMA toolbox;
CREATE SCHEMA targets;
CREATE SCHEMA results;
CREATE SCHEMA meta;
CREATE SCHEMA logs;

-- Setup Toolbox
CREATE SCHEMA toolbox;

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

CREATE TABLE toolbox.db_users (
  username VARCHAR PRIMARY KEY,
  role VARCHAR NOT NULL,
  last_login timestamptz
);

CREATE TABLE toolbox.backup_log (
  id SERIAL PRIMARY KEY,
  backup_date timestamptz NOT NULL,
  location VARCHAR NOT NULL,
  status VARCHAR NOT NULL
);



-- Create Users
-- API
CREATE USER api WITH PASSWORD 'vf7dQ2nvvY1v0PZkoarV';
-- Rabbit Hole
CREATE USER rabbit_hole WITH PASSWORD 'AhihYoyQJdiv1rUBa0KI';
-- Rabbit Farm
CREATE USER rabbit_farm WITH PASSWORD 'mxGl6CQgBN0fnAN2Q10B';
-- Admin/Processes
CREATE USER management WITH PASSWORD 'kJ1pgQ4a3cZavbhMFFdA';



-- Add API User to tables
GRANT USAGE ON SCHEMA targets, toolbox, results, meta, logs TO api;
GRANT SELECT ON ALL TABLES IN SCHEMA logs, meta, results, targets, toolbox TO api;
GRANT USAGE ON SCHEMA toolbox TO api;
ALTER ROLE api SET search_path TO toolbox, public;
COMMENT ON ROLE api IS 'API Access Role';
GRANT SELECT ON toolbox.db_version TO api;

