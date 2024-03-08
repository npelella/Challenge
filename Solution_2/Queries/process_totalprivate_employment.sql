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

-- Insert data into the 'prod_private' table
INSERT INTO api.prod_private (date, valueinthousands)
SELECT CONCAT(period, ' ', year), value
FROM api.totalprivate_employment
WHERE series_id = 'CES0500000006';