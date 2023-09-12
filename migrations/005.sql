-- Migration: 005
-- ------------------------------
-- Hasura
-- ------------------------------
-- Create the 'hasura' user with password 'SecretsOfHasura'
CREATE USER hasura WITH PASSWORD 'SecretsOfHasura';

-- Create the 'hasura'database
CREATE DATABASE hasura;

-- Grant all privileges on the 'hasura' and 'gova11y' databases to the 'hasura' user
GRANT ALL PRIVILEGES ON DATABASE hasura TO hasura;
GRANT ALL PRIVILEGES ON DATABASE gova11y TO hasura;

ALTER USER hasura WITH PASSWORD 'SecretsOfHasura';

-- ------------------------------
-- Add URLs & Sitemaps
-- ------------------------------
-- Insert GovA11y Homepage
INSERT INTO targets.urls (url, domain_id)
VALUES
('https://gova11y.io/', 1);

-- ------------------------------
-- Fix Sitemap Table
-- ------------------------------

-- Step 1: Add a new column to hold the foreign key to the targets.urls table
ALTER TABLE targets.sitemaps
ADD COLUMN IF NOT EXISTS url_id bigint;

-- Step 2: Add a foreign key constraint to establish the relationship between the two tables
ALTER TABLE targets.sitemaps
ADD CONSTRAINT sitemaps_fk_url
FOREIGN KEY (url_id) REFERENCES targets.urls(id);

-- Step 3: Creating an index on the new url_id column to speed up queries
CREATE INDEX IF NOT EXISTS idx_sitemaps_url_id ON targets.sitemaps USING btree (url_id);

-- Step 4: Data Migration: Mapping sitemap_url to url_id
WITH url_inserts AS (
    INSERT INTO targets.urls (url, domain_id)
    SELECT DISTINCT sitemap_url, domain_id FROM targets.sitemaps
    ON CONFLICT (url) DO NOTHING
    RETURNING id, url
)
UPDATE targets.sitemaps s
SET url_id = u.id
FROM url_inserts u
WHERE s.sitemap_url = u.url;


-- Step 5: Drop the sitemap_url column since we are using url_id
ALTER TABLE targets.sitemaps
DROP COLUMN sitemap_url;


-- ------------------------------
-- Create Sitemap Insertion Function
-- ------------------------------

CREATE OR REPLACE FUNCTION targets.insert_sitemap(
    sitemap_url TEXT,
    domain_id INT4,
    last_modified timestamptz DEFAULT NULL,
    change_frequency TEXT DEFAULT NULL,
    priority FLOAT4 DEFAULT NULL
)
RETURNS void LANGUAGE plpgsql AS $$
DECLARE
    url_id bigint;
BEGIN
    -- Step 1: Insert the URL into the targets.urls table and get the ID or do nothing if it already exists
    INSERT INTO targets.urls (url, domain_id)
    VALUES (sitemap_url, domain_id)
    ON CONFLICT (url)
    DO UPDATE
    SET url = excluded.url
    RETURNING id INTO url_id;

    -- Step 2: Insert a new record into the targets.sitemaps table with the ID of the URL and the other details
    INSERT INTO targets.sitemaps (url_id, domain_id, last_modified, change_frequency, priority)
    VALUES (url_id, domain_id, last_modified, change_frequency, priority)
    ON CONFLICT (url_id)
    DO NOTHING;
END $$;


-- Insert some of the GovA11y Sitemaps
SELECT targets.insert_sitemap('https://gova11y.io/sitemap-pages.xml', 1, '2023-09-12 22:32:00');
SELECT targets.insert_sitemap('https://gova11y.io/sitemap-authors.xml', 1, '2023-09-12 22:03:00');
SELECT targets.insert_sitemap('https://gova11y.io/sitemap-tags.xml', 1, '2023-09-08 04:37:00');



