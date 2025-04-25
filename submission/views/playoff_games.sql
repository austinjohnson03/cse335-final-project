CREATE OR REPLACE VIEW playoff_games AS
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
JOIN seasons s ON g.season_id = s.id
WHERE s.season_type = 'Playoffs';
