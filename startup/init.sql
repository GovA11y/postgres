-- Init Script for GovA11y

-- Create a new database named "hasura"
CREATE DATABASE hasura;

-- Create Hasura user
CREATE USER hasura WITH PASSWORD 'SecretsOfHasura';

-- Grant all privileges on the "hasura" database to the user "hasura"
GRANT ALL PRIVILEGES ON DATABASE hasura TO hasura;

-- Create GovA11y
CREATE DATABASE gova11y;

GRANT ALL PRIVILEGES ON DATABASE gova11y TO hasura;

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



