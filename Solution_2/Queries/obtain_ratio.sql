-- Insert data into the 'ratio' table
INSERT INTO api.ratio (date, ratio)
SELECT all_nonfarm.date, (
	(TRIM(prod_private.valueinthousands)::FLOAT) / 
	(TRIM(all_nonfarm.valueinthousands)::FLOAT - TRIM(prod_private.valueinthousands)::FLOAT)
)::VARCHAR(16) AS ratio
FROM api.all_nonfarm
JOIN api.prod_private ON all_nonfarm.date = prod_private.date;