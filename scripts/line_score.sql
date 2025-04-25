SET @game_id = NULL;


SELECT 
    g.id AS game_id,
    qs.period_num,
    qs.is_ot,
    qs.points AS team_points,
    qs.team_id,
    t.name AS team_name,
    g.game_date,
    g.season_id
FROM quarter_scores qs
JOIN games g ON qs.game_id = g.id
JOIN teams t ON qs.team_id = t.id
WHERE qs.game_id = @game_id  -- Filter by team ID
ORDER BY g.game_date, qs.game_id, qs.period_num;
