-- Migration: 004
-- ------------------------------
-- Sitemaps
-- ------------------------------


CREATE TABLE targets.sitemaps (
  id bigserial NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  sitemap_url text NOT NULL,
  last_modified timestamptz NULL,
  change_frequency text NULL,
  priority float4 NULL,
  domain_id int4 NOT NULL,
  CONSTRAINT sitemaps_pk PRIMARY KEY (id),
  CONSTRAINT sitemaps_fk FOREIGN KEY (domain_id) REFERENCES targets.domains(id)
);
CREATE INDEX idx_sitemaps_domain_id ON targets.sitemaps USING btree (domain_id);

-- Table Triggers

create trigger sitemaps_updated_at_trigger after
update
    on
    targets.sitemaps for each row execute function toolbox.update_timestamp_on_change();
