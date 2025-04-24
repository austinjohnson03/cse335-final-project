CREATE OR REPLACE VIEW team_schedule_view AS
SELECT
    g.id AS game_id,
    g.season_id,
    g.game_date,
    t.name AS team_name,
    tg.is_home,
    tg.pts AS team_score,
    opp_t.name AS opponent_name,
    opp.pts AS opponent_score 
FROM games g 
JOIN team_games tg ON g.id = tg.game_id  
JOIN teams t ON tg.team_id = t.id 
JOIN team_games opp ON g.id = opp.game_id AND opp.team_id != tg.team_id  
JOIN teams opp_t ON opp.team_id = opp_t.id  
WHERE tg.is_home = TRUE;

SELECT *
FROM team_schedule_view
WHERE team_name = 'Cleveland Cavaliers' AND season_id = 22021
ORDER BY game_date;