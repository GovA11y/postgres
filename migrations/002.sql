-- Migration: 002
-- ------------------------------
-- Functions
-- ------------------------------

-- Auto updated_at
CREATE OR REPLACE FUNCTION toolbox.update_timestamp_on_change()
RETURNS trigger
LANGUAGE plpgsql
AS $function$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$function$;


-- ------------------------------
-- Targets Schema
-- ------------------------------
CREATE SCHEMA targets;

-- Domains Table
CREATE TABLE
  targets.domains (
    id serial4 NOT NULL,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    "domain" text NOT NULL CHECK ("domain" = LOWER("domain")),
    description text NULL,
    org_id int4 NULL,
    active bool NOT NULL DEFAULT true,
    valid bool NOT NULL DEFAULT true,
    home_url text NULL,
    CONSTRAINT domains_pk_id PRIMARY KEY (id),
    CONSTRAINT domains_un UNIQUE (domain)
  );
CREATE INDEX
  domains_org_id_idx ON targets.domains USING btree (org_id);
create trigger
  domains_updated_at_trigger AFTER update
  on targets.domains for each row
execute
  function toolbox.update_timestamp_on_change ();

INSERT INTO targets.domains (domain, active, org_id, valid, description)
  VALUES ('gova11y.io', true, 1, true, 'GovA11y Homesite');

-- ------------------------------
-- Add Comments
-- ------------------------------

-- Table Comment
COMMENT ON TABLE targets.domains IS 'A table to store information about various domains, including their validity, activity status, and associated organization.';

-- Column Comments
COMMENT ON COLUMN targets.domains.id IS 'Unique identifier for each domain entry.';
COMMENT ON COLUMN targets.domains.created_at IS 'Timestamp indicating when the domain entry was first added to the table.';
COMMENT ON COLUMN targets.domains.updated_at IS 'Timestamp indicating the last update made to the domain entry.';
COMMENT ON COLUMN targets.domains.domain IS 'The domain name, stored in lowercase. The check constraint ensures that the domain is saved in lowercase.';
COMMENT ON COLUMN targets.domains.description IS 'Optional description providing additional information or context about the domain.';
COMMENT ON COLUMN targets.domains.org_id IS 'Identifier of the organization associated with the domain. A NULL value indicates no associated organization.';
COMMENT ON COLUMN targets.domains.active IS 'Boolean flag indicating if the domain is currently active. True means active, while false indicates inactivity.';
COMMENT ON COLUMN targets.domains.valid IS 'Boolean flag indicating if the domain is a valid and recognized domain. True means valid, while false indicates invalidity.';
COMMENT ON COLUMN targets.domains.home_url IS 'Optional URL pointing to the homepage or main page of the domain.';

-- Trigger Comment
-- This comment assumes the trigger's purpose is only to update the "updated_at" column.
-- Adjust the comment if the trigger has other side effects or behaviors.
COMMENT ON TRIGGER domains_updated_at_trigger ON targets.domains IS 'Trigger to automatically update the "updated_at" timestamp whenever a domain entry is modified.';



-- ------------------------------
-- URLs Table
-- ------------------------------
