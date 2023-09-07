-- Migration: 003
-- ------------------------------
-- Create URLs Table
-- ------------------------------

-- Create the URLs table to store the target URLs and related worker statuses, histories, and results.
CREATE TABLE targets.urls (
  -- Basic information
  id bigserial PRIMARY KEY,
  created_at timestamptz NOT NULL DEFAULT now(), -- When the URL was added
  updated_at timestamptz NOT NULL DEFAULT now(), -- Last update time
  url text NOT NULL,                             -- The actual URL
  domain_id int4 NOT NULL,                       -- Foreign key to a domains table
  -- Worker Statuses: indicates if a worker/task is enabled for a particular URL
  worker_status jsonb DEFAULT
  '{
     "uppies": true,
     "crawl": true,
     "axe": true,
     "tech": true,
     "complexity": true
  }'::jsonb,
  -- Worker History: records the first and most recent runs of each worker
  worker_history jsonb DEFAULT
  '{
       "uppies": {
            "first_run": null,
            "recent_run": null
        },
       "crawl": {
           "first_run": null,
           "recent_run": null
       },
       "axe": {
           "first_run": null,
           "recent_run": null
       },
       "tech": {
           "first_run": null,
           "recent_run": null
       },
       "complexity": {
           "first_run": null,
           "recent_run": null
       }
  }'::jsonb,
  -- Worker Queued At: potentially to record when each worker is queued to run next
  worker_queued_at jsonb DEFAULT
  '{
     "uppies": null,
     "crawl": null,
     "axe": null,
     "tech": null,
     "complexity": null
  }'::jsonb,
  -- Summary: aggregated results or metadata from worker outputs
  summary jsonb DEFAULT '{"http_code":null,"content_type":null,"response_time":null,"page_complexity":null}'::jsonb,
  -- Link to discovery crawl, if applicable
  discovery_crawl_id bigint NULL,
  -- Constraints: ensure uniqueness and set foreign key relations
  CONSTRAINT urls_un_url UNIQUE (url),
  CONSTRAINT urls_fk_domain FOREIGN KEY (domain_id) REFERENCES targets.domains(id)
);

-- Comments
COMMENT ON COLUMN targets.urls.id IS 'ID of URL';
COMMENT ON COLUMN targets.urls.created_at IS 'When the URL was added';
COMMENT ON COLUMN targets.urls.updated_at IS 'Last update time';
COMMENT ON COLUMN targets.urls.url IS 'Target URL';
COMMENT ON COLUMN targets.urls.domain_id IS 'Matched domain to domain ID';
COMMENT ON COLUMN targets.urls.worker_status IS 'Flags indicating if a worker/task is enabled for a particular URL';
COMMENT ON COLUMN targets.urls.worker_history IS 'Records the first and most recent runs of each worker';
COMMENT ON COLUMN targets.urls.worker_queued_at IS 'Timestamps indicating when each worker is queued to run next';
COMMENT ON COLUMN targets.urls.summary IS 'Aggregated results or metadata from worker outputs';
COMMENT ON COLUMN targets.urls.discovery_crawl_id IS 'Discovery crawl ID if applicable';


-- Indexes to improve query performance
CREATE INDEX idx_urls_url ON targets.urls(url);            -- For direct URL lookups
CREATE INDEX idx_urls_domain_id ON targets.urls(domain_id);-- For domain-based queries

-- Trigger to automatically update the 'updated_at' timestamp
CREATE TRIGGER urls_updated_at_trigger
AFTER UPDATE ON targets.urls
FOR EACH ROW EXECUTE FUNCTION toolbox.update_timestamp_on_change();
