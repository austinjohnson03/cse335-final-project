-- Show all active franchises
SELECT id, most_recent_name, year_founded
FROM franchises
WHERE is_active = TRUE;

-- Retrieve inactive franchises
SELECT id, most_recent_name, year_founded
FROM franchises
WHERE is_active = FALSE;

-- Number of active franchises in the NBA
SELECT COUNT(*) AS active_franchises
FROM franchises
WHERE is_active = TRUE;

-- Sort active franchises by year found
SELECT id, most_recent_name, year_founded
FROM franchises
WHERE is_active = TRUE
ORDER BY year_founded;
