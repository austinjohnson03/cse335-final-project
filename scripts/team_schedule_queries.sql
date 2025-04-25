SELECT *
FROM team_schedule
WHERE team_name = 'Boston Celtics'
  AND season_id = (
      SELECT id
      FROM seasons
      WHERE end_year = 2021 AND season_type = 'Regular Season'
  )
ORDER BY game_date;
