-- startup/init.sql
-- Create initial schemas

-- Setup Toolbox
CREATE SCHEMA toolbox;

CREATE TABLE toolbox.migration_log (
    id serial4 NOT NULL,
    "version" varchar NOT NULL,
    migration_date timestamptz NOT NULL,
    status varchar NOT NULL,
    details text NULL,
    CONSTRAINT migration_log_pkey PRIMARY KEY (id)
);

CREATE TABLE toolbox."configuration" (
    parameter_name varchar NOT NULL,
    parameter_value varchar NOT NULL,
    parameter_description varchar NULL,
    CONSTRAINT configuration_pkey PRIMARY KEY (parameter_name)
);

CREATE TABLE toolbox.maintenance_schedule (
    task_name varchar NOT NULL,
    scheduled_date timestamptz NOT NULL,
    completion_date timestamptz NULL,
    status varchar NOT NULL,
    CONSTRAINT maintenance_schedule_pkey PRIMARY KEY (task_name)
);

CREATE TABLE toolbox.audit_log (
    id serial4 NOT NULL,
    "action" varchar NOT NULL,
    action_date timestamptz NOT NULL,
    details text NULL,
    CONSTRAINT audit_log_pkey PRIMARY KEY (id)
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

CREATE TABLE toolbox.db_version (
    "version" varchar NOT NULL,
    release_date timestamptz NOT NULL,
    migration_date timestamptz NOT NULL,
    CONSTRAINT db_version_pkey PRIMARY KEY (version)
);




-- Create other schemas
CREATE SCHEMA targets;
CREATE SCHEMA results;
CREATE SCHEMA meta;
CREATE SCHEMA logs;

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