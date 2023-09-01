-- Init Script for GovA11y

-- Create a new database named "hasura"
CREATE DATABASE hasura;

-- Create a new user named "hasura" with the password "SecretsOfHasura"
CREATE USER hasura WITH PASSWORD 'SecretsOfHasura';

-- Grant all privileges on the "hasura" database to the user "hasura"
GRANT ALL PRIVILEGES ON DATABASE hasura TO hasura;

-- Create GovA11y
CREATE DATABASE gova11y;

GRANT ALL PRIVILEGES ON DATABASE gova11y TO hasura;


