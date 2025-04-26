SET @game_id = 22100001;

SELECT 
    g.id AS game_id,
    g.game_date,
    g.attendance,
    g.game_time,
    g.lead_changes,
    g.times_tied,
    home_team.name AS home_team_name,
    td.arena AS arena,
    th.pts AS home_team_points,
    away_team.name AS away_team_name,
    ta.pts AS away_team_points,
    (
        SELECT GROUP_CONCAT(CONCAT(o.first_name, ' ', o.last_name) ORDER BY go.official_id SEPARATOR ', ')
        FROM game_officials go
        JOIN officials o ON go.official_id = o.id
        WHERE go.game_id = g.id
    ) AS officials
FROM 
    games g
JOIN 
    team_games th ON g.id = th.game_id AND th.is_home = TRUE
JOIN 
    teams home_team ON th.team_id = home_team.id
JOIN 
    team_details td ON home_team.franchise_id = td.id
JOIN 
    team_games ta ON g.id = ta.game_id AND ta.is_home = FALSE
JOIN 
    teams away_team ON ta.team_id = away_team.id
WHERE 
    g.id = @game_id;