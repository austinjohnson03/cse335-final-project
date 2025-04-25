SELECT *
FROM playoff_games
WHERE season_id = (
    SELECT id
    FROM seasons
    WHERE end_year = 2022 AND season_type = 'Playoffs'
  )
ORDER BY game_date;
