SELECT *
FROM team_schedule
WHERE team_name = 'Boston Celtics'
  AND season_id = (
      SELECT id
      FROM seasons
      -- Year must be 2022 or 2023 for sample data
      WHERE end_year = 2023 AND season_type = 'Regular Season'
  )
ORDER BY game_date;
