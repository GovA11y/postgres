-- Init Script for GovA11y



-- Setup Healthcheck user
CREATE USER postgres;

-- Init Script for GovA11y

-- Setup Healthcheck user
CREATE USER healthchecker;

-- Setup Bytebase
CREATE ROLE bytebase SUPERUSER CREATEDB CREATEROLE INHERIT LOGIN REPLICATION BYPASSRLS PASSWORD 'SecretsOfBytebase';
CREATE DATABASE bytebase;
GRANT ALL PRIVILEGES ON DATABASE bytebase TO bytebase;

-- Create a new database named "hasura"
CREATE DATABASE hasura;

-- Setup permissions for healthchecker on hasura
GRANT CONNECT ON DATABASE hasura TO healthchecker;
GRANT USAGE ON SCHEMA public TO healthchecker;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO healthchecker;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO healthchecker;

-- Create Hasura user
CREATE USER hasura WITH PASSWORD 'SecretsOfHasura';
GRANT ALL PRIVILEGES ON DATABASE hasura TO hasura;

-- Create GovA11y
CREATE DATABASE gova11y;
GRANT ALL PRIVILEGES ON DATABASE gova11y TO hasura;
GRANT ALL PRIVILEGES ON DATABASE gova11y TO bytebase;

-- Toolbox
CREATE SCHEMA toolbox;

-- Toolbox Functions
-- Auto updated_at
CREATE OR REPLACE FUNCTION toolbox.update_updated_at()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
                        BEGIN
                          NEW.updated_at = NOW();
                          RETURN NEW;
                        END;
                        $function$
;



-- Create Targets
CREATE SCHEMA targets;

-- targets.orgs
CREATE TABLE targets.orgs (
  id serial4 NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  name varchar NULL,
  "type" varchar NULL,
  acronym varchar NULL,
  description varchar NULL,
  active bool NOT NULL DEFAULT false,
  CONSTRAINT orgs_un UNIQUE (name),
  CONSTRAINT orgs_pk_id PRIMARY KEY (id)
);
CREATE INDEX orgs_acronym_idx ON targets.orgs USING btree (acronym);
CREATE INDEX orgs_name_idx ON targets.orgs USING btree (name);

create trigger orgs_update_trigger before
update
    on
    targets.orgs for each row execute function toolbox.update_updated_at();




