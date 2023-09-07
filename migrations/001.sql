-- Migration: 001

-- ------------------------------
-- Setup Healthchecker
-- ------------------------------
CREATE ROLE healthchecker WITH LOGIN;
-- Grant CONNECT perms
GRANT CONNECT ON DATABASE gova11y TO healthchecker;








