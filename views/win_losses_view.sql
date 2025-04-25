CREATE OR REPLACE VIEW win_loss_viewteam_schedule_view AS
SELECT
    t.name AS team_name,
    g.season_id,
    s.end_year,
    COUNT(CASE WHEN tg.pts > opp.pts THEN 1 END) AS wins,
    COUNT(CASE WHEN tg.pts < opp.pts THEN 1 END) AS losses
FROM games g
JOIN team_games tg ON g.id = tg.game_id  
JOIN teams t ON tg.team_id = t.id
JOIN team_games opp ON g.id = opp.game_id AND opp.team_id != tg.team_id
JOIN teams opp_t ON opp.team_id = opp_t.id
JOIN seasons s ON g.season_id = s.id
WHERE s.season_type = 'Regular Season'
GROUP BY t.name, g.season_id, s.end_year
ORDER BY g.season_id, t.name;


SET @end_year = 2022; -- Edit this variable to filter years

SELECT *
FROM team_schedule_view
WHERE (end_year = @end_year OR @end_year IS NULL) 
ORDER BY season_id, team_name;


