-- Create Database

-- Create User(s)


-- Make Functions
--
CREATE OR REPLACE FUNCTION public.update_orgs_updated_at()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
                BEGIN
                  NEW.updated_at = NOW();
                  RETURN NEW;
                END;
                $function$
;

-- UpdatedAt
CREATE OR REPLACE FUNCTION public.update_updated_at()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
                        BEGIN
                          NEW.updated_at = NOW();
                          RETURN NEW;
                        END;
                        $function$
;




-- Setup Schemas
CREATE SCHEMA axe AUTHORIZATION a11ydata;
CREATE SCHEMA events AUTHORIZATION a11ydata;
CREATE SCHEMA orgs AUTHORIZATION a11ydata;
CREATE SCHEMA refs AUTHORIZATION a11ydata;
CREATE SCHEMA results AUTHORIZATION a11ydata;
CREATE SCHEMA targets AUTHORIZATION a11ydata;

-- Setup Targets
