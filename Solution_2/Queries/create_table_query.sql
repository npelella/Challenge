-- Drop schema, roles, and tables if they exist
DO $$

BEGIN
	IF EXISTS (SELECT 1 FROM pg_namespace WHERE nspname = 'api') THEN
		DROP SCHEMA IF EXISTS api CASCADE;
	END IF;

	IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'web_anon') THEN
		DROP ROLE IF EXISTS web_anon;
	END IF;

	IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'authenticator') THEN
		DROP ROLE IF EXISTS authenticator;
	END IF;
END $$;

-- Create schema
CREATE SCHEMA api;

-- Create roles
CREATE ROLE web_anon nologin;
CREATE ROLE authenticator noinherit login PASSWORD '1234';

-- Grant usage on schema to web_anon
GRANT USAGE ON SCHEMA api TO web_anon;

-- Create the table for government employment data
CREATE TABLE api.government_employment (
	series_id VARCHAR(24),
	year VARCHAR(24),
	period VARCHAR(24),
	value VARCHAR(24),
	footnote_code VARCHAR(24)
);

-- Create the table for women in government data
CREATE TABLE api.women_in_government (
	date VARCHAR(24),
	valueinthousands VARCHAR(24)
);

-- Create tables for 'totalnonfarm' and 'TotalPrivate_Employment'
CREATE TABLE api.totalnonfarm (
	series_id VARCHAR(16),
	year VARCHAR(16),
	period VARCHAR(16),
	value VARCHAR(16),
	footnote_code VARCHAR(16)
);

CREATE TABLE api.TotalPrivate_Employment (
	series_id VARCHAR(16),
	year VARCHAR(16),
	period VARCHAR(16),
	value VARCHAR(16),
	footnote_code VARCHAR(16)
);

-- Create the table for 'all_nonfarm' data
CREATE TABLE api.all_nonfarm (
	date VARCHAR(16),
	valueinthousands VARCHAR(16)
);

-- Create the table for 'prod_private' data
CREATE TABLE api.prod_private (
	date VARCHAR(16),
	valueinthousands VARCHAR(16)
);

-- Create the table for 'ratio' data
CREATE TABLE api.ratio (
	date VARCHAR(16),
	ratio VARCHAR(16)
);