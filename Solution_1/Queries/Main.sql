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
	series_id VARCHAR(16),
	year VARCHAR(16),
	period VARCHAR(16),
	value VARCHAR(16),
	footnote_code VARCHAR(16)
);

COPY api.government_employment FROM :data_path1;

-- Update the 'period' column in the government employment table
UPDATE api.government_employment
SET period = 
CASE 
	WHEN period = 'M01' THEN 'January'
	WHEN period = 'M02' THEN 'Febrary'
	WHEN period = 'M03' THEN 'March'
	WHEN period = 'M04' THEN 'April'
	WHEN period = 'M05' THEN 'May'
	WHEN period = 'M06' THEN 'June'
	WHEN period = 'M07' THEN 'July'
	WHEN period = 'M08' THEN 'August'
	WHEN period = 'M09' THEN 'September'
	WHEN period = 'M10' THEN 'October'
	WHEN period = 'M11' THEN 'November'
	WHEN period = 'M12' THEN 'December'
	ELSE period
END;

-- Create the table for women in government data
CREATE TABLE api.women_in_government (
	date VARCHAR(16),
	valueinthousands VARCHAR(16)
);

-- Insert data into the 'women_in_government' table
INSERT INTO api.women_in_government (date, valueinthousands)
SELECT CONCAT(period, ' ', year), value
FROM api.government_employment
WHERE series_id = 'CES9000000010   ';

-- Alter the data type of 'valueinthousands' in the 'women_in_government' table
ALTER TABLE api.women_in_government
ALTER COLUMN valueinthousands TYPE INTEGER USING (valueinthousands::INTEGER);

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

-- Copy data into the 'totalnonfarm' and 'TotalPrivate_Employment' tables
COPY api.totalnonfarm FROM :data_path2;
COPY api.TotalPrivate_Employment FROM :data_path3;

-- Update the 'period' column in the 'totalprivate_employment' table
UPDATE api.totalprivate_employment
SET period = 
CASE 
	WHEN period = 'M01' THEN 'January'
	WHEN period = 'M02' THEN 'Febrary'
	WHEN period = 'M03' THEN 'March'
	WHEN period = 'M04' THEN 'April'
	WHEN period = 'M05' THEN 'May'
	WHEN period = 'M06' THEN 'June'
	WHEN period = 'M07' THEN 'July'
	WHEN period = 'M08' THEN 'August'
	WHEN period = 'M09' THEN 'September'
	WHEN period = 'M10' THEN 'October'
	WHEN period = 'M11' THEN 'November'
	WHEN period = 'M12' THEN 'December'
	ELSE period
END;

-- Update the 'period' column in the 'totalnonfarm' table
UPDATE api.totalnonfarm
SET period = 
CASE 
	WHEN period = 'M01' THEN 'January'
	WHEN period = 'M02' THEN 'Febrary'
	WHEN period = 'M03' THEN 'March'
	WHEN period = 'M04' THEN 'April'
	WHEN period = 'M05' THEN 'May'
	WHEN period = 'M06' THEN 'June'
	WHEN period = 'M07' THEN 'July'
	WHEN period = 'M08' THEN 'August'
	WHEN period = 'M09' THEN 'September'
	WHEN period = 'M10' THEN 'October'
	WHEN period = 'M11' THEN 'November'
	WHEN period = 'M12' THEN 'December'
	ELSE period
END;

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

-- Insert data into the 'all_nonfarm' table
INSERT INTO api.all_nonfarm (date, valueinthousands)
SELECT CONCAT(period, ' ', year), value
FROM api.totalnonfarm
WHERE series_id = 'CES0000000001   ';

-- Insert data into the 'prod_private' table
INSERT INTO api.prod_private (date, valueinthousands)
SELECT CONCAT(period, ' ', year), value
FROM api.totalprivate_employment
WHERE series_id = 'CES0500000006   ';

-- Insert data into the 'ratio' table
INSERT INTO api.ratio (date, ratio)
SELECT all_nonfarm.date, (
	(TRIM(prod_private.valueinthousands)::FLOAT) / 
	(TRIM(all_nonfarm.valueinthousands)::FLOAT - TRIM(prod_private.valueinthousands)::FLOAT)
)::VARCHAR(16) AS ratio
FROM api.all_nonfarm
JOIN api.prod_private ON all_nonfarm.date = prod_private.date;

-- Alter the data type of 'ratio' in the 'ratio' table
ALTER TABLE api.ratio
ALTER COLUMN ratio TYPE NUMERIC(10,2) USING (ratio::NUMERIC);

-- Grant SELECT privileges on specific tables to web_anon
GRANT SELECT ON TABLE api.women_in_government TO web_anon;
GRANT SELECT ON TABLE api.ratio TO web_anon;

-- Grant web_anon role to authenticator
GRANT web_anon TO authenticator;