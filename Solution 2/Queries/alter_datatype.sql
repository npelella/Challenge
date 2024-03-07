-- Alter the column type to NUMERIC
ALTER TABLE api.women_in_government
ALTER COLUMN valueinthousands TYPE NUMERIC USING (valueinthousands::NUMERIC);

-- Alter the column type to NUMERIC
ALTER TABLE api.women_in_government
ALTER COLUMN valueinthousands TYPE INTEGER USING (valueinthousands::INTEGER);

-- Alter the data type of 'ratio' in the 'ratio' table
ALTER TABLE api.ratio
ALTER COLUMN ratio TYPE NUMERIC(10,2) USING (ratio::NUMERIC);

-- Grant SELECT privileges on specific tables to web_anon
GRANT SELECT ON TABLE api.women_in_government TO web_anon;
GRANT SELECT ON TABLE api.ratio TO web_anon;

-- Grant web_anon role to authenticator
GRANT web_anon TO authenticator;