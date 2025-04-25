SET @season_id = 42022;

SELECT
    t.name AS team_name,
    ROUND(AVG(tg.pts), 1) AS avg_points_per_game,
    ROUND(AVG(tg.fgm), 1) AS avg_field_goals_made,
    ROUND(AVG(tg.fga), 1) AS avg_field_goals_attempted,
    ROUND(AVG(tg.fgm / tg.fga), 3) AS avg_field_goal_percentage,
    ROUND(AVG(tg.reb), 1) AS avg_rebounds,
    ROUND(AVG(tg.ast), 1) AS avg_assists,
    ROUND(AVG(tg.stl), 1) AS avg_steals,
    ROUND(AVG(tg.blk), 1) AS avg_blocks,
    ROUND(AVG(tg.tov), 1) AS avg_turnovers,
    ROUND(AVG(tg.pf), 1) AS avg_personal_fouls
FROM team_games tg
JOIN teams t ON tg.team_id = t.id
JOIN games g ON tg.game_id = g.id
WHERE g.season_id = @season_id  -- Use the season_id here
GROUP BY t.id
ORDER BY team_name;

